//
//  KTVAddress.h
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/9.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTVAddress : NSObject

@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString * addressName;
@property (nonatomic, strong) NSString * cityCode;
@property (nonatomic, strong) NSString * cityName;

@end
