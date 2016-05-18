//
//  ShangjiaViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/2/19.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "ShangjiaViewController.h"

@interface ShangjiaViewController ()

@end

@implementation ShangjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"推荐企业";
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSURL * url = [NSURL URLWithString:self.link];
    NSURLRequest * request  =[[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    webView.scrollView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
