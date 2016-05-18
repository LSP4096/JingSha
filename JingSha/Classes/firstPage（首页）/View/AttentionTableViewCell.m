//
//  AttentionTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/11.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AttentionTableViewCell.h"

@interface AttentionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@end

@implementation AttentionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.attentionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setModel:(AttentionModel *)model{
    _model = model;
    self.titleLable.text =  _model.title;
    if ([_model.guanzhu isEqualToString:@"false"]) {
        [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:RGBColor(252, 151, 36) forState:
         UIControlStateNormal];
        self.attentionButton.layer.borderColor = RGBColor(253, 132, 7).CGColor;
       
    }else{
        [self.attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:RGBColor(162, 162, 162) forState:
         UIControlStateNormal];
        self.attentionButton.layer.borderColor = RGBColor(193, 193, 193).CGColor;
        
    }
}


- (void)buttonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAttentionBut:)]) {
        [self.delegate didClickedAttentionBut:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
