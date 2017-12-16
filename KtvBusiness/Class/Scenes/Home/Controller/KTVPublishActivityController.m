//
//  KTVPublishActivityController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/12.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVPublishActivityController.h"
#import "KTVBusinessActivityView.h"

@interface KTVPublishActivityController ()

@end

@implementation KTVPublishActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布商家活动";
    self.view.backgroundColor = [UIColor ktvBG];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化UI

- (void)initUI {
    KTVBusinessActivityView *activityView = [[[NSBundle mainBundle] loadNibNamed:@"KTVBusinessActivityView" owner:nil options:nil] lastObject];
    [self.view addSubview:activityView];
    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(@800);
    }];
    
    UIView *activityBgView = [[UIView alloc] init];
    [self.view addSubview:activityBgView];
    [activityBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.view);
        make.height.mas_equalTo(@65);
    }];
    
    UIButton *confirmPublishBtn = [[UIButton alloc] init];
    [activityBgView addSubview:confirmPublishBtn];
    [confirmPublishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    confirmPublishBtn.backgroundColor = [UIColor ktvRed];
    confirmPublishBtn.layer.cornerRadius = 8;
    [confirmPublishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(activityBgView);
        make.width.equalTo(activityBgView).multipliedBy(0.8);
        make.height.mas_equalTo(@40);
    }];
}

@end
