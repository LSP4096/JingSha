//
//  RegisterViewController.m
//  JingSha
//
//  Created by BOC on 15/11/4.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Hash.h"
#import "AgreeProtocolViewController.h"
#import "MZFormSheetController.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *nameBGView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UIView *passWordBGView;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;

@property (weak, nonatomic) IBOutlet UIView *makeSurePWBGView;
@property (weak, nonatomic) IBOutlet UITextField *makeSurePWTF;

@property (weak, nonatomic) IBOutlet UIView *phoneNumBGWiew;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UIView *seccodeBGView;
@property (weak, nonatomic) IBOutlet UITextField *seccodeTF;

@property (weak, nonatomic) IBOutlet UIButton *sendSeccodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;


//后台返回的验证码
@property (nonatomic, copy) NSString *code;


@end
@implementation RegisterViewController
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self contifureTF];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}
//配置输入框
- (void)contifureTF {
    [self configureTexfiled:self.nameTF iamgeName:@"注册_03" bgView:self.nameBGView];
    [self configureTexfiled:self.passWordTF iamgeName:@"tab-fg03" bgView:self.passWordBGView];
    [self configureTexfiled:self.makeSurePWTF iamgeName:@"tab-fg03" bgView:self.makeSurePWBGView];
    [self configureTexfiled:self.phoneNumTF iamgeName:@"tab-fg01" bgView:self.phoneNumBGWiew];
    [self configureTexfiled:self.seccodeTF iamgeName:@"tab-fg02" bgView:self.seccodeBGView];
//    [KeyboardToolBar registerKeyboardToolBar:self.nameTF];
//    [KeyboardToolBar registerKeyboardToolBar:self.passWordTF];
//    [KeyboardToolBar registerKeyboardToolBar:self.makeSurePWTF];
//    [KeyboardToolBar registerKeyboardToolBar:self.phoneNumTF];
//    [KeyboardToolBar registerKeyboardToolBar:self.seccodeTF];
    //修改btn的边框 21 56 103
    self.sendSeccodeBtn.layer.cornerRadius = 5;
    _sendSeccodeBtn.backgroundColor = RGBColor(56, 93, 152);
    self.registerBtn.layer.cornerRadius = 5;
    _registerBtn.backgroundColor = RGBColor(56, 93, 152);
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
    if (![self checkUserInputWithTF:self.phoneNumTF]) {
        [self showAlertViewWithTitle:@"请输入手机号码"];
        return;
    } else if (self.phoneNumTF.text.length != 11) {
        [self showAlertViewWithTitle:@"请输入正确的手机号码"];
        return;
    }
    NSString *netPath = @"userinfo/createcode";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:self.phoneNumTF.text forKey:@"tel"];
    [allParameters setObject:@"1" forKey:@"type"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        MyLog(@"%@",responseObj);
        MyLog(@"%@,%@, %@", responseObj[@"return_code"],responseObj[@"data"],responseObj[@"msg"]);
        if ([responseObj[@"return_code"] integerValue] == 0) {
            //开启计时器倒计时
            [self startResidualTimer];
            self.code = [NSString stringWithFormat:@"%@", responseObj[@"data"][@"code"]];
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
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
#pragma mark - 立即注册
- (IBAction)handleRegester:(UIButton *)sender {
    [self userRegist];
}
#pragma mark - 已有账号
- (IBAction)handleHavenID:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 勾选协议
- (IBAction)handleAgree:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"注册sel_03"] forState:UIControlStateNormal];
//        //弹出协议
//        AgreeProtocolViewController *agreeVC = [[AgreeProtocolViewController alloc] init];
//        [self mz_presentFormSheetWithViewController:agreeVC animated:YES transitionStyle:MZFormSheetTransitionStyleBounce completionHandler:^(MZFormSheetController *formSheetController) {
//            formSheetController.shouldDismissOnBackgroundViewTap = YES;
//            formSheetController.formSheetController.shouldCenterVertically = YES;
//            formSheetController.presentedFormSheetSize = CGSizeMake(375 *KProportionWidth, 450*KProportionHeight);
//            formSheetController.presentedFSViewController.view.frame =  CGRectMake(10 *KProportionWidth, 100*KProportionHeight, 355*KProportionWidth, 450*KProportionHeight);
//        }];
    }
    if (sender.selected == NO) {
         [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"注册sel_03_03"] forState:UIControlStateNormal];
    }
}
- (IBAction)checkAgree:(UIButton *)sender {
    //弹出协议
    AgreeProtocolViewController *agreeVC = [[AgreeProtocolViewController alloc] init];
    [self mz_presentFormSheetWithViewController:agreeVC animated:YES transitionStyle:MZFormSheetTransitionStyleBounce completionHandler:^(MZFormSheetController *formSheetController) {
        formSheetController.shouldDismissOnBackgroundViewTap = YES;
        formSheetController.formSheetController.shouldCenterVertically = YES;
        formSheetController.presentedFormSheetSize = CGSizeMake(375 *KProportionWidth, 450*KProportionHeight);
        formSheetController.presentedFSViewController.view.frame =  CGRectMake(10 *KProportionWidth, 100*KProportionHeight, 355*KProportionWidth, 450*KProportionHeight);
    }];

}




- (void)userRegist {
    if (![self checkOut]) {
        MyLog(@"已经返回");
        return;
    }
    NSString *netPath = @"userinfo/reg";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:self.phoneNumTF.text forKey:@"tel"];
    [allParameters setObject:self.passWordTF.text.md5String forKey:@"password"];
    [allParameters setObject:self.nameTF.text forKey:@"username"];
    [allParameters setObject:self.code forKey:@"code"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        if ([responseObj[@"return_code"] integerValue] == 0) {
//            [self showAlertViewWithTitle:@"注册成功"];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [self backLoginVC:nil];
            return ;
        }
            [self showAlertViewWithTitle:responseObj[@"msg"]];
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)checkOut {
    NSArray *array = @[self.nameTF, self.passWordTF, self.makeSurePWTF, self.phoneNumTF,self.seccodeTF];
    for (int i = 0; i < array.count; i++) {
        if (![self checkUserInputWithTF:array[i]]) {
            return 0;
        }
    }
    if (![self.passWordTF.text isEqualToString:self.makeSurePWTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致" maskType:SVProgressHUDMaskTypeGradient];
        return 0;
    } else if (self.phoneNumTF.text.length != 11) {
        [self showAlertViewWithTitle:@"请输入正确的手机号码"];
        return 0;
    } else if (self.agreeBtn.selected == NO) {
        [SVProgressHUD showErrorWithStatus:@"请勾选协议"];
        return 0;
    }
    else if ([self.code isEqualToString:@"验证超时"]) {
        [SVProgressHUD showErrorWithStatus:@"验证超时"];
        return 0;
    } else if (![self.code isEqualToString:[NSString stringWithFormat:@"%@", self.seccodeTF.text]]) {
        MyLog(@"%@,%@", self.copy, _seccodeTF.text);
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return 0;
    }
    return 1;
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
    if ([alertView.message isEqualToString:@"注册成功"]) {
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
- (IBAction)backLoginVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
