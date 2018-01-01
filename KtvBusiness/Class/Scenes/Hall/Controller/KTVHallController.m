//
//  KTVHallController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/9.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVHallController.h"
#import "KTVOrderCell.h"

@interface KTVHallController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (strong, nonatomic) NSMutableArray *pendingDealList; // 待处理
@property (strong, nonatomic) NSMutableArray *dealList;  // 已响应
@property (assign, nonatomic) NSInteger requestType; // 0 待处理 1 已响应

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
    
    // 默认请求待处理
    [self requestByOrderStatu:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 网络

// 系统匹配的未响应的订单
- (void)requestByOrderStatu:(NSInteger)orderStatu {
    // orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
    NSString *username = safetyString([KTVCommon userInfo].username);
    NSNumber *ostatu = @(orderStatu);
    //username = @"18939865729";
    NSDictionary *params = @{@"username" : username, @"orderStatus" : ostatu};
    
    [KTVMainSvc postSearchOrderParams:params result:^(NSDictionary *result) {
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
    return cell;
}

#pragma mark - UISegmentController Value Change

- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.requestType = 0;
            // 待处理
            [self requestByOrderStatu:1];
        }
            break;
        case 1:
        {
            self.requestType = 1;
            // 已响应
            [self requestByOrderStatu:4];
        }
            break;
        default:
            break;
    }
}


@end
