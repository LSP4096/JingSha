//
//  ChangePWViewController.m
//  JingSha
//
//  Created by BOC on 15/11/6.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "ChangePWViewController.h"
#import "SingleTon.h"
#import "NSString+Hash.h"
@interface ChangePWViewController ()
@property (weak, nonatomic) IBOutlet UIView *oldPasswordBGView;
@property (weak, nonatomic) IBOutlet UITextField *oldTF;

@property (weak, nonatomic) IBOutlet UIView *inputPassWordBGView;
@property (weak, nonatomic) IBOutlet UITextField *inputPassWordTF;

@property (weak, nonatomic) IBOutlet UIView *maekSureBGView;
@property (weak, nonatomic) IBOutlet UITextField *makeSureTF;

@property (weak, nonatomic) IBOutlet UIButton *markSureChange;

@end

@implementation ChangePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self contifureTF];
}
//配置输入框
- (void)contifureTF {
    [self configureTexfiled:self.oldTF iamgeName:@"tab-fg03" bgView:self.oldPasswordBGView];
    [self configureTexfiled:self.inputPassWordTF iamgeName:@"tab-fg03" bgView:self.inputPassWordBGView];
    [self configureTexfiled:self.makeSureTF iamgeName:@"tab-fg03" bgView:self.maekSureBGView];
    [KeyboardToolBar registerKeyboardToolBar:self.oldTF];
    [KeyboardToolBar registerKeyboardToolBar:self.inputPassWordTF];
    [KeyboardToolBar registerKeyboardToolBar:self.makeSureTF];
    //修改btn的边框
    self.markSureChange.layer.cornerRadius = 5;
    _markSureChange.backgroundColor = RGBColor(56, 93, 152);
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

#pragma mark - 修改密码
- (IBAction)handleChangePW:(UIButton *)sender {
    [self changePassWord];
}
- (void)changePassWord {
    if (![self checkOut]) {
        MyLog(@"已经返回");
        return;
    }
    NSDictionary *userInfo = [SingleTon shareSingleTon].userInformation;
     NSString *netPath = @"userinfo/edit_pwd";
    NSMutableDictionary *allparameters = [NSMutableDictionary dictionary];
    [allparameters setObject:userInfo[@"userid"] forKey:@"userid"];
    [allparameters setObject:self.makeSureTF.text.md5String forKey:@"newpwd"];
    [allparameters setObject:self.oldTF.text.md5String forKey:@"ordpwd"];
    [HttpTool postWithPath:netPath params:allparameters success:^(id responseObj) {
        if ( [responseObj[@"return_code"] integerValue] != -200) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [SingleTon shareSingleTon].userPassWoed = self.makeSureTF.text.md5String;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (NSInteger)checkOut {
    NSArray *array = @[self.oldTF, self.inputPassWordTF, self.makeSureTF];
    for (int i = 0; i < array.count; i++) {
        if (![self checkUserInputWithTF:array[i]]) {
            return 0;
        }
    }  if (![self.inputPassWordTF.text isEqualToString:self.makeSureTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return 0;
    } else if ([self.oldTF.text isEqualToString:self.makeSureTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"新旧密码一样"];
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
