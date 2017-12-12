//
//  KTVPublishActivityCell.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/10.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVPublishActivityCell.h"

@implementation KTVPublishActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)publishBusinessActivity:(UIButton *)sender {
    CLog(@"-->> 发布商家活动");
}


@end
