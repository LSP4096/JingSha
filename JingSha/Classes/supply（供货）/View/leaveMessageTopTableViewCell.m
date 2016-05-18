//
//  leaveMessageTopTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "leaveMessageTopTableViewCell.h"

@interface leaveMessageTopTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;


@end


@implementation leaveMessageTopTableViewCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
}
- (IBAction)playTelButtonClicked:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.contentView addSubview:callWebview];//打电话，这里可能不能加到cell中？？？？？？？？
}

- (void)setModel:(MessageModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.logo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    self.companyNameLable.text = _model.gongsi;
    self.nameLable.text = _model.name;
    self.phoneNumLable.text = _model.tel;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
