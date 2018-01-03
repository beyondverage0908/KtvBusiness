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
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView; // 头像
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel; // 商户名称
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation KTVMineHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *phone = [KTVCommon userInfo].phone;
    self.phoneLabel.text = safetyString(phone);
    
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadAction:)];
    [self.headerImageView addGestureRecognizer:headerTapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)clickHeadAction:(UITapGestureRecognizer *)sender {
    CLog(@"-->> 头像点击");
}

- (void)setStore:(KTVStore *)store {
    if (_store != store) {
        _store = store;
        
        self.businessNameLabel.text = _store.storeName;
        
        if (_store.pictureList.count >= 1) {
            KTVPicture *picture = _store.pictureList[0];
            NSURL *url = [NSURL URLWithString:picture.pictureUrl];
            [self.headerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ktv_user_placehoder"]];
        }
        if (_store.pictureList.count >= 2) {
            KTVPicture *picture = _store.pictureList[1];
            NSURL *url = [NSURL URLWithString:picture.pictureUrl];
            [self.headerBackgroundImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ktv_header_placeholder"]];
        }
    }
}

@end
