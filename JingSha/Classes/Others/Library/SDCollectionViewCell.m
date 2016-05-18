//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
    
    __weak UIView *littleView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self addSubview:imageView];
}

- (void)setupTitleLabel
{
    UIView *view = [[UIView alloc] init];
    littleView = view;
    [self addSubview:view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_isButtomTitleLabel == NO) {
        CGFloat titleLabelW = self.sd_width ;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height ;
        _imageView.frame = self.bounds;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        _titleLabel.hidden = !_titleLabel.text;
    }
    
    
    if (_isButtomTitleLabel == YES) {
        CGFloat titleLabelW = self.sd_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW /3 * 2, titleLabelH);
        littleView.backgroundColor = _titleLabel.backgroundColor;
        littleView.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);;
        _titleLabel.hidden = !_titleLabel.text;
        _imageView.frame = CGRectMake(0, 0, self.sd_width, self.sd_height - _titleLabelHeight + 2);
    }


    
//     CGFloat titleLabelY = self.sd_height;
//    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
//    _titleLabel.hidden = !_titleLabel.text;
}

@end
