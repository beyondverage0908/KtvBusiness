
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
    
    if ([self isLogin]) {
        [self rootControllerOfMainTabbarController];
    } else {
        KTVLoginController *loginVC = [UIViewController storyboardName:@"Mine" storyboardId:@"KTVLoginController"];
        weakify(self);
        loginVC.loginSuccessBC = ^{
            [weakself dismissViewControllerAnimated:YES completion:nil];
            [weakself rootControllerOfMainTabbarController];
        };
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isLogin {
    NSString *ktvtoken = [KTVCommon ktvToken];
    return ktvtoken ? YES : NO;
}

- (void)rootControllerOfMainTabbarController {
    KTVBaseTabBarViewController *rootVC = [UIViewController storyboardName:@"Main" storyboardId:@"KTVBaseTabBarViewController"];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

@end
