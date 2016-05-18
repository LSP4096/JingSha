//
//  ThreePhotoTableViewCell.m
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "ThreePhotoTableViewCell.h"

@interface ThreePhotoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdIamgeView;
@property (weak, nonatomic) IBOutlet UILabel *clickLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubTimeLabel;


@end

@implementation ThreePhotoTableViewCell

- (void)configureDataWithModel:(XWNewsModel *)model {
    MyLog(@"%zd", model.photo.count);
    self.titleLabel.text = model.title;
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:model.photo[0]] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:model.photo[1]] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    [self.thirdIamgeView sd_setImageWithURL:[NSURL URLWithString:model.photo[2]] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    self.clickLabel.text = model.click;
    self.pubTimeLabel.text = model.time;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
