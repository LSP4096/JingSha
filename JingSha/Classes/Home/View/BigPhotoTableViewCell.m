//
//  BigPhotoTableViewCell.m
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "BigPhotoTableViewCell.h"

@interface BigPhotoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *clickLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation BigPhotoTableViewCell


- (void)configureDataWithModel:(XWNewsModel *)model {
    self.titleLabel.text = model.title;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[model.photo firstObject]] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    self.clickLabel.text = model.click;
    self.timeLabel.text = model.time;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
