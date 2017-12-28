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
@property (weak, nonatomic) IBOutlet UILabel *castTypeLabel; // 消费类型，卡座 - 包厢等
@property (weak, nonatomic) IBOutlet UILabel *activityNickname; // 暖场人昵称
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel; // 消费金额
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel; // 是否到店消费，订单结束等
@property (weak, nonatomic) IBOutlet UILabel *usePasswordLabel; // 使用密码
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *responseBtn;
@property (weak, nonatomic) IBOutlet UIButton *ignoreBtn;

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

- (IBAction)confirmOrder:(UIButton *)sender {
    CLog(@"-->> 确认消费");
}

// orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
- (void)setOrder:(KTVOrder *)order {
    if (_order != order) {
        _order = order;
        
        self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号: %@", formatString(_order.orderId)];
        self.nicknameLabel.text = formatString(_order.user.nickName);
        self.castTypeLabel.text = [NSString stringWithFormat:@"%@预定", formatString([KTVCommon orderDescriptionType:_order.orderType])];
        self.activityNickname.text = [NSString stringWithFormat:@"暖场人: %@", formatString(_order.store.user.nickName)];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@元", formatString(_order.allMoney)];
        self.orderTimeLable.text = [NSString stringWithFormat:@"下单时间: %@", formatString(_order.createTime)];
        self.useTimeLabel.text = [NSString stringWithFormat:@"使用时间: %@", formatString(_order.startTime)];
        self.phoneLabel.text = [NSString stringWithFormat:@"电话: %@", formatString(_order.user.phone)];
        if (_order.orderStatus == 1) {
            self.orderStatusLabel.hidden = YES;
            self.confirmBtn.hidden = YES;
        } else {
            self.orderStatusLabel.hidden = NO;
            self.confirmBtn.hidden = NO;
        }
        if (_order.orderStatus == 4) {
            self.responseBtn.hidden = YES;
            self.ignoreBtn.hidden = YES;
        } else {
            self.responseBtn.hidden = NO;
            self.ignoreBtn.hidden = NO;
        }
        if (_order.orderStatus == 7) {
            self.confirmBtn.hidden = YES;
            self.responseBtn.hidden = YES;
            self.ignoreBtn.hidden = YES;
        } else {
            self.confirmBtn.hidden = NO;
            self.responseBtn.hidden = NO;
            self.ignoreBtn.hidden = NO;
        }
        self.orderStatusLabel.text = [NSString stringWithFormat:@"%@", [KTVCommon orderStatusDescriptin:_order.orderStatus]];
        self.usePasswordLabel.text = [NSString stringWithFormat:@"使用密码: %@", formatString(_order.usePassword)];
    }
}


@end
