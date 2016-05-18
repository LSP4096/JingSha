//
//  CheckQuoteTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CheckQuoteTableViewCell.h"

@interface CheckQuoteTableViewCell ()


@property (weak, nonatomic) IBOutlet UIButton *telphoneBut2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *telPhoneNumLable;
@property (weak, nonatomic) IBOutlet UILabel *companyLable;
@property (weak, nonatomic) IBOutlet UILabel *connectLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@end

@implementation CheckQuoteTableViewCell

- (void)awakeFromNib {

    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 40;
    
    [self.telphoneBut2 addTarget:self action:@selector(playTelPhone:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  接受报价按钮
 */
- (void)acceptQuoteButtonClicked:(UIButton *)sender{
    MyLog(@"接受报价按钮");
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegatePushToJudgeVC:)]) {
        [self.delegate delegatePushToJudgeVC:sender];
    }
}
/**
 *  打电话，调用系统电话
 */
- (void)playTelPhone:(UIButton *)sender{
    MyLog(@"点击了打电话按钮");
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telPhoneNumLable.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}


- (void)setModel:(CheckQuoteModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.logo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    self.telPhoneNumLable.text = _model.shouji;
    self.companyLable.text = _model.gongsi;
    self.priceLable.text = _model.jiage;
    self.connectLable.text = _model.lxr;
    self.timeLable.text = _model.time;
}

@end
