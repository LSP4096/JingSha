//
//  RequestDetailViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RequestDetailViewController.h"
#import "JHTickerView.h"
#import "UIBarButtonItem+CH.h"
//#import "RequestGeneralTableViewCell.h"
#import "RefreshRequestViewController.h"
#import <MZFormSheetController.h>
#import "BottomTableViewMyCell.h"
#import "IssueRequestViewController.h"
#import "SingUpViewController.h"
#import "CheckConnectStyleViewController.h"
#import "ConnectDetailViewController.h"
#import "RequestMessageViewController.h"
#import "GongHuoTableViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface RequestDetailViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
@property (nonatomic, strong)UIButton * rightTopButton;
@property (nonatomic, strong)UIView * backView;
@property (nonatomic, assign)BOOL isHidden;
@property (nonatomic, strong)MZFormSheetController * fromSheet;
@property (nonatomic, strong)UIWebView * webView;
@property (nonatomic, strong)NSDictionary * connectDict;

@property (nonatomic, copy)NSString * url;

@property (nonatomic, strong)NJKWebViewProgress * progressProxy;
@property (nonatomic, strong)NJKWebViewProgressView * webViewProgress;
@end

@implementation RequestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"求购详细";
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 1,
                                 navBounds.size.width,
                                 1);
    _webViewProgress = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgress setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgress];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.HTMLUrlStr]];
    [_webView loadRequest:request];
    [self setUpSunviews];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webViewProgress removeFromSuperview];
}

