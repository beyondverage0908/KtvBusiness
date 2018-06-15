//
//  KTVCommon.h
//  KTVBariOS
//
//  Created by pingjun lin on 2017/9/5.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTVUser.h"
#import "KTVAddress.h"

@interface KTVCommon : NSObject
/// 判断用户是否登陆状态
+ (BOOL)isLogin;
/// 获取用户信息
+ (KTVUser *)userInfo;
/// 删除用户信息
+ (void)resignUserInfo;
/// 保存用户信息
+ (void)saveUserInfo:(NSDictionary *)userInfo;
/// 设置用户信息
+ (void)setUserInfoKey:(NSString *)infoKey infoValue:(NSString *)infoValue;
/// 保持ktv token
+ (void)saveKvtToken:(NSString *)ktvToken;
/// 获取token
+ (NSString *)ktvToken;
/// 本地化storeId
+ (void)saveStoreId:(NSString *)storeId;
/// 获取storeId
+ (NSString *)getStoreId;
/// 移除token
+ (void)removeKtvToken;
/// 以key值为 lat:long(纬经)
+ (void)saveUserLocation:(NSString *)locationString;
/// 返回经纬度数组，纬度为第一个元素，经度为第二个元素，获取不到则为nil
+ (KTVAddress *)getUserLocation;
/// 根据订单类型获获取具体订单
+ (NSString *)orderDescriptionType:(NSInteger)type;
// orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
+ (NSString *)orderStatusDescriptin:(NSInteger)orderStatus;
/// 保存channel id
+ (void)saveChannelId:(NSString *)channelId;
+ (NSString *)channelId;

@end
