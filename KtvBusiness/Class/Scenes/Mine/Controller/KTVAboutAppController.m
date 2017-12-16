//
//  KTVAboutAppController.m
//  KtvBusiness
//
//  Created by pingjun lin on 2017/12/16.
//  Copyright © 2017年 ktv. All rights reserved.
//

#import "KTVAboutAppController.h"

@interface KTVAboutAppController ()

@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

@end

@implementation KTVAboutAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appVersionLabel.text = [KTVUtil appVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
