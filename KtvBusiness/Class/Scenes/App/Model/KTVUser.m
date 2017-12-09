//
//  KTVUser.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/9.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVUser.h"

@implementation KTVUser

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[@"sex"] integerValue] == 0) {
        _gender = @"女";
    }
    if ([dic[@"sex"] integerValue] == 1) {
        _gender = @"男";
    }
    
    return YES;
}

// 属性转换 - 服务端返回的属性和需要定义的属性不一致
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id",
             @"des" : @"description"};
}

// 容器类转换
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    // value should be Class or Class name.
//    return @{@"pictureList" : [KTVPicture class],
//             @"videoList" : [KTVVideo class]};
//}


@end
