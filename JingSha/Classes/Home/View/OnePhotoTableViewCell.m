//
//  OnePhotoTableViewCell.m
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "OnePhotoTableViewCell.h"

@interface OnePhotoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avartView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubLabel;

@end

@implementation OnePhotoTableViewCell

- (void)configureDataWithModel:(XWNewsModel *)model {
    [self.avartView sd_setImageWithURL:[NSURL URLWithString:[model.photo firstObject]] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.clickLabel.text = model.click;
    self.pubLabel.text = model.time;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
