//
//  KTVSettingController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/24.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVSettingController.h"

@interface KTVSettingController ()

@end

@implementation KTVSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutAction:(id)sender {
    CLog(@"--->>> 退出登陆");
    NSString *token = [KTVCommon ktvToken];
    NSDictionary *params = @{@"token" : safetyString(token)};
    
    [MBProgressHUD showMessage:@"注销登录中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KTVMainSvc postLogoutParams:params result:^(NSDictionary *result) {
            [MBProgressHUD hiddenHUD];
            if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
                UINavigationController *rootNav = (UINavigationController *)self.tabBarController.parentViewController;
                [rootNav popViewControllerAnimated:YES];
                
                // 注销本地数据
                [KTVCommon removeKtvToken];
                [KTVCommon resignUserInfo];
            } else {
                [KTVToast toast:@"无法退出"];
            }
        }];
    });
}


@end
