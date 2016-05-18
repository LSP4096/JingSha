//
//  TopHeaderView.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "TopHeaderView.h"
@implementation TopHeaderView

- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Me_jifen"]];
        self.frame = CGRectMake(0, 0, kUIScreenWidth, 120);
        [self addSubview:self.currentCountLable];
        [self addSubview:self.standingsIntroduce];
        [self addSubview:self.countLable];
        [self addSubview:self.convertButton];
    }
    return self;
}


- (UILabel *)currentCountLable{
    if (_currentCountLable == nil) {
        self.currentCountLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 20)];
        _currentCountLable.text = @"当前积分";
        _currentCountLable.textColor = RGBColor(195, 228, 236);
        _currentCountLable.font = [UIFont systemFontOfSize:12];
    }
    return _currentCountLable;
}

- (UIButton *)standingsIntroduce{
    if (_standingsIntroduce == nil) {
        self.standingsIntroduce = [UIButton buttonWithType:UIButtonTypeCustom];
        _standingsIntroduce.frame = CGRectMake(kUIScreenWidth - 85, 5, 75, 20);
        _standingsIntroduce.titleLabel.font = [UIFont systemFontOfSize:12];
        [_standingsIntroduce setTitle:@"积分说明" forState:UIControlStateNormal];
        _standingsIntroduce.titleLabel.textAlignment = NSTextAlignmentRight;
        [_standingsIntroduce setImage:[UIImage imageNamed:@"Me_detail"] forState:UIControlStateNormal];
        [_standingsIntroduce setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
        [_standingsIntroduce setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_standingsIntroduce addTarget:self action:@selector(standingsIntroduceButClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _standingsIntroduce;
}

- (UILabel *)countLable{
    if (_countLable == nil) {
        self.countLable = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2 - 40, 40, 80, 25)];
        _countLable.font = [UIFont systemFontOfSize:24];
        _countLable.textAlignment = NSTextAlignmentCenter;
        _countLable.textColor = RGBColor(255, 255, 255);
        //
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分",self.jifen]];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(str.length - 1,1)];
//        _countLable.attributedText = str;
    }
    return _countLable;
}
- (UIButton *)convertButton{
    if (_convertButton == nil) {
        self.convertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _convertButton.frame = CGRectMake(kUIScreenWidth/2 - 60, 80, 120, 30);
        _convertButton.layer.masksToBounds = YES;
        _convertButton.layer.cornerRadius = 10;
        _convertButton.backgroundColor = RGBColor(10, 41, 75);
        _convertButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_convertButton setTitle:@"积分兑换商品" forState:UIControlStateNormal];
        [_convertButton setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
        [_convertButton setImage:[UIImage imageNamed:@"Me_box"] forState:UIControlStateNormal];
        [_convertButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_convertButton addTarget:self action:@selector(convertButClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _convertButton;
}

- (void)standingsIntroduceButClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToStandingsIntroduce)]) {
        [self.delegate pushToStandingsIntroduce];
    }
}

- (void)convertButClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToStandingsShop)]) {
        [self.delegate pushToStandingsShop];
    }
}
-(void)setJifen:(NSString *)jifen{
    _jifen = jifen;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分",self.jifen]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(str.length - 1,1)];
    _countLable.attributedText = str;
}


@end
