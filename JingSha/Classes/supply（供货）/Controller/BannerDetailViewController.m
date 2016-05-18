//
//  BannerDetailViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/2/14.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "BannerDetailViewController.h"

@interface BannerDetailViewController ()

@end

@implementation BannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"banner详细";
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.HTMLStr]];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.youku.com"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


@end
