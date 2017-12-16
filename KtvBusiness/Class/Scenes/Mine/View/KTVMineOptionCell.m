//
//  KTVMineOptionCell.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/16.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVMineOptionCell.h"

@interface KTVMineOptionCell()

@property (weak, nonatomic) IBOutlet UILabel *optionTitle;

@end

@implementation KTVMineOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOptTitle:(NSString *)optTitle {
    if (_optTitle != optTitle) {
        _optTitle = optTitle;
        
        self.optionTitle.text = _optTitle;
    }
}

@end
