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
    [defals synchronize];
    //取出密码
    NSString *securety = [SSKeychain passwordForService:kServiceName account:kLoginStateKey];
    self.pssWordTF.text = securety;
    
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
                
                //请求错误信息（后台设置：手机不存在／手机后密码错误）
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
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resoutObj options:NSJSONReadingAllowFragments error:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"WXSaveToken"];
            
            [Strongself saveTokenAndRequireWXInfo];
        }
    }];
    
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage GET:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:@{@"appid":kWXAppId, @"secret":kWXAppSecret, @"code":notifi.object[@"code"], @"grant_type":@"authorization_code"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        /*"access_token" = "OezXcEiiBSKSxW0eoylIeBPKSgTfwua1QABCnleka9CqGYr9J4wP2NHLDEFTP0vqsiS4DFDyXNQmYSaM6dW1s8MrQi6NSC9dV6ZqqjazKWQv3kfeozrm-fbZTXU80vLaWYflw07nkDhmX3KJHsEVxQ";
//         "expires_in" = 7200;
//         openid = o22U5xMHZTjYDi3VwBva3JW6mqGk;
//         "refresh_token" = "OezXcEiiBSKSxW0eoylIeBPKSgTfwua1QABCnleka9CqGYr9J4wP2NHLDEFTP0vq6O1ZVOcyb8uL5dLrcuRaydRmY9BcYgJeOLqRjlLyp5HpBlYc2Ikja-RFm6ghGQ32r_iZfQfAQhtEqwk9ibf8vA";
//         scope = "snsapi_userinfo";
//         unionid = o4bo2vzI0vCvGTa11GBMkx0SbcwQ;*/
//        
//        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"WXSaveToken"];
//        
//        [self saveTokenAndRequireWXInfo];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"access_token error-->%@", error.localizedDescription);
//    }];
}

- (void)saveTokenAndRequireWXInfo
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXSaveToken"];
    [[HttpClient sharedClient] getWeChatUserInfoWithOpenId:dict[@"openid"] AccessToken:dict[@"access_token"] Complection:^(id resoutObj, NSError *error) {
        if (error) {
            MyLog(@"获取微信用户信息失败 %@",error.localizedDescription);
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resoutObj options:NSJSONReadingAllowFragments error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"WXResponse_UserInfo"];
        }
    }];
    
    
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXSaveToken"];
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage GET:@"https://api.weixin.qq.com/sns/userinfo" parameters:@{@"openid":dict[@"openid"], @"access_token":dict[@"access_token"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        //        NSLog(@"%@",dict);
//        //        {
//        //            city = "xxx";
//        //            country = xxx;
//        //            headimgurl = “http://wx.qlogo.cn/mmopen/xxxxxxx/0”;
//        //            language = "zh_CN";
//        //            nickname = xxx;
//        //            openid = xxxxxxxxxxxxxxxxxxx;
//        //            privilege =     (
//        //            );
//        //            province = "xxx";
//        //            sex = 0;
//        //            unionid = xxxxxxxxxxxxxxxxxx;
//        //        }
//        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"WXResponse_UserInfo"];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"userinfo error-->%@", error.localizedDescription);
//    }];
}


@end
