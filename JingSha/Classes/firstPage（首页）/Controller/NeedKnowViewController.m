//
//  NeedKnowViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/18.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "NeedKnowViewController.h"
#import "VisitSingUpViewController.h"
@interface NeedKnowViewController ()<UIWebViewDelegate>
@property (nonatomic, copy)NSString *urlString;
@end

@implementation NeedKnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"报名须知";
    [self setUpWebView];
}

- (void)setUpWebView{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://202.91.244.52/index.php/offer_noticeno"]];
    webView.scrollView.bounces = NO;
    [webView loadRequest:request];
    webView.delegate = self;
    [self.view addSubview:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.urlString = request.URL.absoluteString;
    MyLog(@"urlString %@", _urlString);
    if ([_urlString rangeOfString:@"baoming"].location != NSNotFound) {
        VisitSingUpViewController *visitVC =[[VisitSingUpViewController alloc] init];
        visitVC.sale = self.isSale;
        visitVC.hid = self.hid;
        [self.navigationController pushViewController:visitVC animated:YES];
        
        return NO;
    }
    return YES;
}



@end
