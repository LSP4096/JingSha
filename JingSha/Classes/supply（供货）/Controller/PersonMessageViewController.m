//
//  PersonMessageViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "PersonMessageViewController.h"
#import "MyTextView.h"
@interface PersonMessageViewController ()
@property (weak, nonatomic) IBOutlet MyTextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *telnameField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@end

@implementation PersonMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //H5页面备用
    self.title = @"兑换资料填写";
    self.textView.placeholder = @"请输入说明内容";
    self.textView.placeholderColor = RGBColor(133, 133, 133);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction1:) name:@"count" object:nil];

}
- (IBAction)confirmButClicked:(UIButton *)sender {
    NSString * netPath = @"userinfo/shop_duihuan";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.sid forKey:@"sid"];
    if (self.nameField.text.length == 0 || self.telnameField.text.length == 0 || self.addressTextField.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确保必填项不为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [allParams setObject:self.nameField.text forKey:@"name"];
    [allParams setObject:self.telnameField.text forKey:@"tel"];
    [allParams setObject:self.addressTextField.text forKey:@"addr"];
    [allParams setObject:self.textView.text forKey:@"content"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

- (void)notificationAction1:(NSNotification *)notify{
    NSInteger count = [[notify.userInfo objectForKey:@"count"] integerValue];
    self.countLable.text = [NSString stringWithFormat:@"%ld/200", (long)count];
    if ([[notify.userInfo objectForKey:@"count"] integerValue] > 200) {
        NSMutableString * string = [_textView.text mutableCopy];
        [string deleteCharactersInRange:NSMakeRange(200, count - 200)];
        _textView.text = string;
        self.countLable.text = @"200/200";
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能输入200字" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ensureAction];
    }
}


@end
