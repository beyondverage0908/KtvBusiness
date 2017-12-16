//
//  KTVPublishActivityCell.h
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/10.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTVPublishActivityCell : UITableViewCell

@property (nonatomic, copy) void (^publishActivityCallBack)(void);

@end
