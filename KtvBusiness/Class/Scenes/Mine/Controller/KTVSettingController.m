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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
