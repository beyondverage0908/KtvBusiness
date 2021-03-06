//
//  KTVOrder.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/26.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVOrder.h"

@implementation KTVOrder

// 容器类转换
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    // value should be Class or Class name.
//    return @{@"activitorList" : [KTVUser class],
//             @"pictureList" : [KTVPicture class],
//             @"groupBuyList" : [KTVGroupbuy class],
//             @"packageList" : [KTVPackage class]};
//}


// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    return YES;
//}

// 属性转换 - 服务端返回的属性和需要定义的属性不一致
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderId" : @"id", @"des" : @"description"};
}

@end
