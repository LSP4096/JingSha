//
//  XWNewsDetailViewController.m
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "XWNewsDetailViewController.h"
#import "XWCommentViewController.h"
#import "SingleTon.h"
#import "UIBarButtonItem+CH.h"
#import "XWLoginController.h"
@interface XWNewsDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation XWNewsDetailViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightItem];
    [self setupWebView];
}
- (void)setupRightItem {
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithRightIcon:@"新闻详情-带图_03" highIcon:nil edgeInsets:UIEdgeInsetsMake(0, -10, 0, 0) target:self action:@selector(handlePushComment)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - 进入评论列表
- (void)handlePushComment {
    XWCommentViewController *commendVC = [[XWCommentViewController alloc] init];
    commendVC.newsid = [[self.sendUrlStr componentsSeparatedByString:@"/"] lastObject];
    commendVC.sendUrl = self.sendUrlStr;
    commendVC.newsInfoDic = self.newsInfoDic;
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (void)setupWebView {
    //判断有没有网络
    if([XWBaseMethod connectionInternet]==NO)  return;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight)];
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.sendUrlStr]];
    MyLog(@"aaaa%@", self.sendUrlStr);
    [_webView loadRequest:request];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"加载中"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    MyLog(@"urlString %@", urlString);
    if ([urlString rangeOfString:@"shoucan"].location != NSNotFound) {
        MyLog(@"收藏");
        [self handleCollection];
        return NO;
    }
    if ([urlString rangeOfString:@"weixin"].location != NSNotFound) {
        [self handleWeCat];
        return NO;
    }
    if ([urlString rangeOfString:@"pengyou"].location != NSNotFound) {
        MyLog(@"收藏");
        [self handleFriendCircle];
        return NO;
    }
    return YES;
}
///响应收藏事件
- (void)handleCollection {
    //  检测是否已经登录
    if ([self checkIsLogin] == NO) {
        return;
    }
    NSString *netPath = @"userinfo/shoucan_add";
    NSMutableDictionary *allParemeters = [NSMutableDictionary dictionary];
    [allParemeters setObject:[SingleTon shareSingleTon].userInformation[@"userid"] forKey:@"userid"];
    [allParemeters setObject:[[self.sendUrlStr componentsSeparatedByString:@"/"] lastObject] forKey:@"newsid"];
    [HttpTool postWithPath:netPath params:allParemeters success:^(id responseObj) {
        [SVProgressHUD showSuccessWithStatus:responseObj[@"msg"]];
    } failure:^(NSError *error) {
        
    }];
}
///响应微信分享
- (void)handleWeCat {
    MyLog(@"%@", self.newsInfoDic);
    NSArray *imageArrar = [NSArray new];
    if ([self.newsInfoDic[@"photo"] isKindOfClass:[NSArray class]] && ((NSArray *)self.newsInfoDic[@"photo"]).count) {
        MyLog(@"%@", self.newsInfoDic[@"photo"]);
        NSString *imageName = [NSString stringWithFormat:@"%@",((NSArray *)self.newsInfoDic[@"photo"]).firstObject];
        imageArrar = @[imageName];
    } else {
        imageArrar = @[[UIImage imageNamed:@"icon@2x"]];
    }
    //参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.newsInfoDic[@"content"] images:imageArrar url:[NSURL URLWithString:self.sendUrlStr] title:self.newsInfoDic[@"title"] type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
- (void)showAlertViewWithTitle:(NSString *)title
                         error:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}
///朋友圈
- (void)handleFriendCircle {
    NSArray *imageArrar = [NSArray new];
    if ([self.newsInfoDic[@"photo"] isKindOfClass:[NSArray class]] && ((NSArray *)self.newsInfoDic[@"photo"]).count) {
        MyLog(@"%@", self.newsInfoDic[@"photo"]);
        NSString *imageName = [NSString stringWithFormat:@"%@",((NSArray *)self.newsInfoDic[@"photo"]).firstObject];
        imageArrar = @[imageName];
    } else {
        imageArrar = @[[UIImage imageNamed:@"icon@2x"]];
    }
    //参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.newsInfoDic[@"content"] images:imageArrar url:[NSURL URLWithString:self.sendUrlStr] title:self.newsInfoDic[@"title"] type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
#pragma mark - 判断用户是否登录
- (BOOL)checkIsLogin {
    ///先判断用户当点是否登录
    if (KUserImfor != nil) {
        return YES;
    } else {
        [self showAlertView];
        return NO;
    }
}
- (void)showAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先登录" message:@"是否前往登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark -  AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
        loginVC.fd_prefersNavigationBarHidden = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

@end
