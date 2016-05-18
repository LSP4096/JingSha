//
//  MainNavigationController.m
//  Yoyou
//
//  Created by Remmo on 15/9/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (void)initialize
{
    [self setNavigationItemTheme];
    [self setNavigationBarTheme];
}

+ (void)setNavigationItemTheme
{
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = RGBColor(50, 50, 50);
    textAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
}

+ (void)setNavigationBarTheme
{
    // 取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
      [navBar setBarTintColor:RGBColor(27, 75, 146)];
    // 设置导航栏标题颜色
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = RGBColor(255, 255, 255);
    textAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [navBar setTitleTextAttributes:textAttributes];
    
    // 5.去除阴影
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttributes[NSShadowAttributeName] = shadow;
}

-(void)popself
{
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 0){
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tab-left"] style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
        backItem.tintColor = [UIColor whiteColor];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    self.interactivePopGestureRecognizer.delegate = (id)self;
    
    [super pushViewController:viewController animated:animated];
}

@end
