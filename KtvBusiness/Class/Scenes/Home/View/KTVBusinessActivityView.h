//
//  KTVBusinessActivityView.h
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/12.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTVBusinessActivityView : UIView

@property (nonatomic, copy) void (^activityCB)(NSDictionary *params);

@end
