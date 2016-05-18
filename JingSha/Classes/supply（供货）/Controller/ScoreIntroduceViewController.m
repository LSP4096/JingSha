//
//  ScoreIntroduceViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ScoreIntroduceViewController.h"

@interface ScoreIntroduceViewController ()<UIWebViewDelegate>

@end

@implementation ScoreIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分说明";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //H5界面
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://202.91.244.52/index.php/integral"]];
    [webView loadRequest:request];
    webView.delegate = self;
    [self.view addSubview:webView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"正在加载"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUD];
}


@end