- (void)setUpSunviews{
    self.rightTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightTopButton.frame = CGRectMake(0, 0, 30, 30);
    if (self.isCanAlter) {
        [_rightTopButton setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
        [_rightTopButton addTarget:self action:@selector(MenuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_rightTopButton setImage:[UIImage imageNamed:@"Request_share"] forState:UIControlStateNormal];
        [_rightTopButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightTopButton];
    
    [self configerRightMenu];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    MyLog(@"urlString %@", urlString);
    if ([urlString rangeOfString:@"offer_notice"].location != NSNotFound) {
        self.title = @"报名须知";
        return YES;
    }
    if (([urlString rangeOfString:@"baojia"].location != NSNotFound) && ([urlString rangeOfString:@"y"].location == NSNotFound)) {
        [self showWriteSingUpMsgVC];
        return NO;
    }
    if ([urlString rangeOfString:@"chakan"].location != NSNotFound) {
        [self confirmCheckClicked];
        return NO;
    }
    if ([urlString rangeOfString:@"gonghuo"].location != NSNotFound) {
        NSArray * ary = [urlString componentsSeparatedByString:@"/"];
        MyLog(@"%@", ary);
        [self toGonghuoVC:[ary lastObject]];
        return NO;
    }
    if ([urlString rangeOfString:@"ybaojia"].location != NSNotFound) {
        [self toybaojiaVC];
        return NO;
    }
    return YES;
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.webViewProgress setProgress:progress animated:NO];
    if (progress == 1) {
        [_webViewProgress removeFromSuperview];
    }
}


- (void)toGonghuoVC:(NSString *)str{
    GongHuoTableViewController * gonghuoVC = [[GongHuoTableViewController alloc] init];
    
    gonghuoVC.keyWord = str;
    [self.navigationController pushViewController:gonghuoVC animated:YES];
    
    [_rightTopButton setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    self.backView.hidden = YES;
    self.isHidden = !self.isHidden;
}
- (void)toybaojiaVC{
    RequestMessageViewController * requestVC = [[RequestMessageViewController alloc] init];
    [self.navigationController pushViewController:requestVC animated:YES];
    
    [_rightTopButton setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    self.backView.hidden = YES;
    self.isHidden = !self.isHidden;
}

/**
 *  填写报名表
 */
- (void)showWriteSingUpMsgVC{
    SingUpViewController * singUpVC = [[SingUpViewController alloc] init];
    singUpVC.Id = self.Id;
    [self.navigationController pushViewController:singUpVC animated:YES];
}
/**
 *  查看联系方式
 */
- (void)checkConnectStyle{
    CheckConnectStyleViewController * checkVC = [[CheckConnectStyleViewController alloc] init];
    self.fromSheet = [[MZFormSheetController alloc] initWithViewController:checkVC];
    [checkVC.confirmCheckConnectStyle addTarget:self action:@selector(confirmCheckClicked) forControlEvents:UIControlEventTouchUpInside];//注意必须生成弹窗之后再添加事件，不然没效果
    [checkVC.cancleCheckConnectStyle addTarget:self action:@selector(cancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _fromSheet.shouldCenterVertically = YES;
    _fromSheet.cornerRadius =0;
    _fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    _fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 80, 130);
    [_fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}
/**
 *  确认查看联系方式
 */
- (void)confirmCheckClicked{
    NSString * netPath = @"pro/buy_info";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.Id forKey:@"bid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"%@", responseObj);
        self.connectDict = responseObj[@"data"];
        [self showDetailConnectStyleVC];
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  显示联系方式
 */
- (void)showDetailConnectStyleVC{
    ConnectDetailViewController * connectVC = [[ConnectDetailViewController alloc] init];
    MZFormSheetController *fromSheetVC = [[MZFormSheetController alloc] initWithViewController:connectVC];
    connectVC.dict = self.connectDict;
    [connectVC.playTelButton addTarget:self action:@selector(playTelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];//注意必须生成弹窗之后再添加事件，不然没效果
    fromSheetVC.shouldCenterVertically = YES;
    fromSheetVC.cornerRadius =0;
    fromSheetVC.transitionStyle = MZFormSheetTransitionStyleBounce;
    fromSheetVC.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 80, 230);
    [fromSheetVC presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}
/**
 *  拨打电话
 */
- (void)playTelButtonClicked:(UIButton *)sender{
    MyLog(@"%@", self.connectDict[@"tel"]);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.connectDict[@"tel"]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
/**
 *  如果是分享
 */
- (void)shareButtonClicked{
    if ([self.shareTitle isKindOfClass:[NSNull class]]) {
        self.shareTitle = @"中国纱线网";
    }
    if ([self.shareContent isKindOfClass:[NSNull class]]) {
        self.shareContent = nil;
    }
    NSArray *imageArrar = @[[UIImage imageNamed:@"icon@2x"]];
    //参数
    self.url = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo_share/%@", self.Id];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.shareContent images:imageArrar url:[NSURL URLWithString:self.url] title:self.shareTitle type:SSDKContentTypeAuto];
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
- (void)showAlertViewWithTitle:(NSString *)title
                         error:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}
/**
 *  如果是菜单按钮
 */
- (void)MenuButtonClicked{
    if (self.isHidden) {
        self.backView.hidden = YES;
        [_rightTopButton setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    }else{
        self.backView.hidden = NO;
        [_rightTopButton setImage:[UIImage imageNamed:@"Request_open"] forState:UIControlStateNormal];
    }
    self.isHidden = !self.isHidden;
}
/**
 *  配置右上角弹出的菜单
 */
- (void)configerRightMenu{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth - 100, 64, 100, 120)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.webView addSubview:_backView];
    NSArray * titleAry = @[@"修改求购",@"求购刷新",@"删除求购"];
    for (int i = 0; i < 3; i++) {
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 40 * i, 100, 40);
        but.backgroundColor = [UIColor whiteColor];
        but.tag = 1000 + i;
        but.layer.borderColor = RGBColor(223, 223, 224).CGColor;
        but.layer.borderWidth = .5;
        [but setTitle:titleAry[i] forState:UIControlStateNormal];
        [but setTitleColor:RGBColor(120, 120, 120) forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        [but addTarget:self action:@selector(rightMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:but];
    }
    self.backView.hidden = YES;
}
- (void)rightMenuClicked:(UIButton *)sender{
    if (sender.tag == 1000){//修改求购
        IssueRequestViewController * issueRequestVC = [[IssueRequestViewController alloc] init];
        issueRequestVC.isAlter = YES;
        issueRequestVC.bid = self.Id;
        [self.navigationController pushViewController:issueRequestVC animated:YES];
        [self configerMenuOpenOrClose];
    }else{//刷新求购
        RefreshRequestViewController * refreshVC = [[RefreshRequestViewController alloc] init];
        self.fromSheet = [[MZFormSheetController alloc] initWithViewController:refreshVC];
        [refreshVC.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];//注意必须生成弹窗之后再添加事件，不然没效果
        [refreshVC.cancleButton addTarget:self action:@selector(cancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (sender.tag == 1001) {
            refreshVC.contentLable.text = @"刷新后将重新发布求购是否刷新";
            refreshVC.confirmButton.tag = 1001;
        }else{
            refreshVC.contentLable.text = @"您所选的求购是否要删除";
        }
        _fromSheet.shouldCenterVertically = YES;
        _fromSheet.cornerRadius =0;
        _fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        _fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 80, 130);
        [_fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        }];
    }
}
- (void)confirmButtonClicked:(UIButton *)sender{
    [self cancleButtonClicked:nil];
    if (sender.tag == 1001) {
        [self configerMenuOpenOrClose];
        //外加求购刷新的代码
        MyLog(@"add");
        NSString * netPath = @"pro/buy_shuaxin";
        NSMutableDictionary * allParmas = [NSMutableDictionary dictionary];
        [allParmas setObject:KUserImfor[@"userid"] forKey:@"userid"];
        [allParmas setObject:self.Id forKey:@"bid"];
        [HttpTool getWithPath:netPath params:allParmas success:^(id responseObj) {
//            MyLog(@"%@", responseObj);
            [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
        } failure:^(NSError *error) {
            MyLog(@"**%@", error);
        }];
        
    }else{
        //外加删除求购代码
        NSString *netPath = @"pro/buy_del";
        NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
        [allParams setObject:self.Id forKey:@"bid"];
        [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
        
    }
}
- (void)cancleButtonClicked:(UIButton *)sender{
    [_fromSheet dismissAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}


#pragma mark --控制弹出菜单
/**
 * 调用方法，改变按钮图片状态，及菜单是否显示
 */
- (void)configerMenuOpenOrClose{
    self.isHidden = !self.isHidden;
    self.backView.hidden = YES;
    [_rightTopButton setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
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
