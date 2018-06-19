//
//  KTVHomeController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/9.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVHomeController.h"
#import "KTVPublishActivityCell.h"
#import "KTVOrderCell.h"
#import "KTVTableHeaderView.h"
#import "KTVPublishActivityController.h"
#import "KTVOrder.h"
#import "KTVBannerCell.h"
#import "KTVBanner.h"
#import "MJRefresh.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "JHPickView.h"
#import "KSPhotoBrowser.h"

@interface KTVHomeController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, AMapLocationManagerDelegate, JHPickerDelegate, UIScrollViewDelegate, KSPhotoBrowserDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *homeSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray<KTVOrder *> *matchOrderList;
@property (strong, nonatomic) NSMutableArray<KTVBanner *> *bannerList;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@implementation KTVHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.backgroundColor = [UIColor ktvBG];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setupRefresh];
    
    self.homeSearchBar.delegate = self;
    
    safetyArray(self.matchOrderList);
    safetyArray(self.bannerList);
    
    [self loadNewMatchOrder];
    [self loadUserInfo];
    [self updateBPushChannelId];
    [self loadMianBanner];
    
    // 初始化你地理编码回调
    [self initReGecodeLocationCompleteBlock];
    // 配置地理位置定位
    [self configLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideNavigationBar:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - 刷新设置

- (void)setupRefresh
{
    weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewMatchOrder];
    }];;
    header.lastUpdatedTimeLabel.hidden = NO;
    header.labelLeftInset = 30;
    [header setTitle:@"获取最新订单" forState:MJRefreshStatePulling];
    [header setTitle:@"获取最新订单中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新获取最新订单" forState:MJRefreshStateIdle];
    self.tableview.mj_header = header;
    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    [footer setTitle:@"释放加载" forState:MJRefreshStatePulling];
//    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
//    self.tableview.mj_footer = footer;
}

#pragma mark - 网络

- (void)loadMianBanner {
    [KTVMainSvc getMainBanner:nil result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            for (NSDictionary *dic in result[@"data"]) {
                KTVBanner *banner = [KTVBanner yy_modelWithDictionary:dic];
                [self.bannerList addObject:banner];
            }
            [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

// 系统匹配的未响应的订单
- (void)loadNewMatchOrder {
    // orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
    NSString *storeId = [KTVCommon getStoreId];
    if (storeId) {
        NSDictionary *params = @{@"storeId" : storeId, @"orderStatus" : @(0)};
        [KTVMainSvc postSearchStoreOrder:params result:^(NSDictionary *result) {
            [self.tableview.mj_header endRefreshing];
            if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
                if ([result[@"data"] count]) {
                    [self.matchOrderList removeAllObjects];
                    for (NSDictionary *dic in result[@"data"]) {
                        KTVOrder *order = [KTVOrder yy_modelWithDictionary:dic];
                        [self.matchOrderList addObject:order];
                    }
                    [self.tableview reloadData];
                } else {
                    [KTVToast toast:@"系统暂未匹配到订单"];
                }
            }
        }];
    }
}

/// 缓存用户信息
- (void)loadUserInfo {
    NSString *phone = [KTVCommon userInfo].phone;
    safetyString(phone);
    [KTVMainSvc getUserInfoWithPhone:phone result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            [KTVCommon saveUserInfo:result[@"data"]];
        }
    }];
}

- (void)updateBPushChannelId {
    NSString *channelId = [KTVCommon channelId];
    NSString *username = [KTVCommon userInfo].phone;
    // phonetype 3 安卓手机 4 苹果手机
    // channelId  需要前端传过来
    if (username.length && channelId.length) {
        NSDictionary *params = @{@"username" : username, @"channelId" : channelId, @"phoneType" : @4};
        [KTVMainSvc postUpdateBPushChannel:params result:^(NSDictionary *result) {}];
    }
}

- (void)changeOrderStatus:(NSDictionary *)params successToast:(NSString *)toast {
    [MBProgressHUD showMessage:@"请等待..."];
    [KTVMainSvc postUpdateOrderStatus:params result:^(NSDictionary *result) {
        [MBProgressHUD hiddenHUD];
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            [KTVToast toast:toast];
            [self loadNewMatchOrder];
        } else {
            [KTVToast toast:result[@"detail"]];
        }
    }];
}

