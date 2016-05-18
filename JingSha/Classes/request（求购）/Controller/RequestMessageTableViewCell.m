//
//  RequestMessageTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RequestMessageTableViewCell.h"

@interface RequestMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *baonumLable;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *jianjieLable;

@end

@implementation RequestMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(MyRequestModel *)model{
    _model = model;
    self.baonumLable.text = _model.baonum;
//    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] completed:nil];
    
    if (![_model.photo isKindOfClass:[NSNull class]]) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    }else{
        self.photoImageView.image = [UIImage imageNamed:@"NetBusy"];
    }
    self.titleLable.text = _model.title;
    self.jianjieLable.text = _model.jianjie;
}

@end
