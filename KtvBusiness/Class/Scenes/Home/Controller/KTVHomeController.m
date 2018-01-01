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

@interface KTVHomeController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *homeSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray<KTVOrder *> *matchOrderList;
@property (strong, nonatomic) NSMutableArray<KTVBanner *> *bannerList;

@end

@implementation KTVHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.backgroundColor = [UIColor ktvBG];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setupRefresh];
    
    safetyArray(self.matchOrderList);
    safetyArray(self.bannerList);
    
    [self loadNewMatchOrder];
    [self loadUserInfo];
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

// 系统匹配的未响应的订单
- (void)loadNewMatchOrder {
    // orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
    NSString *username = safetyString([KTVCommon userInfo].username);
    NSNumber *orderStatu = @(0);
    //username = @"18939865729";
    NSDictionary *params = @{@"username" : username, @"orderStatus" : orderStatu};
    
    [KTVMainSvc postSearchOrderParams:params result:^(NSDictionary *result) {
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

#pragma mark - 事件

- (IBAction)locationAction:(UIButton *)sender {
    CLog(@"首页地理位置");
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
        NSArray *imgUrls = @[@"https://4.bp.blogspot.com/-cSkCJRk_MXM/U5yaVSt2JJI/AAAAAAAA-S0/KSLqYLNoiyw/s0/Girl+fashion+beauty.jpg",
                             @"https://s10.favim.com/orig/160322/beauty-girl-hair-makeup-Favim.com-4104900.jpg",
                             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1501749823122&di=b250a8c94d39c217440391f9e6696af2&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F15%2F24%2F50%2F43Q58PICkj4_1024.jpg"];
        
        NSMutableArray *imgurlList = [NSMutableArray array];
        for (KTVBanner *banner in self.bannerList) {
            [imgurlList addObject:banner.picture.pictureUrl];
        }
        
        KTVBannerCell *cell = (KTVBannerCell *)[tableView dequeueReusableCellWithIdentifier:KTVStringClass(KTVBannerCell)];
        if (!cell) {
            cell = [[KTVBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KTVStringClass(KTVBannerCell)];
        }
        cell.sdBannerView.delegate = self;
        cell.sdBannerView.imageURLStringsGroup = imgUrls;
        return cell;
    } else if (indexPath.section == 1) {
        weakify(self)
        KTVPublishActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVPublishActivityCell"];
        cell.publishActivityCallBack = ^{
            strongify(self);
            KTVPublishActivityController *vc = [[KTVPublishActivityController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else if (indexPath.section == 2) {
        KTVOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVOrderCell"];
        cell.order = self.matchOrderList[indexPath.row];
        // 响应
        cell.responseOrderCB = ^(KTVOrder *order) {
            
        };
        // 忽略
        cell.ignoreOrderCB = ^(KTVOrder *order) {
            
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
}

@end
