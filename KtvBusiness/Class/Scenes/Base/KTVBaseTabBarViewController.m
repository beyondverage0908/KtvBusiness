//
//  KTVBaseTabBarViewController.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/7/10.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVBaseTabBarViewController.h"
#import "KTVBaseNavigationViewController.h"

@interface KTVBaseTabBarViewController ()

@end

@implementation KTVBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllerWithStoryboard:@"Home"
                          storyboardIdentifier:@"KTVHomeController"
                               tabBarItemTitle:@"首页"
                                         image:@"app_mainpage_icon_unselect"
                                andSelectImage:@"app_mainpage_icon_select"];
    
    [self addChildViewControllerWithStoryboard:@"Hall"
                          storyboardIdentifier:@"KTVHallController"
                               tabBarItemTitle:@"接单大厅"
                                         image:@"app_nearby_icon_unselect"
                                andSelectImage:@"app_nearby_icon_select"];
    
    [self addChildViewControllerWithStoryboard:@"Info"
                          storyboardIdentifier:@"KTVInfoController"
                               tabBarItemTitle:@"信息管理"
                                         image:@"app_tab_yuepao_unselect"
                                andSelectImage:@"app_tab_yuepao_select"];
    
    [self addChildViewControllerWithStoryboard:@"Mine"
                          storyboardIdentifier:@"KTVMineController"
                               tabBarItemTitle:@"我的"
                                         image:@"app_tab_mine_unselect"
                                andSelectImage:@"app_tab_mine_select"];
    
    // remove transparent and set costomize color
    [self.tabBar setTranslucent:NO];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.barTintColor = [UIColor ktvBG];
}


/**
 *  为tabBar控制器添加子控制器
 *
 *  @param sb         控制器所在的故事板
 *  @param identifier 控制器在故事板的标识符
 *  @param title      tabBarItem上的标题
 *  @param imageName  tabBarItem上的默认图片
 *  @param selectName tabBarItem上的选中图片
 */

- (void)addChildViewControllerWithStoryboard:(NSString *)sb
                        storyboardIdentifier:(NSString *)identifier
                             tabBarItemTitle:(NSString *)title
                                       image:(NSString *)imageName
                              andSelectImage:(NSString *)selectName {
    
    UIViewController *targetvc = [UIViewController storyboardName:sb storyboardId:identifier];
    
    targetvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                        image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[[UIImage imageNamed:selectName]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //设置字体
    [targetvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor ktvGray]} forState:UIControlStateNormal];
    [targetvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor ktvRed]} forState:UIControlStateSelected];
    
    KTVBaseNavigationViewController *nav = [[KTVBaseNavigationViewController alloc] initWithRootViewController:targetvc];
    [self addChildViewController:nav];
    
}

@end
