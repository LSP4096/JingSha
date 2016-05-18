//
//  AnswerMessageViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AnswerMessageViewController.h"
#import "MyTextView.h"
@interface AnswerMessageViewController ()
@property (weak, nonatomic) IBOutlet MyTextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *countLable;
@end

@implementation AnswerMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"留言回复";
    self.textView.placeholder = @"请输入留言内容";
    self.textView.placeholderColor = RGBColor(139, 139, 139);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction1:) name:@"count" object:nil];
}
- (IBAction)confirmPushMessage:(UIButton *)sender {
    
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"96.1FM" object:nil];
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
