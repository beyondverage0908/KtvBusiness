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

@end
