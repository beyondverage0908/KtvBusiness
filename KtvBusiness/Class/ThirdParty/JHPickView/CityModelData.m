//
//  CityModelData.m
//  ProvinceAndCityAndTown
//
//  Created by Jivan on 16/12/27.
//  Copyright © 2016年 Jivan. All rights reserved.
//

#import "CityModelData.h"

@implementation CityModelData


+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"province" : [Province class]};
}

@end

@implementation Province

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"city" : [City class]};
}

@end

@implementation City

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"district" : [District class]};
}

@end


@implementation District

@end
