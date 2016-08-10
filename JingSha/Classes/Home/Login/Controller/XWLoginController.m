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
                MyLog(@"%@",resoutObj);
                
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

//data =     {
//    addr = "请编辑公司地址";
//    gongsi = "请编辑的公司名字";
//    photo = "http://202.91.244.52/upload/1776/14675974123048.jpg";
//    sex = 1;
//    tel = 13456893451;
//    userid = 1776;
//    username = "丷戈";
//};
//msg = OK;
//"return_code" = 0;

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
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"openid"]) {
//            [self getUserIdWith];
        }
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
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXSaveToken"];
    
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID   http://202.91.244.52/index.php/login/getweixin
    @WeakObj(self);
    [[HttpClient sharedClient] getWeChatUserInfoWithOpenId:dict[@"openid"] AccessToken:dict[@"access_token"] Complection:^(id resoutObj, NSError *error) {
        @StrongObj(self);
        if (error) {
            
            MyLog(@"获取微信用户信息失败 %@",error.localizedDescription);
        }else {
            
            [[NSUserDefaults standardUserDefaults] setObject:resoutObj[@"openid"] forKey:@"openid"];
            MyLog(@"登录成功， %@", resoutObj);
            NSDictionary *dic = resoutObj;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:dic[@"nickname"] forKey:@"username"];
            [dict setObject:dic[@"headimgurl"] forKey:@"photo"];
            [dict setObject:dic[@"sex"] forKey:@"sex"];
            
            MyLog(@"%@",dic[@"sex"]);
            
            [dict setObject:@"请编辑公司地址" forKey:@"addr"];
            [dict setObject:@"请编辑的公司名字" forKey:@"gongsi"];
            
            [SingleTon shareSingleTon].userInformation = dict;
            
//            []
            [Strongself getUserIdWithOpenid:resoutObj[@"openid"]];
        }
    }];
}
/*
 city = Hangzhou;language = en;country = CN; openid = oN1wct79pSXFjCJGzhQMnw3uZFak; province = Zhejiang; unionid = "oia_PvtPxwJBMXyi1umBBZaoLxv8";
 privilege =     (
 );
 headimgurl = "http://wx.qlogo.cn/mmopen/thfLhcllFYoPEFlLSDoZrpfBicPIgjKIjCZeATicXX5q6pPicVUK3SXGeCZ0fS80BVGIiccCm7T3fgO0K8VDYweZfg/0";
 nickname = "丷戈";
 sex = 1;

 
addr = "请编辑公司地址";gongsi = "请编辑的公司名字";
username = "丷戈";
photo = "http://202.91.244.52/upload/1776/14675974123048.jpg";
sex = 1;
tel = 13456893451;
userid = 1776;
 */

//后台传过来userId tel
- (void)getUserIdWithOpenid:(NSString *)openid {
    
    MyLog(@"%@",openid);
    
    @WeakObj(self);
    [[HttpClient sharedClient] getUserIdWithOpenId:openid Complection:^(id resoutObj, NSError *error) {
        @StrongObj(self);
        if (error) {
            
            MyLog(@"获取用户ID失败 %@",error.localizedDescription);
        }else {
            
            NSDictionary *dic = resoutObj[@"data"];
            MyLog(@"获取用户ID， %@", dic);
            
            if ([resoutObj[@"return_code"] isEqual:@(1)]) { //已经注册过的

                [[SingleTon shareSingleTon].userInformation setValue:dic[@"id"] forKey:@"userid"];
                [[SingleTon shareSingleTon].userInformation setValue:dic[@"tel"] forKey:@"tel"];
            
                RootViewController *root = [[RootViewController alloc] init];
                root.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [Strongself presentViewController:root animated:YES completion:nil];
                Strongself.navigationController.navigationBarHidden = NO;
            }else { //第一次注册
                
                MyLog(@"%@",resoutObj[@"return_code"]);
                RegisterViewController *registerVC = [RegisterViewController new];
                [Strongself presentViewController:registerVC animated:YES completion:nil];
            }
        }
    }];
}







@end
