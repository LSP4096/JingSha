//
//  Feedback ViewController.m
//  JingSha
//
//  Created by BOC on 15/11/7.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "Feedback ViewController.h"
#import "MyTextView.h"
@interface Feedback_ViewController ()
@property (weak, nonatomic) IBOutlet MyTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, assign) NSInteger count;
@end

@implementation Feedback_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.textView.layer.cornerRadius = 5;
    self.textView.placeholder = @"请输入反馈内容";
    self.makeSureBtn.layer.cornerRadius = 5;
    self.makeSureBtn.backgroundColor = RGBColor(56, 93, 152);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCount:) name:@"count" object:[UILabel class]];
}
- (void)getCount:(NSNotification *)center {
    self.count = [[[center userInfo] valueForKey:@"count"] integerValue];
    //确定输入的文字字数
     if (self.count >= 200 ){
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"0/200"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,str.length-4)];
        self.countLabel.attributedText = str;
    } else {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd/200", (200 - self.count)]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,str.length-4)];
        self.countLabel.attributedText = str;
//        self.countLabel.text = [NSString stringWithFormat:@"%ld/200", (200 - self.count)];
    }
}
#pragma mark - 确认提交
- (IBAction)handleFeed:(UIButton *)sender {
    if (self.textView.text.length > 0 && self.count <= 200) {
        //        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        NSString * netPath = @"news/feedback";
        NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
        [allParams setObject:self.textView.text forKey:@"title"];
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
        [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
        [self.navigationController popViewControllerAnimated:YES];
    } else  if (self.textView.text.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"字数过多"];
    }
    
}



@end
