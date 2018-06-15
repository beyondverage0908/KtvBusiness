//
//  KTVMyMoneyPacageController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2018/3/3.
//  Copyright © 2018年 ktv. All rights reserved.
//

#import "KTVMyMoneyPacageController.h"

@interface KTVMyMoneyPacageController ()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation KTVMyMoneyPacageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAccountBalance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 网络

- (void)getAccountBalance {
    NSString *phone = [KTVCommon userInfo].phone;
    weakify(self);
    [KTVMainSvc getAccountBalance:phone result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            weakself.balanceLabel.text = [NSString stringWithFormat:@"%@元", result[@"data"]];
        }
    }];
}

@end
