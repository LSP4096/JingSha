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

@interface XWLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *pssWordTF;

@end

@implementation XWLoginController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginBtn];
//    [KeyboardToolBar registerKeyboardToolBar:_userAccountTF];
//    [KeyboardToolBar registerKeyboardToolBar:_pssWordTF];
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
    
    @WeakObj(self);
    [[HttpClient sharedClient] LoginWithAccount:self.userAccountTF.text Password:self.pssWordTF.text.md5String Complection:^(id resoutObj, NSError *error) {
        @StrongObj(self)
        if (error) {
            MyLog(@"=======登录请求错误======\n\n%@",error);
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

@end
