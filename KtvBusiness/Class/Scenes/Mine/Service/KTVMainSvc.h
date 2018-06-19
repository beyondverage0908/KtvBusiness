//
//  KTVMainSvc.h
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/24.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求成功block
typedef void(^ResponseSuccess)(NSDictionary *result);

@interface KTVMainSvc : NSObject

/// 登陆
+ (void)postCommonLoginParams:(NSDictionary *)params result:(ResponseSuccess)responseResult;

/// 获取门店信息
+ (void)getStore:(NSString *)storeId result:(ResponseSuccess)responseResult;

/// 查询订单
+ (void)postSearchOrderParams:(NSDictionary *)params result:(ResponseSuccess)responseResult;

/// 退出登陆
+ (void)postLogoutParams:(NSDictionary *)params result:(ResponseSuccess)responseResult;

/// 获取用户信息
+ (void)getUserInfoWithPhone:(NSString *)phone result:(ResponseSuccess)responseResult;

/// 根据账号，获取商家信息，
+ (void)getQueryStore:(NSString *)phone result:(ResponseSuccess)responseResult;

/// 获取账户余额
+ (void)getAccountBalance:(NSString *)phone result:(ResponseSuccess)responseResult;

/// 更新用户channelid
+ (void)postUpdateBPushChannel:(NSDictionary *)params result:(ResponseSuccess)responseResult;

/// 更改订单状态
+ (void)postUpdateOrderStatus:(NSDictionary *)params result:(ResponseSuccess)responseResult;

/// 获取首页banner
+ (void)getMainBanner:(NSString *)params result:(ResponseSuccess)responseResult;

/// 商家端查询门店订单接口
+ (void)postSearchStoreOrder:(NSDictionary *)params result:(ResponseSuccess)responseResult;

@end
