//
//  KTVBannerCell.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/28.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVBannerCell.h"

@implementation KTVBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorHex:@"#efeff4"];
        
        self.sdBannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENW, self.contentView.frame.size.height) delegate:nil placeholderImage:[UIImage imageNamed:@"dynamic_banner_placehold"]];
        self.sdBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.sdBannerView.pageDotColor = [UIColor whiteColor];
        self.sdBannerView.currentPageDotColor = [UIColor ktvRed];
        self.sdBannerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.sdBannerView.hidesForSinglePage = YES;
        [self.contentView addSubview:self.sdBannerView];
        
        UIView *superView = self.contentView;
        [self.sdBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superView);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
