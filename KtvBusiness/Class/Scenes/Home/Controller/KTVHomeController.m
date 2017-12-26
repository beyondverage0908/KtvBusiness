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
#import "KTVLoginController.h"

@interface KTVHomeController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *homeSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation KTVHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.backgroundColor = [UIColor ktvBG];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
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
        return 0;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
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
        return [UITableViewCell new];
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
        return cell;
    }
    return [UITableViewCell new];
}

@end
