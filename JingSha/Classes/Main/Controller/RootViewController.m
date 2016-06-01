//
//  RootViewController.m
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "RootViewController.h"
//#import "XWHomeController.h" //资讯
#import "UIBarButtonItem+CH.h"
#import "FirstPageViewController.h"
//#import "SupplyViewController.h"
//#import "RequestViewController.h"
#import "MyRequestViewController.h"
#import "MainNavigationController.h"
#import "XWMemberCenterViewController.h"

//#import "SupportViewController.h"
#import "SupplyManageViewController.h"

@interface RootViewController ()
//当前显示的控制器
//@property (nonatomic, strong) MainNavigationController *showNavController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildControllers];
}

#pragma mark 添加子视图控制器
- (void)addChildControllers {
    //首页
    FirstPageViewController *shouyeVC = [[FirstPageViewController alloc] init];
    [self addChildVC:shouyeVC vcTitle:@"中国纱线网" tabBarItemTitle:@"首页" image:@"main" selectedImage:@"main-selected"];
    
    //资讯
//    XWHomeController *home = [[XWHomeController alloc] init];
//    [self addChildVC:home vcTitle:@"新闻" tabBarItemTitle:@"资讯" image:@"News" selectedImage:@"News-selected"];
    
    //求购
    MyRequestViewController *requestVC = [[MyRequestViewController alloc] init];
    [self addChildVC:requestVC vcTitle:@"我的求购" tabBarItemTitle:@"发布求购" image:@"MainRequest" selectedImage:@"MainRequest-selected"];
    
    //供应
    SupplyManageViewController *supportVC = [[SupplyManageViewController alloc] init];
    [self addChildVC:supportVC vcTitle:@"供应管理" tabBarItemTitle:@"发布供应" image:@"tab-request" selectedImage:@"tab-requestSelected"];
    
    //我的
    XWMemberCenterViewController * xwCenterVC = [[XWMemberCenterViewController alloc] init];
    [self addChildVC:xwCenterVC vcTitle:nil tabBarItemTitle:@"我的" image:@"tab-men" selectedImage:@"tab-men-selected"];
}
#pragma mark 添加子视图控制器详细方法
-(void)addChildVC:(UIViewController *)childVC
          vcTitle:(NSString *)vcTitle
  tabBarItemTitle:(NSString *)tabBarItemTitle
            image:(NSString *)image
    selectedImage:(NSString *)selectedImage {
    //title
    childVC.title = vcTitle;
    childVC.tabBarItem.title = tabBarItemTitle;
    //图片和选中图片
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置item底部的文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //颜色设置可根据美工切图实际情况RGB值来定
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    //设置item底部的文字大小
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = RGBColor(52, 125, 251);
  
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 添加导航控制器
    MainNavigationController *naVC = [[MainNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:naVC];
}


@end
