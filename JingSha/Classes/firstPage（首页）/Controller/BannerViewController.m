//
//  BannerViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/7.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "BannerViewController.h"
#import "NeedKnowViewController.h"
@interface BannerViewController ()

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会议";
    [self setUpWebView];
    
    [self configerBottomBut];
}
- (void)setUpWebView{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.HTMLUrl]];
    webView.scrollView.bounces = NO;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


- (void)configerBottomBut{
    for (int i = 0; i < 2; i++) {
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(kUIScreenWidth/2 * i, kUIScreenHeight - 45, kUIScreenWidth/2, 45);
        [but addTarget:self action:@selector(bottomButClicked:) forControlEvents:UIControlEventTouchUpInside];
        but.tag = 1000 + i;
        [self.view addSubview:but];
        if (i == 0) {
            [but setTitle:@"参展报名" forState:UIControlStateNormal];
            but.backgroundColor = RGBColor(30, 78, 145);
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [but setTitle:@"参观报名" forState:UIControlStateNormal];
            but.backgroundColor = RGBColor(247, 247, 247);
            [but setTitleColor:RGBColor(150, 150, 150) forState:UIControlStateNormal];
        }
    }
}
- (void)bottomButClicked:(UIButton *)sender{
    
    if ([self.HTMLUrl rangeOfString:@"meeting"].location != NSNotFound) {
        NeedKnowViewController * needVC = [[NeedKnowViewController alloc] init];
        if (sender.tag == 1000) {
            needVC.isSale = YES;
        }else{
            needVC.isSale = NO;
        }
        needVC.hid = @"1";
        [self.navigationController pushViewController:needVC animated:YES];
    }else{
        UIAlertView * alertView= [[UIAlertView alloc] initWithTitle:@"提示" message:@"不是会议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
@end
