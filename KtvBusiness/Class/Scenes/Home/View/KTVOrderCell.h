//
//  KTVOrderCell.h
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/10.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTVOrder.h"

@interface KTVOrderCell : UITableViewCell

@property (nonatomic, strong) KTVOrder *order;

@property (nonatomic, copy) void (^responseOrderCB)(KTVOrder *order);
@property (nonatomic, copy) void (^ignoreOrderCB)(KTVOrder *order);
@property (nonatomic, copy) void (^confirmConsumptionCB)(KTVOrder *order);

@end
