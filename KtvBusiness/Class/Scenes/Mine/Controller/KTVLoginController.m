//
//  KTVLoginController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/24.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVLoginController.h"

@interface KTVLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation KTVLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customTextFieldPlaceholderColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)customTextFieldPlaceholderColor {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17]; // 设置font
    attrs[NSForegroundColorAttributeName] = [UIColor ktvGray]; // 设置颜色
    
    NSAttributedString *accountStr = [[NSAttributedString alloc] initWithString:@"请填写电话号码" attributes:attrs]; // 初始化富文本占位字符串
    self.accountTF.attributedPlaceholder = accountStr;
    
    NSAttributedString *passwordStr = [[NSAttributedString alloc] initWithString:@"请填写密码" attributes:attrs]; // 初始化富文本占位字符串
    self.passwordTF.attributedPlaceholder = passwordStr;
    
}

#pragma mark - 网络

- (void)gotoLogin {
    NSString *account = safetyString(self.accountTF.text);
    NSString *password = safetyString(self.passwordTF.text);
    if (account.length || password.length) {
        NSDictionary *param = @{@"phone" : account, @"password" : password};
        [MBProgressHUD showMessage:@"登陆中..."];
        weakify(self);
        [KTVMainSvc postCommonLoginParams:param result:^(NSDictionary *result) {
            [MBProgressHUD hiddenHUD];
            if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
                if (weakself.loginSuccessBC) {
                    weakself.loginSuccessBC();
                }
                [KTVToast toast:@"登陆成功"];
                NSString *token = result[@"data"][@"token"];
                [KTVCommon saveKvtToken:token];
                [KTVCommon setUserInfoKey:@"phone" infoValue:account];
                [KTVCommon setUserInfoKey:@"username" infoValue:account];
            }
        }];
    } else {
        [KTVToast toast:@"补全信息再提交登陆"];
    }
}

#pragma mark - 事件

- (IBAction)loginAction:(UIButton *)sender {
    [self gotoLogin];
}


@end