//
//  KTVMineHeadCell.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/16.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVMineHeadCell.h"

@interface KTVMineHeadCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *headerImageView; // 头像
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel; // 商户名称
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation KTVMineHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.businessNameLabel.text = @"小天面包店";
    NSString *phone = [KTVCommon userInfo].phone;
    self.phoneLabel.text = safetyString(phone);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)clickHeadAction:(UIButton *)sender {
    CLog(@"-->> 头像点击");
}

@end
