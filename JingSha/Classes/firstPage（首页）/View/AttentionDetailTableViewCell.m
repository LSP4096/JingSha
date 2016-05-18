//
//  AttentionDetailTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/2/24.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "AttentionDetailTableViewCell.h"

@interface AttentionDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *chengfenLable;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *jiageLable;
@end

@implementation AttentionDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(ProOptionModel *)model{//这里返回的值全部都是有值的或者@“”的。没有<NULL>
    _model = model;
    if ([_model.photo isKindOfClass:[NSNull class]] || [_model.photo isEqualToString:@""]) {
        _photoImageView.image = [UIImage imageNamed:@"NetBusy"];
    }else{
        [_photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"netBusy"] completed:nil];
    }
    self.gongsiLable.text = _model.gongsi;
    self.jiageLable.text = _model.jiage;
    self.titleLable.text = _model.title;
    self.chengfenLable.text = _model.chengfen;
}
@end
