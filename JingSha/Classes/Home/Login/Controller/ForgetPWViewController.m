//
//  ForgetPWViewController.m
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "NSString+Hash.h"
#import "SingleTon.h"

#import "HttpClient+Authentication.h"
@interface ForgetPWViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIView *phoneBGView;


@property (weak, nonatomic) IBOutlet UITextField *seccodeTF;
@property (weak, nonatomic) IBOutlet UIView *seccodeBGView;


@property (weak, nonatomic) IBOutlet UIButton *sendSeccodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputPassWordTF;
@property (weak, nonatomic) IBOutlet UIView *inputPassWBGView;


@property (weak, nonatomic) IBOutlet UITextField *makeSurePWTF;
@property (weak, nonatomic) IBOutlet UIView *makeSureBGView;
@property (weak, nonatomic) IBOutlet UIButton *changeRightAway;
//后台返回的验证码
@property (nonatomic, copy) NSString *code;
//点击修改按钮之后停止计时，状态
@property (nonatomic, assign) BOOL isStop;
@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self contifureTF];
}
//配置输入框
- (void)contifureTF {
    [self configureTexfiled:self.phoneTF iamgeName:@"tab-fg01" bgView:self.phoneBGView];
    [self configureTexfiled:self.seccodeTF iamgeName:@"tab-fg02" bgView:self.seccodeBGView];
    [self configureTexfiled:self.inputPassWordTF iamgeName:@"tab-fg03" bgView:self.inputPassWBGView];
    [self configureTexfiled:self.makeSurePWTF iamgeName:@"tab-fg03" bgView:self.makeSureBGView];
    [KeyboardToolBar registerKeyboardToolBar:self.phoneTF];
    [KeyboardToolBar registerKeyboardToolBar:self.seccodeTF];
    [KeyboardToolBar registerKeyboardToolBar:self.inputPassWordTF];
    [KeyboardToolBar registerKeyboardToolBar:self.makeSurePWTF];
    //修改btn的边框
    self.sendSeccodeBtn.layer.cornerRadius = 5;
    _sendSeccodeBtn.backgroundColor = RGBColor(56, 93, 152);
    self.changeRightAway.layer.cornerRadius = 5;
    _changeRightAway.backgroundColor = RGBColor(56, 93, 152);

}
- (void)configureTexfiled:(UITextField *)tf
                iamgeName:(NSString *)imageName
                   bgView:(UIView *)bgView{
    bgView.layer.cornerRadius = 5;
    //左侧图标
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    myImageView.frame = CGRectMake(0, 0, 30, 30);
    myImageView.contentMode = UIViewContentModeCenter;
    tf.leftView = myImageView;
    tf.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - 发送验证码
- (IBAction)handleSendSeccode:(UIButton *)sender {
    if (![self checkUserInputWithTF:self.phoneTF]) {
//        [self showAlertViewWithTitle:@"请输入手机号码"];
        return;
    } else if (self.phoneTF.text.length != 11) {
        [self showAlertViewWithTitle:@"请输入正确的手机号码"];
        return;
    }
    
    @WeakObj(self);
    [[HttpClient sharedClient] ResetPasswordCodeWithPhoneNumber:self.phoneTF.text Complection:^(id resoutObj, NSError *error) {
        @StrongObj(self);
        if (error) {
            
        }else {
            if ([resoutObj[@"return_code"] integerValue]) {
                [SVProgressHUD showErrorWithStatus:resoutObj[@"msg"]];
            } else {
                //开启计时器倒计时
                [Strongself startResidualTimer];
                Strongself.code = resoutObj[@"data"][@"code"];
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            }
        }
    }];
}

- (void)startResidualTimer {
    self.sendSeccodeBtn.userInteractionEnabled = NO;
    self.sendSeccodeBtn.layer.cornerRadius = 5;
    self.sendSeccodeBtn.layer.masksToBounds = YES;
    [self.sendSeccodeBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.sendSeccodeBtn.userInteractionEnabled = YES;
                [self.sendSeccodeBtn setBackgroundColor:RGBColor(56, 93, 152) forState:UIControlStateNormal];
                [self.sendSeccodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.code = @"验证超时";
            });
        }else{
            int seconds = timeout ;
            //            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新获取验证码", seconds];
            NSString *strTime = [NSString stringWithFormat:@"(%zd)重新验证", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendSeccodeBtn setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
- (NSInteger)checkUserInputWithTF:(UITextField *)tf {
    NSInteger ident = 1;
    NSString *str = tf.placeholder;
    if (!tf.text.length) {
        [self showAlertViewWithTitle:str];
        ident = 0;
    }
    return ident;
}
- (void)showAlertViewWithTitle:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.message isEqualToString:@"修改成功"]) {
        MyLog(@"buttonIndex:%zd", buttonIndex);//buttonIndex表示用户点击按钮的下标
        switch (buttonIndex) {
            case 0:
                break;
                
            default:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
        }
    }
}
#pragma mark - 点击立即修改Btn
- (IBAction)handleChangeInfo:(UIButton *)sender {
    [self userChangePassWodr];
}
- (void)userChangePassWodr {
    self.isStop = YES;
    if (![self checkOut]) {
        MyLog(@"已经返回");
        return;
    }
    
//    [[HttpClient sharedClient] ResetPasswordWithPhoneNumber:self.phoneTF.text Password:self.makeSurePWTF.text.md5String Code:self.code Complection:^(id resoutObj, NSError *error) {
//        if (error) {
//            
//        }else {
//            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//            [SingleTon shareSingleTon].userPassWoed = self.makeSurePWTF.text.md5String;
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
    
    NSString *netPath = @"userinfo/forgetpwd";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:self.phoneTF.text forKey:@"tel"];
    [allParameters setObject:self.makeSurePWTF.text.md5String forKey:@"password"];
    [allParameters setObject:self.code forKey:@"code"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [SingleTon shareSingleTon].userPassWoed = self.makeSurePWTF.text.md5String;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        MyLog(@"%@",error);
    }];
}
- (NSInteger)checkOut {
    NSArray *array = @[self.phoneTF, self.seccodeTF, self.inputPassWordTF, self.makeSurePWTF];
    for (int i = 0; i < array.count; i++) {
        if (![self checkUserInputWithTF:array[i]]) {
            return 0;
        }
    } if (self.phoneTF.text.length != 11) {
        [self showAlertViewWithTitle:@"请输入正确的手机号码"];
        return 0;
    } else if ([self.code isEqualToString:@"验证超时"]) {
        [SVProgressHUD showErrorWithStatus:@"验证超时"];
        return 0;
    } else if (![self.code isEqualToString:[NSString stringWithFormat:@"%@", self.seccodeTF.text]]) {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return 0;
    } else if (![self.inputPassWordTF.text isEqualToString:self.makeSurePWTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return 0;
    }
    return 1;
}

- (IBAction)backLoginVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
