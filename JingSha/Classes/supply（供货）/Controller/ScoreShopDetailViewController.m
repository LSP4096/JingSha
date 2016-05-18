//
//  ScoreShopDetailViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ScoreShopDetailViewController.h"
#import "PersonMessageViewController.h"
@interface ScoreShopDetailViewController ()<UIWebViewDelegate>

@end

@implementation ScoreShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"积分商城";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [self duiHuan];
    //H5界面
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://202.91.244.52/index.php/shopinfo/%@", self.sid]]];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:@"dui"].location != NSNotFound) {
        [self duiHuan];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showMessage:@"正在加载..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUD];
}
/**
 *  兑换详细
 */
- (void)duiHuan{
    PersonMessageViewController * personVC = [[PersonMessageViewController alloc] init];
    personVC.sid = self.sid;
    [self.navigationController pushViewController:personVC animated:YES];
}

@end
