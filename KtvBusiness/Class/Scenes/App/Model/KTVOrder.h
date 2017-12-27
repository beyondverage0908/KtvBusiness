//
//  KTVOrder.h
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/26.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KTVUser.h"
#import "KTVStore.h"

@interface KTVOrder : NSObject

@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, strong) KTVUser * user;
@property (nonatomic, strong) KTVStore * store;

@property (nonatomic, strong) NSString * subOrderId;
@property (nonatomic, strong) NSString * allMoney;
@property (nonatomic, strong) NSString * discountMoney;
@property (nonatomic, strong) NSString * payType;


@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, strong) NSArray * orderDetailList;
@property (nonatomic, assign) BOOL userHide;
@property (nonatomic, strong) NSString * usePassword;

@property (nonatomic, strong) NSString * des;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * changeId;

@end
