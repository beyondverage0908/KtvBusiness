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

@end

@implementation KTVBusinessActivityView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)selectPosterAction:(UIButton *)sender {
    CLog(@"--->> 获取海报");
}
@end
