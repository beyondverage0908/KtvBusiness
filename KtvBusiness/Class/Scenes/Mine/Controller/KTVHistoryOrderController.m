//
//  KTVHistoryOrderController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/16.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVHistoryOrderController.h"
#import "KTVOrderCell.h"
#import "MJRefresh.h"

@interface KTVHistoryOrderController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *historyOrderList;

@end

@implementation KTVHistoryOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor ktvBG];
    [self setupRefresh];
    
    safetyArray(self.historyOrderList);
    
    // 已经结束的订单
    [self requestByOrderStatu:7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 刷新设置

- (void)setupRefresh
{
    weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestByOrderStatu:7];
    }];;
    header.lastUpdatedTimeLabel.hidden = NO;
    header.labelLeftInset = 30;
    [header setTitle:@"获取历史订单" forState:MJRefreshStatePulling];
    [header setTitle:@"获取历史订单中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新历史订单" forState:MJRefreshStateIdle];
    self.tableview.mj_header = header;
    
    //    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //    [footer setTitle:@"释放加载" forState:MJRefreshStatePulling];
    //    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    //    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    //    self.tableview.mj_footer = footer;
}

#pragma mark - 网络

// 系统匹配的未响应的订单
- (void)requestByOrderStatu:(NSInteger)orderStatu {
    // orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
    NSString *username = safetyString([KTVCommon userInfo].username);
    NSNumber *ostatu = @(orderStatu);
    username = @"18939865729";
    NSDictionary *params = @{@"username" : username, @"orderStatus" : ostatu};
    
    [KTVMainSvc postSearchOrderParams:params result:^(NSDictionary *result) {
        [self.tableview.mj_header endRefreshing];
        
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            if ([result[@"data"] count] > 0) {
                [self.historyOrderList removeAllObjects];
            } else {
                [KTVToast toast:@"暂无历史条件订单"];
            }
            for (NSDictionary *dic in result[@"data"]) {
                KTVOrder *order = [KTVOrder yy_modelWithDictionary:dic];
                [self.historyOrderList addObject:order];
            }
            
            [self.tableview reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyOrderList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210.0f;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTVOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVOrderCell"];
    KTVOrder *order = self.historyOrderList[indexPath.row];
    cell.order = order;
    return cell;
}

@end
