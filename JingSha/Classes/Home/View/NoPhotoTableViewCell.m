//
//  NoPhotoTableViewCell.m
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "NoPhotoTableViewCell.h"

@implementation NoPhotoTableViewCell


- (void)configureDataWithModel:(XWNewsModel *)model {
    self.iconImageView.image = [UIImage imageNamed:@"tab-eye"];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.pubTime.text = model.time;
    self.clickLabel.text = model.click;
    MyLog(@"%@", model.time);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