#pragma mark - 事件

- (IBAction)locationAction:(UIButton *)sender {
    CLog(@"首页地理位置");
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    JHPickView *locationPickView = [[JHPickView alloc] initWithFrame:keyWindow.bounds];
    locationPickView.delegate = self;
    locationPickView.arrayType = AreaArray;
    [keyWindow addSubview:locationPickView];
}

- (IBAction)scanQR:(UIButton *)sender {
    CLog(@"-->> 扫码");
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        NSInteger matchOrderNumber = self.matchOrderList.count;
        return matchOrderNumber;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 145.0f;
    } else if (indexPath.section == 1) {
        return 64.0f;
    } else if (indexPath.section == 2) {
        return 210.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        KTVTableHeaderView *view = [[KTVTableHeaderView alloc] initWithImageUrl:nil title:@"系统匹配的订单" remark:nil];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 33;
    }
    return 0;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSMutableArray *imgUrlList = [NSMutableArray array];
        for (KTVBanner *banner in self.bannerList) {
            [imgUrlList addObject:banner.picture.pictureUrl];
        }
        KTVBannerCell *cell = (KTVBannerCell *)[tableView dequeueReusableCellWithIdentifier:KTVStringClass(KTVBannerCell)];
        if (!cell) {
            cell = [[KTVBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KTVStringClass(KTVBannerCell)];
        }
        cell.sdBannerView.delegate = self;
        cell.sdBannerView.imageURLStringsGroup = imgUrlList;
        return cell;
    } else if (indexPath.section == 1) {
        weakify(self)
        KTVPublishActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVPublishActivityCell"];
        cell.publishActivityCallBack = ^{
            strongify(weakself);
            KTVPublishActivityController *vc = [[KTVPublishActivityController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else if (indexPath.section == 2) {
        weakify(self);
        KTVOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVOrderCell"];
        cell.order = self.matchOrderList[indexPath.row];
        // 响应
        cell.responseOrderCB = ^(KTVOrder *order) {
            NSDictionary *params = @{@"subStoreId" : order.subOrderId, @"orderStatus" : @(2)};
            [weakself changeOrderStatus:params successToast:@"响应成功"];
        };
        // 忽略
        cell.ignoreOrderCB = ^(KTVOrder *order) {
            NSDictionary *params = @{@"subStoreId" : order.subOrderId, @"orderStatus" : @(3)};
            [weakself changeOrderStatus:params successToast:@"已忽略"];
        };
        // 确认消费
        cell.confirmConsumptionCB = ^(KTVOrder *order) {
            
        };
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    CLog(@"--%@--main page banner click", @(index));
    NSMutableArray *urlItems = @[].mutableCopy;
    for (KTVBanner *banner in self.bannerList) {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:[UIImageView new] imageUrl:[NSURL URLWithString:banner.picture.pictureUrl]];
        [urlItems addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:urlItems selectedIndex:index];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
}

#pragma mark - 地理位置相关

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
    [self startReGeocode];
}

- (void)startReGeocode {
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)initReGecodeLocationCompleteBlock
{
    __weak KTVHomeController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //修改label显示内容
        if (regeocode) {
//            [weakSelf.locationBtn setText:[NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            [weakSelf.locationBtn setTitle:[NSString stringWithFormat:@"%@", regeocode.city] forState:UIControlStateNormal]; 
        } else {
            NSString *latitude = @(location.coordinate.latitude).stringValue;
            NSString *longitude = @(location.coordinate.longitude).stringValue;
//            [weakSelf.displayLabel setText:[NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]];
        }
    };
}

#pragma mark - PickerSelectorIndixString

- (void)PickerSelectorIndixString:(NSString *)str {
    NSArray *citys = [str componentsSeparatedByString:@" "];
    [self.locationBtn setTitle:citys[citys.count - 1] forState:UIControlStateNormal];
}

#pragma mark - KSPhotoBrowserDelegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    NSLog(@"-->> %@", @(index));}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.homeSearchBar isFirstResponder]) {
        [self.homeSearchBar resignFirstResponder];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
