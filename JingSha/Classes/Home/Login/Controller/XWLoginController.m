//
//  XWLoginController.m
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "XWLoginController.h"
#import "IQKeyboardManager.h"
#import "RegisterViewController.h"
#import "MainNavigationController.h"
#import "SingleTon.h"
#import "NSString+Hash.h"
#import "ForgetPWViewController.h"
#import "SSKeychain.h"
#import "RootViewController.h"

#import "HttpClient+Authentication.h"
#import "HttpClient+WXLogin.h"
#import "WXApi.h"

@interface XWLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *pssWordTF;
@property (weak, nonatomic) IBOutlet UIButton *WXBtn;

@end

@implementation XWLoginController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginBtn];

//    [KeyboardToolBar registerKeyboardToolBar:_userAccountTF];
//    [KeyboardToolBar registerKeyboardToolBar:_pssWordTF];
    
//    [self.WXBtn setCornerBackgroundColor:[UIColor whiteColor] withRadius:_WXBtn.frame.size.height / 2 forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLogin:) name:@"WXLoginSuccess" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXLoginSuccess" object:nil];
}

- (void)setupLoginBtn {
    NSUserDefaults *defals = [NSUserDefaults standardUserDefaults];
    self.userAccountTF.text = [defals objectForKey:KKeyWithUserTel];
    MyLog(@"%@",[defals objectForKey:KKeyWithUserTel]);
    [defals synchronize];
    
    //取出密码
    NSString *securety = [SSKeychain passwordForService:kServiceName account:kLoginStateKey];
    self.pssWordTF.text = securety;
    MyLog(@"%@",securety);
    
      [self.userAccountTF addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    CGFloat loginBtnH = self.loginBtn.frame.size.height;
    self.loginBtn.layer.cornerRadius = loginBtnH/2;
    
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)textChangeAction:(UITextField *)tf {
    if (tf.text.length == 11) {
        [tf resignFirstResponder];
    }
}

/**返回按钮事件*/
- (IBAction)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark Animations
- (void)shakeButton
{
        CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        keyFrame.values = @[@(self.loginBtn.layer.position.x - 10), @(self.loginBtn.layer.position.x),@(self.loginBtn.layer.position.x + 10), @(self.loginBtn.layer.position.x)];
        keyFrame.repeatCount = 5;
        keyFrame.duration = 0.1;
        [self.loginBtn.layer addAnimation:keyFrame forKey:nil];
}

#pragma mark - 登录
- (IBAction)handleLogin:(UIButton *)sender {
    if (![self checkOut]) {
        [self shakeButton];
        MyLog(@"登录被返回");
        return;
    }
    [MBProgressHUD showMessage:@"登录中..." toView:self.view];
    
    @WeakObj(self);
    [[HttpClient sharedClient] LoginWithAccount:self.userAccountTF.text Password:self.pssWordTF.text.md5String Complection:^(id resoutObj, NSError *error) {
        @StrongObj(self)
        if (error) {
            MyLog(@"=======登录请求错误======\n\n%@",error);
            [MBProgressHUD hideHUDForView:self.view];
        }else {
            if (![resoutObj[@"return_code"] integerValue]) {
                [SingleTon shareSingleTon].userInformation = resoutObj[@"data"];
                [SingleTon shareSingleTon].userPassWoed = Strongself.pssWordTF.text.md5String;
                NSUserDefaults *defals = [NSUserDefaults standardUserDefaults];
                [defals setObject:Strongself.userAccountTF.text forKey:KKeyWithUserTel];
                [defals synchronize];
                // 保存密码
                [SSKeychain setPassword:Strongself.pssWordTF.text forService:kServiceName account:kLoginStateKey];
                MyLog(@"登录成功， %@, %@", [SingleTon shareSingleTon].userInformation, resoutObj[@"msg"]);
                
                RootViewController *root = [[RootViewController alloc] init];
                root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [Strongself presentViewController:root animated:YES completion:^{
                }];
                
                Strongself.navigationController.navigationBarHidden = NO;
            }else {
                [Strongself shakeButton];
                [MBProgressHUD hideHUDForView:self.view];
                //请求错误信息（后台设置：手机不存在／手机或密码错误）
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", resoutObj[@"msg"]]];
            }
        }
    }];
}

#pragma mark - 注册
- (IBAction)handleRegister:(UIButton *)sender {
    RegisterViewController *registVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
//    [self.navigationController pushViewController:registVC animated:YES];
    [self presentViewController:registVC animated:YES completion:nil];
}
#pragma mark - 忘记密码
- (IBAction)handleForgetPW:(UIButton *)sender {
    ForgetPWViewController *forgetVC = [[ForgetPWViewController alloc] initWithNibName:@"ForgetPWViewController" bundle:nil];
//    [self.navigationController pushViewController:forgetVC animated:YES];
    [self presentViewController:forgetVC animated:YES completion:nil];
}
#pragma mark - 检测用户输入的结果
- (NSInteger)checkOut {
    NSArray *array = @[self.userAccountTF, self.pssWordTF];
    for (int i = 0; i < array.count; i++) {
        if (![self checkUserInputWithTF:array[i]]) {
            return 0;
        }
    }
    return 1;
}
- (NSInteger)checkUserInputWithTF:(UITextField *)tf {
    NSInteger ident = 1;
    if (!tf.text.length) {
        [self shakeButton];
        [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
        ident = 0;
    }
    return ident;
}

#pragma mark - 微信登录
- (IBAction)weiXinLogin:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        
        static NSString *kAuthScope = @"snsapi_userinfo";
        static NSString *kAuthOpenID = @"cc188b3c1dc39115f983a0ef272e66c8";
        static NSString *kAuthState = @"123";
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = kAuthScope;
        req.state = kAuthState;
        req.openID = kAuthOpenID;

        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

//登陆成功之后获取token
- (void)WXLogin:(NSNotification *)notifi
{
    @WeakObj(self);
    [[HttpClient sharedClient] getAccessTokenWithCode:notifi.object[@"code"] Complection:^(id resoutObj, NSError *error) {
        @StrongObj(self);
        if (error) {
            MyLog(@"获取微信token失败%@",error.localizedDescription);
        }else {
            MyLog(@"--微信token--%@",resoutObj);
            [[NSUserDefaults standardUserDefaults] setObject:resoutObj forKey:@"WXSaveToken"];
            [Strongself saveTokenAndRequireWXInfo];
        }
    }];
}

//"access_token" = "DQjoGpeU7fmnGMTklSkhGl7N6AYNMptxgoNuuglBOXWTyKmru-XwvjjBWKwjcgJpZFgNtSm4llkVIwPnxn6-_yGJH7IWaQQrAXEcuCVPIsc";
//"expires_in" = 7200;
//openid = oN1wct79pSXFjCJGzhQMnw3uZFak;
//"refresh_token" = "62HJIekJCJLlTFLusQiZYvcSowEnq1XuYvpjhXRC46a6Jmz-SXDKdvSPkPjftJmZISYiZ1AkFMiBzyx0LY3ssAm8LInhU54N59vBwFKtgeM";
//scope = "snsapi_userinfo";
//unionid = "oia_PvtPxwJBMXyi1umBBZaoLxv8";

- (void)saveTokenAndRequireWXInfo
{
    [NSThread sleepForTimeInterval:0.5];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXSaveToken"];
    [[HttpClient sharedClient] getWeChatUserInfoWithOpenId:dict[@"openid"] AccessToken:dict[@"access_token"] Complection:^(id resoutObj, NSError *error) {
        if (error) {
            MyLog(@"获取微信用户信息失败 %@",error.localizedDescription);
        }else {
//            1.首先获取到微信的openID，然后通过openID去后台数据库查询该微信的openID有没有绑定好的手机号.
//            2.如果没有绑定,首相第一步就是将微信用户的头像、昵称等等基本信息添加到数据库；然后通过手机获取验证码;最后绑定手机号。然后就登录App.
//            3.如果有，那么后台就返回一个手机号，然后通过手机登录App.
            
            MyLog(@"--微信用户信息--%@",resoutObj);
            [SingleTon shareSingleTon].userInformation = resoutObj;
            
            if ((1)) {
                NSUserDefaults *defals = [NSUserDefaults standardUserDefaults];
                self.userAccountTF.text = [defals objectForKey:KKeyWithUserTel];
                MyLog(@"%@",[defals objectForKey:KKeyWithUserTel]);
                [defals synchronize];
                //取出密码
                NSString *securety = [defals objectForKey:kLoginStateKey];
                self.pssWordTF.text = securety;
                MyLog(@"%@",securety);
                
//                [self loginWithUsercount:self.userAccountTF.text Password:self.pssWordTF.text.md5String];
            
            }else {
                RegisterViewController *registerVC = [RegisterViewController new];
                [self presentViewController:registerVC animated:YES completion:nil];
            }
        }
    }];
}

/*
 city = Hangzhou;
 country = CN;
 headimgurl = "http://wx.qlogo.cn/mmopen/thfLhcllFYoPEFlLSDoZrpfBicPIgjKIjCZeATicXX5q6pPicVUK3SXGeCZ0fS80BVGIiccCm7T3fgO0K8VDYweZfg/0";
 language = en;
 nickname = "丷戈";
 openid = oN1wct79pSXFjCJGzhQMnw3uZFak;
 privilege =     (
 );
 province = Zhejiang;
 sex = 1;
 unionid = "oia_PvtPxwJBMXyi1umBBZaoLxv8";
 */

@end
