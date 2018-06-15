//
//  KTVHallController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/9.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVHallController.h"
#import "KTVOrderCell.h"
#import "MJRefresh.h"
#import "JHPickView.h"

@interface KTVHallController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (strong, nonatomic) NSMutableArray *pendingDealList; // 待处理
@property (strong, nonatomic) NSMutableArray *dealList;  // 已响应
@property (assign, nonatomic) NSInteger requestType; // 0 待处理 1 已响应
@property (assign, nonatomic) NSInteger currentOrderStatus;

@end

@implementation KTVHallController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接单大厅";
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor ktvBG];
    
    // 初始化数组
    safetyArray(self.pendingDealList);
    safetyArray(self.dealList);
    
    // 待处理 - 获取已支付的订单
    self.currentOrderStatus = 0;
    
    // 默认请求待处理
    [self requestByOrderStatu:self.currentOrderStatus];
    
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupRefresh
{
    weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestByOrderStatu:self.currentOrderStatus];
    }];;
    header.lastUpdatedTimeLabel.hidden = NO;
    header.labelLeftInset = 30;
    [header setTitle:@"获取订单" forState:MJRefreshStatePulling];
    [header setTitle:@"获取订单中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新订单" forState:MJRefreshStateIdle];
    self.tableview.mj_header = header;
}

#pragma mark - 网络

// 系统匹配的未响应的订单
- (void)requestByOrderStatu:(NSInteger)orderStatu {
    // orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
    NSString *username = safetyString([KTVCommon userInfo].username);
    NSNumber *ostatu = @(orderStatu);
    //username = @"18939865729";
    NSDictionary *params = @{@"username" : username, @"orderStatus" : ostatu};
    
    [MBProgressHUD showMessage:@"订单查询中..."];
    [KTVMainSvc postSearchOrderParams:params result:^(NSDictionary *result) {
        [self.tableview.mj_header endRefreshing];
        [MBProgressHUD hiddenHUD];
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            if ([result[@"data"] count] > 0) {
                if (self.requestType == 0) {
                    [self.pendingDealList removeAllObjects];
                } else {
                    [self.dealList removeAllObjects];
                }
            } else {
                [KTVToast toast:@"暂无此条件订单"];
            }
            for (NSDictionary *dic in result[@"data"]) {
                KTVOrder *order = [KTVOrder yy_modelWithDictionary:dic];
                if (self.requestType == 0) {
                    [self.pendingDealList addObject:order];
                } else {
                    [self.dealList addObject:order];
                }
            }
            
            [self.tableview reloadData];
        }
    }];
}

// 更改订单状态
- (void)changeOrderStatus:(NSDictionary *)params successToast:(NSString *)toast {
    [MBProgressHUD showMessage:@"请等待..."];
    [KTVMainSvc postUpdateOrderStatus:params result:^(NSDictionary *result) {
        [MBProgressHUD hiddenHUD];
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            [KTVToast toast:toast];
            [self requestByOrderStatu:self.currentOrderStatus];
        } else {
            [KTVToast toast:result[@"detail"]];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.requestType == 0) {
        return [self.pendingDealList count];
    } else {
        return [self.dealList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210.0f;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTVOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVOrderCell"];
    KTVOrder *order = nil;
    if (self.requestType == 0) {
        order = self.pendingDealList[indexPath.row];
    } else {
        order = self.dealList[indexPath.row];
    }
    cell.order = order;
    weakify(self);
    // 响应
    cell.responseOrderCB = ^(KTVOrder *order) {
        NSDictionary *params = @{@"subStoreId" : order.orderId, @"orderStatus" : @(4)};
        [weakself changeOrderStatus:params successToast:@"响应成功"];
    };
    // 忽略
    cell.ignoreOrderCB = ^(KTVOrder *order) {
        NSDictionary *params = @{@"subStoreId" : order.orderId, @"orderStatus" : @(3)};
        [weakself changeOrderStatus:params successToast:@"已忽略"];
    };
    cell.confirmConsumptionCB = ^(KTVOrder *order) {
        NSDictionary *params = @{@"subStoreId" : order.orderId, @"orderStatus" : @(7)};
        [weakself changeOrderStatus:params successToast:@"订单已经确认消费"];
    };
    return cell;
}

#pragma mark - UISegmentController Value Change

- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.requestType = 0;
            // 待处理
            self.currentOrderStatus = 0;
            [self requestByOrderStatu:self.currentOrderStatus];
        }
            break;
        case 1:
        {
            self.requestType = 1;
            // 已响应
            self.currentOrderStatus = 4;
            [self requestByOrderStatu:self.currentOrderStatus];
        }
            break;
        default:
            break;
    }
}


@end
