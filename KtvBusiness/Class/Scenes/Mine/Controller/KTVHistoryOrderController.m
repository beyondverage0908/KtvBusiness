//
//  KTVHistoryOrderController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/16.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVHistoryOrderController.h"
#import "KTVOrderCell.h"

@interface KTVHistoryOrderController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation KTVHistoryOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor ktvBG];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210.0f;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTVOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVOrderCell"];
    return cell;
}

@end
