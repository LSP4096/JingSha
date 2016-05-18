//
//  AgreeProtocolViewController.m
//  JingSha
//
//  Created by BOC on 15/11/6.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "AgreeProtocolViewController.h"
#import "MZFormSheetController.h"
@interface AgreeProtocolViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation AgreeProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self configureWebView];
}
- (void)configureWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth , kUIScreenHeight - kNavigationBarHeight*2 )];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.showsVerticalScrollIndicator = YES;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://121.41.128.239:8096/jxw/index.php/xieyi"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showMessage:@"正在加载..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [SVProgressHUD dismiss];
    [MBProgressHUD hideHUD];
    
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
