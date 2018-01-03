//
//  JTVMineController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/9.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVMineController.h"
#import "KTVMineHeadCell.h"
#import "KTVMineOptionCell.h"
#import "KTVAboutAppController.h"
#import "KTVHistoryOrderController.h"
#import "KTVSettingController.h"
#import "KTVStore.h"

@interface KTVMineController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray<NSString *> *_cellTitleList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) KTVStore *store;

@end

@implementation KTVMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor ktvBG];
    
    [self initData];
    
    [self loadStore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initData {
    _cellTitleList = [NSMutableArray arrayWithObjects:@"历史订单",@"设置", @"关于", nil];
}

#pragma mark - 网络

- (void)loadStore {
    NSString *storeId = [KTVCommon getStoreId];
    safetyString(storeId);
    [KTVMainSvc getStore:storeId result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            KTVStore *store = [KTVStore yy_modelWithDictionary:result[@"data"]];
            self.store = store;
            
            [self.tableview reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 145.0f;
    } else if (indexPath.section == 1) {
        return 44.0f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            KTVHistoryOrderController *vc = (KTVHistoryOrderController *)[UIViewController storyboardName:@"Mine" storyboardId:@"KTVHistoryOrderController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            KTVSettingController *vc = [UIViewController storyboardName:@"Mine" storyboardId:@"KTVSettingController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            KTVAboutAppController *vc = (KTVAboutAppController *)[UIViewController storyboardName:@"Mine" storyboardId:@"KTVAboutAppController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KTVMineHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVMineHeadCell"];
        cell.store = self.store;
        return cell;
    } else if (indexPath.section == 1) {
        NSString *title = _cellTitleList[indexPath.row];
        KTVMineOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVMineOptionCell"];
        cell.optTitle = title;
        return cell;
    }
    return [UITableViewCell new];
}

@end
