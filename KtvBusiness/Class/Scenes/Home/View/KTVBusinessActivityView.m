//
//  KTVBusinessActivityView.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/12.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVBusinessActivityView.h"

@interface KTVBusinessActivityView()

@property (weak, nonatomic) IBOutlet UITextField *activityNameTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *unitTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *activityTimeTF;
@property (weak, nonatomic) IBOutlet UITextView *activityDesctiptionTV;

@property (nonatomic, strong)NSMutableDictionary *params;

@end

@implementation KTVBusinessActivityView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    safetyDictionary(self.params);
}

- (IBAction)selectPosterAction:(UIButton *)sender {
    CLog(@"--->> 获取海报");
    NSString *activityName = safetyString(self.activityNameTF.text);
    NSString *money = safetyString(self.moneyTF.text);
    NSString *unit = safetyString(self.unitTF.text);
    NSString *address = safetyString(self.addressTF.text);
    NSString *activityTime = safetyString(self.activityTimeTF.text);
    NSString *activityDesctiption = safetyString(self.activityDesctiptionTV.text);
    
    if (activityName) {
        [self.params setObject:activityName forKey:@"activityName"];
    }
    if (money) {
        [self.params setObject:money forKey:@"money"];
    }
    if (unit) {
        [self.params setObject:unit forKey:@"unit"];
    }
    if (address) {
        [self.params setObject:address forKey:@"address"];
    }
    if (activityTime) {
        [self.params setObject:activityTime forKey:@"activityTime"];
    }
    if (activityDesctiption) {
        [self.params setObject:activityDesctiption forKey:@"activityDesctiption"];
    }
    
    if (self.params.allKeys.count < 6) {
        [KTVToast toast:@"信息补全才能发布"];
        return;
    }
    
    if (self.activityCB) {
        self.activityCB(self.params);
    }
}
@end
