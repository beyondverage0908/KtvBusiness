//
//  KTVCommon.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/9/5.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVCommon.h"


@implementation KTVCommon

+ (BOOL)isLogin {
    if ([KTVCommon userInfo].phone && [KTVCommon ktvToken]) {
        return YES;
    } else {
        return NO;
    }
}

+ (KTVUser *)userInfo {
    NSDictionary *userInfo = [KTVUtil objectForKey:@"ktvUserInfo"];
    KTVUser *user = [KTVUser yy_modelWithDictionary:userInfo];
    return user;
}

+ (void)resignUserInfo {
    [KTVUtil removeUserDefaultForKey:@"ktvUserInfo"];
    [self removeKtvToken];
}

+ (void)removeKtvToken {
    [KTVUtil removeUserDefaultForKey:@"ktvToken"];
}

+ (void)setUserInfoKey:(NSString *)infoKey infoValue:(NSString *)infoValue {
    NSDictionary *info = [KTVUtil objectForKey:@"ktvUserInfo"];
    if (!info) {
        info = [NSDictionary dictionary];
    }
    NSMutableDictionary *muUserInfo = [NSMutableDictionary dictionaryWithDictionary:info];
    if (!infoKey) {
        [muUserInfo removeObjectForKey:infoKey];
    }
    if (infoValue) {
        [muUserInfo setObject:infoValue forKey:infoKey];
    }
    if ([info[infoKey] isEqualToString:infoValue]) {
        return;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:muUserInfo];
    [KTVUtil setObject:userInfo forKey:@"ktvUserInfo"];
}

+ (void)saveUserInfo:(NSDictionary *)userInfo {
    [KTVUtil setObject:userInfo forKey:@"ktvUserInfo"];
}

+ (void)saveKvtToken:(NSString *)ktvToken {
    [KTVUtil setObject:ktvToken forKey:@"ktvToken"];
}

+ (NSString *)ktvToken {
    return [KTVUtil objectForKey:@"ktvToken"];
}

+ (void)saveUserLocation:(NSString *)locationString {
    [KTVUtil setObject:locationString forKey:@"lat:long"];
}

+ (KTVAddress *)getUserLocation {
    NSString *latlong = [KTVUtil objectForKey:@"lat:long"];
    NSArray *locationArr = nil;
    if (latlong) {
        locationArr = [latlong componentsSeparatedByString:@":"];
    }
    KTVAddress *address = [[KTVAddress alloc] init];
    address.latitude = [[locationArr firstObject] doubleValue];
    address.longitude = [[locationArr lastObject] doubleValue];
    return address;
}

//orderType 1套餐，2酒吧位置价格  3包厢类型的价格 ,4暖场人，5 单点商品的价格如果是单点商品，会出现数量为2的情况），6普通邀约人（这个单价为0）7 团购  8 活动
+ (NSString *)orderDescriptionType:(NSInteger)type {
    switch (type) {
        case 1:
        {
            return @"套餐";
        }
            break;
        case 2:
        {
            return @"酒吧";
        }
            break;
        case 3:
        {
            return @"包厢";
        }
            break;
        case 4:
        {
            return @"暖场人";
        }
            break;
        case 5:
        {
            return @"单点商品";
        }
            break;
        case 6:
        {
            return @"普通邀约人";
        }
            break;
        case 7:
        {
            return @"团购";
        }
            break;
        case 8:
        {
            return @"活动";
        }
            break;
            
        default:
        {
            return @"";
        }
            break;
    }
}

// orderStatus 99:全部 -1:未支付，0,已支付, 1未响应，2未使用，3被商家忽略，4已响应，5待评论，，6已取消，7已结束
+ (NSString *)orderStatusDescriptin:(NSInteger)orderStatus {
    switch (orderStatus) {
        case -1:
        {
            return @"未支付";
        }
            break;
        case 0:
        {
            return @"已支付";
        }
            break;
        case 1:
        {
            return @"未响应";
        }
            break;
        case 2:
        {
            return @"未使用";
        }
            break;
        case 3:
        {
            return @"被商家忽略";
        }
            break;
        case 4:
        {
            return @"已响应";
        }
            break;
        case 5:
        {
            return @"待评论";
        }
            break;
        case 6:
        {
            return @"已取消";
        }
            break;
        case 7:
        {
            return @"已结束";
        }
            break;
        default:
        {
            return @"";
        }
            break;
    }
}

@end
