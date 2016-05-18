//
//  ConfirmRequestViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/18.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ConfirmRequestViewController.h"
#import "MyRequestViewController.h"
@interface ConfirmRequestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *connectPersonField;
@property (weak, nonatomic) IBOutlet UITextField *connectTelField;
@property (weak, nonatomic) IBOutlet UITextField *gongsiField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ConfirmRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布求购";
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5;
    
    [self configerShowData];
}
- (void)configerShowData{
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        NSDictionary * dataDict = responseObj[@"data"];
        if (![dataDict[@"gongsi"] isKindOfClass:[NSNull class]]) {
            self.gongsiField.text = dataDict[@"gongsi"];
        }
        if (![dataDict[@"lxr"] isKindOfClass:[NSNull class]]) {
            self.connectPersonField.text = dataDict[@"lxr"];
        }
        if (![dataDict[@"dianhua"] isKindOfClass:[NSNull class]]) {
            self.connectTelField.text = dataDict[@"dianhua"];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  确认求购之后，直接pop 到我的求购主页面
 */
- (IBAction)confirmRequestButton:(UIButton *)sender {
    
    if (self.connectPersonField.text.length == 0) {
        [self showAlertView:@"联系人不能为空"];
        return;
    }
    if (self.connectTelField.text.length == 0) {
        [self showAlertView:@"联系电话不能为空"];
        return;
    }
    if (self.gongsiField.text.length == 0) {
        [self showAlertView:@"公司不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@"正在上传..."];
    NSMutableDictionary * allParams = [NSMutableDictionary dictionaryWithDictionary:self.dict];
        [allParams setObject:self.connectPersonField.text forKey:@"name"];
    [allParams setObject:self.connectTelField.text forKey:@"tel"];
    [allParams setObject:self.gongsiField.text forKey:@"gongsi"];
        NSString * netPath = @"userinfo/buy_add";
        [HttpTool postWithPath:netPath indexName:@"img" imagePathList:self.imageAry params:allParams success:^(id responseObj) {
            [MBProgressHUD hideHUD];
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [self popToVC];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
            MyLog(@"----%@", error);
        }];
    }

- (void)popToVC{
    for (UIViewController *vcHome in self.navigationController.viewControllers) {
        if ([vcHome isKindOfClass:[MyRequestViewController class]]) {
            [self.navigationController popToViewController:vcHome animated:YES];
        }
    }
}

- (void)showAlertView:(NSString *)string{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



@end
