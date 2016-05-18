//
//  selectFooterView.m
//  JingSha
//
//  Created by 周智勇 on 15/12/24.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "selectFooterView.h"

@interface selectFooterView()
@property (nonatomic, strong)UILabel *selectCountLable;
@property (nonatomic, strong)UIButton * confirmBut;

@end


@implementation selectFooterView

- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBColor(247, 247, 247);
        [self addSubview:self.selectCountLable];
        [self addSubview:self.confirmBut];
    }
    return self;
}
- (UILabel *)selectCountLable{
    if (_selectCountLable == nil) {
        self.selectCountLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 130, 20)];
//        _selectCountLable.textColor = [UIColor redColor];
        NSRange range = NSMakeRange(3, 1);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"已选择0个供应产品"];
        [str addAttribute:NSForegroundColorAttributeName value:RGBColor(100, 100, 100) range:NSMakeRange(0,3)];
        [str addAttribute:NSForegroundColorAttributeName value:RGBColor(250, 27, 34) range:range];
        [str addAttribute:NSForegroundColorAttributeName value:RGBColor(100, 100, 100) range:NSMakeRange(4,5)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 9)];
        _selectCountLable.attributedText = str;
    }
    return _selectCountLable;
}

-(UIButton *)confirmBut{
    if (_confirmBut == nil) {
        self.confirmBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBut.frame = CGRectMake(kUIScreenWidth - 100, 0, 100, 45);
        [_confirmBut setTitle:@"确定刷新" forState:UIControlStateNormal];
        _confirmBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBut setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
        _confirmBut.backgroundColor = RGBColor(30, 78, 144);
        [_confirmBut addTarget:self action:@selector(confirmButClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBut;
}

-(void)setString:(NSString *)string{
    _string = string;
    NSRange range = NSMakeRange(3, _string.length - 8);
    MyLog(@"%ld", _string.length);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_string];
    [str addAttribute:NSForegroundColorAttributeName value:RGBColor(100, 100, 100) range:NSMakeRange(0,3)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBColor(250, 27, 34) range:range];
    [str addAttribute:NSForegroundColorAttributeName value:RGBColor(100, 100, 100) range:NSMakeRange(_string.length - 5,5)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, _string.length)];
    _selectCountLable.attributedText = str;
}
/**
 *  button Clicked
 */
- (void)confirmButClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmRefresh)]) {
        [self.delegate confirmRefresh];
    }
}


@end
