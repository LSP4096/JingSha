//
//  SingUpViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/6.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "SingUpViewController.h"
#import "MyTextView.h"
#import <MZFormSheetController.h>
#import "NeedKnownViewController.h"
@interface SingUpViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFild;

@property (weak, nonatomic) IBOutlet MyTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *dunButtoon;
@property (weak, nonatomic) IBOutlet UIButton *jinButton;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong)UILabel * countLable;
@property (nonatomic, assign)BOOL hiden;
@end

@implementation SingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate  =self;
    self.title = @"报价填写";
    [self congfigerCountLable];
}

/**
 *  放置右下角的数量Lable
 */
- (void)congfigerCountLable{
    self.countLable = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth - 90, CGRectGetMaxY(self.textView.frame) - 25, 65, 20)];
    _countLable.textAlignment = NSTextAlignmentRight;
    _countLable.text = @"0/200";
    _countLable.textColor = RGBColor(201, 201, 201);
    _countLable.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_countLable];
}
- (IBAction)confirmButClicked:(UIButton *)sender {
    NSString * netPath = @"userinfo/buy_baojia";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:[NSString stringWithFormat:@"%@%@", self.textFild.text, self.rightButton.titleLabel.text] forKey:@"jiage"];
    [allParams setObject:self.textView.text forKey:@"title"];
    [allParams setObject:self.Id forKey:@"bid"];
    if (self.textFild.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写价格"];
    }else{
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"报价成功%@", responseObj);
        [SVProgressHUD showSuccessWithStatus:@"报价成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
        [SVProgressHUD showSuccessWithStatus:@"报价失败"];
    }];
  }
}
- (IBAction)youNeedToKnownButClicked:(UIButton *)sender {
    
    NeedKnownViewController * needVC = [[NeedKnownViewController alloc] init];

    //把弹窗里的数据传出来
    MZFormSheetController * fromSheet = [[MZFormSheetController alloc] initWithViewController:needVC];
    fromSheet.shouldCenterVertically = YES;
    fromSheet.cornerRadius =0;
    fromSheet.shouldDismissOnBackgroundViewTap = YES;
    fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 40, 200);
    [fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    NSInteger num = [textView.text length];
    if (num > 200) {
        NSMutableString * string = [self.textView.text mutableCopy];
        [string deleteCharactersInRange:NSMakeRange(200, num - 200)];
        self.textView.text= string;
        _countLable.text = [NSString stringWithFormat:@"%ld/200", num];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能输入200字" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ensureAction];
    }else{
        _countLable.text = [NSString stringWithFormat:@"%ld/200", num];
    }
}

#pragma mark ---

- (IBAction)rightButtonClicked:(id)sender {
    if (!self.hiden) {
        self.backView.hidden = NO;
    }else{
        self.backView.hidden = YES;
    }
    self.hiden = !self.hiden;
}
- (IBAction)dunButtonClicked:(id)sender {
    self.backView.hidden =  YES;
    self.hiden = !self.hiden;
    [self.rightButton setTitle:@"元/吨" forState:UIControlStateNormal];
}

- (IBAction)jinButtonClicked:(id)sender {
    self.backView.hidden =  YES;
    self.hiden = !self.hiden;
    [self.rightButton setTitle:@"元/公斤" forState:UIControlStateNormal];
}


@end
