//
//  KTVOrderCell.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/10.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVOrderCell.h"

@interface KTVOrderCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *castTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityNickname;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation KTVOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)responseOrderAction:(id)sender {
    CLog(@"-->> 响应订单");
}

- (IBAction)ignoreOrderAction:(id)sender {
    CLog(@"-->> 忽略订单");
}



@end
