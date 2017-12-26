//
//  KTVInfoController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/9.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVInfoController.h"
#import "KTVStore.h"

@interface KTVInfoController ()

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *tellPhoneLabel;

@end

@implementation KTVInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家信息";
    
    [self loadStoreInfo];
}

#pragma mark - 网络

- (void)loadStoreInfo {
    NSString *storeId = @"4";
    weakify(self);
    [KTVMainSvc getStore:storeId result:^(NSDictionary *result) {
        if ([result[@"code"] isEqualToString:ktvCodeSuccess]) {
            KTVStore *store = [KTVStore yy_modelWithDictionary:result[@"data"]];
            [weakself renderUI:store];
        }
    }];
}

#pragma mark - Render UI

- (void)renderUI:(KTVStore *)store {
    self.companyNameLabel.text = store.storeName;
    self.addressLabel.text = store.address.addressName;
    self.businessHourLabel.text = [NSString stringWithFormat:@"%@-%@", store.fromTime, store.toTime];
    self.tellPhoneLabel.text = store.phone;
}

@end
