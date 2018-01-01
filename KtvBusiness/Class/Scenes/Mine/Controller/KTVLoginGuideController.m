
//
//  KTVLoginGuideController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/24.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVLoginGuideController.h"
#import "KTVBaseTabBarViewController.h"
#import "KTVLoginController.h"

@interface KTVLoginGuideController ()

@end

@implementation KTVLoginGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ktvBG];
    
    [self rootOfLoginViewController];

    if ([self isLogin]) {
        [self pushOfMainTabbarControllerByPush];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isLogin {
    NSString *ktvtoken = [KTVCommon ktvToken];
    return ktvtoken ? YES : NO;
}

- (void)rootOfLoginViewController {
    // 默认登陆作为第一个栈里面的第一个页面
    KTVLoginController *loginVC = [UIViewController storyboardName:@"Mine" storyboardId:@"KTVLoginController"];
    self.navigationController.navigationBar.hidden = YES;
    weakify(self);
    loginVC.loginSuccessBC = ^{
        [weakself pushOfMainTabbarControllerByPush];
    };
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (void)pushOfMainTabbarControllerByPush {
    KTVBaseTabBarViewController *rootVC = [UIViewController storyboardName:@"Main" storyboardId:@"KTVBaseTabBarViewController"];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:rootVC animated:NO];
}

@end
