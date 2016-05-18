//
//  UpLoadView.m
//  JingSha
//
//  Created by 周智勇 on 16/1/29.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "UpLoadView.h"

@interface UpLoadView ()

@property (nonatomic, strong)UILabel * leftLable;
@property (nonatomic, strong)UIView * backView;
@end

@implementation UpLoadView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, kUIScreenWidth - 40, 40)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
        [self addSubview:_backView];
        [_backView addSubview:self.leftLable];
        [_backView addSubview:self.button1];
        [_backView addSubview:self.button2];
    }
    return  self;
}

- (UILabel *)leftLable{
    if (_leftLable == nil) {
        self.leftLable  = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 60, 20)];
        self.leftLable.text = @"上传图片:";
        self.leftLable.font = [UIFont systemFontOfSize:13];
        self.leftLable.textColor = RGBColor(129, 129, 129);
    }
    return _leftLable;
}

- (UIButton *)button1{
    if (_button1 == nil) {
        self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(_backView.size.width/2 - 50,5, 100, 30);
        _button1.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button1 setTitleColor:RGBColor(129, 129, 129) forState:UIControlStateNormal];
//        _button1.layer.masksToBounds = YES;
//        _button1.layer.borderColor = [UIColor grayColor].CGColor;
//        _button1.layer.borderWidth = 1;
    }
    return _button1;
}

- (UIButton *)button2{
    if (_button2 == nil) {
        self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(_backView.size.width - 50, 10, 50, 20);
        [_button2 setTitle:@"上传" forState:UIControlStateNormal];
        _button2.titleLabel.textAlignment = NSTextAlignmentRight;
        [_button2 setTitleColor:RGBColor(129, 129, 129) forState:UIControlStateNormal];
        _button2.titleLabel.font = [UIFont systemFontOfSize:13];
//        _button2.layer.masksToBounds = YES;
//        _button2.layer.borderColor = [UIColor grayColor].CGColor;
//        _button2.layer.borderWidth = 1;
    }
    return _button2;
}













@end
