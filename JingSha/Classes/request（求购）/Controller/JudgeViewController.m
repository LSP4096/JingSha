//
//  JudgeViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/17.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "JudgeViewController.h"
#import "PromptViewController.h"
#import <MZFormSheetController.h>
#import "HCSStarRatingView.h"
@interface JudgeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (weak, nonatomic) IBOutlet UILabel *markLable;//获得积分
@property (weak, nonatomic) IBOutlet UILabel *judgeStateLable;//评价层次 专业
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *collectLableBut;
@property (nonatomic, assign)BOOL isChecked;
@property (nonatomic, strong)MZFormSheetController *formSheet;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (nonatomic, copy)NSString * uid;//被评价的公司id。
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starBackView;


@property (nonatomic, assign)CGFloat score;
@end

@implementation JudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.textView.delegate = self;
    [self.collectButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self configerJudgeStarView];
    [self loadData];
}
- (void)configerJudgeStarView{

    [self.starBackView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];

}

- (void)loadData{
    NSString * netPath = @"userinfo/buy_bao_info";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.jid forKey:@"jid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"评价页面的返回信息%@", responseObj);
        NSDictionary * dict = responseObj[@"data"];
//        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];//dict[@"logo"]打印出来为NULL
        self.gongsiLable.text = dict[@"gongsi"];
        self.uid = dict[@"uid"];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    NSInteger number = [textView.text length];
    if (number <= 200) {
        self.countLable.text = [NSString stringWithFormat:@"%ld/200", (long)number];
    }else{
        NSMutableString * string = [_textView.text mutableCopy];
        [string deleteCharactersInRange:NSMakeRange(200, number - 200)];
        _textView.text = string;
        _countLable.text = [NSString stringWithFormat:@"%ld/200", (long)number];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能输入200字" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ensureAction];
    }

}
- (IBAction)submitJudgeButClicked:(UIButton *)sender {
    NSString *netPath = @"userinfo/buy_bao_pingjia";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.uid forKey:@"uid"];
    [allParams setObject:_textView.text forKey:@"title"];
    [allParams setObject:@(self.score) forKey:@"xingji"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"评价成功的返回%@", responseObj);
        [self showPromoteDidGetScore];//显示已经获得积分
    } failure:^(NSError *error) {
        
    }];
}
- (void)showPromoteDidGetScore{
    PromptViewController * promptVC = [[PromptViewController alloc] init];
    self.formSheet = [[MZFormSheetController alloc] initWithViewController:promptVC];
    [promptVC.closePromptBut addTarget:self action:@selector(hiddenPromptView) forControlEvents:UIControlEventTouchUpInside];
    [promptVC.closePromptBut2 addTarget:self action:@selector(hiddenPromptView) forControlEvents:UIControlEventTouchUpInside];
    promptVC.JudgeScoreLable.text = @"评价成功获得20积分";
    _formSheet.shouldCenterVertically = YES;
    _formSheet.cornerRadius =0;
    _formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    _formSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 90, 130);
    [_formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}

- (IBAction)collectButtonClicked:(UIButton *)sender { // tab-star  tab-star02
    if (self.isChecked) {
        [self.collectLableBut setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"tab-star"] forState:UIControlStateNormal];
    }else{
        [self.collectLableBut setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"tab-star02"] forState:UIControlStateNormal];
    }
    self.isChecked = !self.isChecked;
}

/**
 *  点击弹窗的确定
 */
- (void)hiddenPromptView{
    [_formSheet mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --
- (void)didChangeValue:(HCSStarRatingView *)sender{
//    NSLog(@"%f", sender.value);
    self.score = sender.value * 2;
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
