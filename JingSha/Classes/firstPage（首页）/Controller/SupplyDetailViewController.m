//
//  SupplyDetailViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/15.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SupplyDetailViewController.h"
#import "CompanyMessageViewController.h"
#import "LeaveMessageTableViewController.h"
#import "ConnectViewController.h"
#import <MZFormSheetController.h>
#import "RecommendDetailViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface SupplyDetailViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
@property (nonatomic, strong)UIWebView * webView;
@property (nonatomic, copy)NSString *urlString;

@property (nonatomic, copy)NSString * titleString;
@property (nonatomic, copy)NSString * contentString;
@property (nonatomic, copy)NSString * url;

@property (nonatomic, strong)NJKWebViewProgress * progressProxy;
@property (nonatomic, strong)NJKWebViewProgressView * webViewProgress;

@end

@implementation SupplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供应详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configerSubViews];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webViewProgress removeFromSuperview];
}
- (void)configerSubViews{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - 45)];
//    _webView.delegate = self;
    
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.sendUrlStr]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 1,
                                 navBounds.size.width,
                                 1);
    _webViewProgress = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgress setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgress];

    
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeight - 45, kUIScreenWidth, 1)];
    lineView.backgroundColor = RGBColor(104,140,179);
    [self.view addSubview:lineView];

    
    for (int i = 0; i < 2; i++) {
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(kUIScreenWidth/2 * i, kUIScreenHeight - 44, kUIScreenWidth/2, 44);
        [but addTarget:self action:@selector(bottomButClicked:) forControlEvents:UIControlEventTouchUpInside];
        but.tag = 1000 + i;
        [self.view addSubview:but];
        if (i == 0) {
            [but setTitle:@"我要留言" forState:UIControlStateNormal];
            but.backgroundColor = RGBColor(30, 78, 145);
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [but setTitle:@"联系洽谈" forState:UIControlStateNormal];
            but.backgroundColor = RGBColor(247, 247, 247);
            [but setTitleColor:RGBColor(150, 150, 150) forState:UIControlStateNormal];
        }
    }
}
- (void)bottomButClicked:(UIButton *)sender{
    if (sender.tag == 1000) {
        //我要留言
        if (self.FromMe) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能给自己留言" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        LeaveMessageTableViewController * leaveMsgVC = [[LeaveMessageTableViewController alloc] init];
        leaveMsgVC.chanpinID = self.chanpinId;
        [self.navigationController pushViewController:leaveMsgVC animated:YES];
    }else{
        //联系洽谈
        ConnectViewController * connectVC = [[ConnectViewController alloc] init];
        connectVC.chanpinId = self.chanpinId;//这个必须写到生成fromSheet之前，不然没效果
        MZFormSheetController * fromSheet = [[MZFormSheetController alloc] initWithViewController:connectVC];
        fromSheet.shouldCenterVertically = YES;
        fromSheet.cornerRadius =0;
        fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 80, 170);
        [fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        }];  
    }
}
/**
 *  监听webView的按键
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.urlString = request.URL.absoluteString;
    MyLog(@"urlString %@", _urlString);
    if ([_urlString rangeOfString:@"fenxiang"].location != NSNotFound) {
        MyLog(@"分享");
        [self sharePro:self.urlString];
        return NO;
    }
    if ([_urlString rangeOfString:@"gongying"].location != NSNotFound) {
        [self allSupply];
        return NO;
    }
    if ([_urlString rangeOfString:@"ziliao"].location != NSNotFound) {
        [self checkZiliao];
        return NO;
    }
    if ([_urlString rangeOfString:@"zang"].location != NSNotFound) {
        [self collect];
        return NO;
    }
    return YES;
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [MBProgressHUD showMessage:@"正在加载..."];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    //    [SVProgressHUD dismiss];
//    [MBProgressHUD hideHUD];
//}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.webViewProgress setProgress:progress animated:NO];
    if (progress == 1) {
        [_webViewProgress removeFromSuperview];
    }
}
/**
 *  全部供应
 */
- (void)allSupply{
    NSArray * ary = [_urlString componentsSeparatedByString:@"/"];
    NSString *  str = [ary lastObject];
    
    RecommendDetailViewController * recommendVC = [[RecommendDetailViewController alloc] init];
    recommendVC.qiyeId = str;
    [self.navigationController pushViewController:recommendVC animated:YES];
}

/**
 *  查看资料
 */
- (void)checkZiliao{
    NSArray * ary = [self.urlString componentsSeparatedByString:@"/"];
    CompanyMessageViewController * companyVC = [[CompanyMessageViewController alloc] init];
    companyVC.proid = [ary lastObject];
    [self.navigationController pushViewController:companyVC animated:YES];
}

/**
 *  收藏
 */
- (void)collect{
    NSString * netPath = @"userinfo/shoucan_add";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.chanpinId forKey:@"proid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        [self.webView reload];//刷新H5页面。改变收藏、已收藏
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"收藏失败"];
    }];
}

/**
 *  分享
 */
- (void)sharePro:(NSString *)string{
    NSArray * ary = [string componentsSeparatedByString:@"/"];
    NSString *  str = [ary lastObject];
    NSString * netPath = @"userinfo/my_pro_info";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:str forKey:@"userid"];
    [allParams setObject:self.chanpinId forKey:@"proid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"%@", responseObj);
        [self getShareData:responseObj];
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)showAlertViewWithTitle:(NSString *)title
                         error:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}
- (void)getShareData:(id)response{
    self.titleString = response[@"data"][@"title"];
    self.contentString = response[@"data"][@"intro"];
    if ([self.titleString isKindOfClass:[NSNull class]]) {
        self.titleString = @"中国纱线网";
    }
    if ([self.contentString isKindOfClass:[NSNull class]]) {
        self.contentString = nil;
    }
    
    NSArray *imageArrar = @[[UIImage imageNamed:@"icon@2x"]];
    //参数
    self.url = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply_share/%@", self.chanpinId];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.contentString images:imageArrar url:[NSURL URLWithString:self.url] title:self.titleString type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           [self showAlertViewWithTitle:@"分享成功" error:nil];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           [self showAlertViewWithTitle:@"分享失败" error:[NSString stringWithFormat:@"%@", error]];
                           break;
                       }
                       default:
                           break;
                   }
                   
               }];

}
@end
