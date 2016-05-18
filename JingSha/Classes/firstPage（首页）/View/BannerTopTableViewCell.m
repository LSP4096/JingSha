//
//  BannerTopTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/1/18.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "BannerTopTableViewCell.h"

@interface BannerTopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;


@end
@implementation BannerTopTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
}

- (void)setModel:(IssueModel *)model{
    _model =  model;
    self.contentField.text = _model.contentStr;
    self.leftTitle.text = _model.leftTitle;
}

@end
