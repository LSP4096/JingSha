//
//  HeaderView.m
//  CityListDemo
//
//  Created by Frank on 15/8/5.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
@property (nonatomic, retain) UIButton *arrowButton;
@property (nonatomic, retain) UIImageView *openOrCloseImageView;
@end

@implementation HeaderView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.arrowButton];
        [self addSubview:self.openOrCloseImageView];
    }
    return self;
}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        self.arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //按钮内容缩进量,往右缩进10
        _arrowButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_arrowButton setTitle:@"北京" forState:UIControlStateNormal];
        [_arrowButton setTitleColor:RGBColor(117, 117, 117) forState:UIControlStateNormal];
        _arrowButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_arrowButton setBackgroundColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
        //按钮内容对齐方式 -- 左对齐
        _arrowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _arrowButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_arrowButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        _arrowButton.imageView.clipsToBounds = NO;
        _arrowButton.imageView.contentMode = UIViewContentModeCenter;

    }
    return _arrowButton;
}

- (UIImageView *)openOrCloseImageView {
    if (!_openOrCloseImageView) {
        self.openOrCloseImageView = [[UIImageView alloc] init];
        _openOrCloseImageView.image = [UIImage imageNamed:@"search_close"];
    }
    return _openOrCloseImageView;
}


//布局方法(为什么把frame写在懒加载里，不显示？)
- (void)layoutSubviews {
    [super layoutSubviews];
    self.arrowButton.frame = self.bounds;
    self.openOrCloseImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30, 13, 14, 14);
}

- (void)handleAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:sender];
    }
}

- (void)setModel:(ProvinceModel *)model{
    _model = model;
    [self.arrowButton setTitle:_model.province forState:UIControlStateNormal];
    if (self.model.isOpen) {
        _openOrCloseImageView.image = [UIImage imageNamed:@"search_open"];
    }else{
        _openOrCloseImageView.image = [UIImage imageNamed:@"search_close"];
    }
}

- (void)setTypeModel:(TypeModel *)typeModel{
    _typeModel = typeModel;
    [self.arrowButton setTitle:_typeModel.title forState:UIControlStateNormal];
    if (self.typeModel.isOpen) {
        _openOrCloseImageView.image = [UIImage imageNamed:@"search_open"];
    }else{
        _openOrCloseImageView.image = [UIImage imageNamed:@"search_close"];
    }
}



@end




