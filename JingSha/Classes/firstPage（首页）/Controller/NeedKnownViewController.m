//
//  NeedKnownViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/14.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "NeedKnownViewController.h"
#import <MZFormSheetController.h>
@interface NeedKnownViewController ()<UIWebViewDelegate>

@end

@implementation NeedKnownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(-5, 0, self.view.width - 20, self.view.height - 450)];
    NSURL * url = [NSURL URLWithString:@"http://202.91.244.52/index.php/offer_notice"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}
- (IBAction)cancleButton:(UIButton *)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    MyLog(@"urlString %@", urlString);
//    if ([urlString containsString:@"/jxw/index.php/baojia//www.baidu.com"]) {
     if ([urlString rangeOfString:@"baojia"].location != NSNotFound) {
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        return NO;
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
