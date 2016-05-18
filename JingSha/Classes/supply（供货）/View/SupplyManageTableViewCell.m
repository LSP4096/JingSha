//
//  SupplyManageTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SupplyManageTableViewCell.h"

@interface SupplyManageTableViewCell ()

@property (strong, nonatomic)UIImageView *picImageView;
@property (strong, nonatomic)UILabel *priceLable1;
@property (strong, nonatomic)UILabel *priceLable;
@property (strong, nonatomic)UILabel *titleLable;
@property (strong, nonatomic)UILabel *contentLable;
@property (strong, nonatomic)UILabel *secondTitleLable;
@property (strong, nonatomic)UILabel *secondContentLable;

@property (nonatomic, strong)UIButton * rightBut;//待审核button
@end
@implementation SupplyManageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.picImageView];
        [self.contentView addSubview:self.priceLable1];
        [self.contentView addSubview:self.priceLable];
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.contentLable];
        [self.contentView addSubview:self.secondTitleLable];
        [self.contentView addSubview:self.secondContentLable];
        [self.contentView addSubview:self.rightBut];
    }
    return self;
}

- (UIImageView *)picImageView{
    if (_picImageView == nil) {
        self.picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 75, 50)];
//        _picImageView.backgroundColor = [UIColor redColor];
        self.picImageView.image = [UIImage imageNamed:@"网络暂忙-193-133"];
    }
    return _picImageView;
}

- (UILabel *)priceLable1{
    if (_priceLable1 == nil) {
        self.priceLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 66,30, 15)];
        _priceLable1.font = [UIFont systemFontOfSize:12];
        _priceLable1.textColor = RGBColor(78, 78, 78);
        _priceLable1.text = @"价格:";
//        _priceLable1.backgroundColor = [UIColor blueColor];
    }
    return _priceLable1;
}

- (UILabel *)priceLable{
    if (_priceLable == nil) {
        self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 66, 54, 15)];
        _priceLable.font = [UIFont systemFontOfSize:12];
        _priceLable.textColor = RGBColor(78, 78, 78);
        _priceLable.text = @"78000/吨";
//        _priceLable.backgroundColor = [UIColor redColor];
    }
    return _priceLable;
}

- (UILabel *)titleLable{
    if (_titleLable == nil) {
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(105, 8, kUIScreenWidth - 115, 21)];
        _titleLable.font = [UIFont systemFontOfSize:12];
        _titleLable.text = @"粘胶短纤";
        _titleLable.textColor = RGBColor(78, 78, 78);
    }
    return _titleLable;
}

- (UILabel *)contentLable{
    if (_contentLable == nil) {
        self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(105, 29, kUIScreenWidth - 115, 29)];
        _contentLable.numberOfLines = 0;
        _contentLable.textColor = RGBColor(137, 137, 137);
        _contentLable.font = [UIFont systemFontOfSize:12];
        _contentLable.text = @"速度预定好司机哦发 i 就是不好的简单大方让短发iAd  ";
    }
    return _contentLable;
}

- (UILabel *)secondTitleLable{
    if (_secondTitleLable == nil) {
        self.secondTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 66,36, 15)];
        _secondTitleLable.textColor = RGBColor(78, 78, 78);
        _secondTitleLable.text = @"规格:";
        _secondTitleLable.font = [UIFont systemFontOfSize:12];
    }
    return _secondTitleLable;
}
- (UILabel *)secondContentLable {
    if (_secondContentLable == nil) {
        self.secondContentLable = [[UILabel alloc] initWithFrame:CGRectMake(146, 66, kUIScreenWidth - 165, 15)];
        _secondContentLable.font = [UIFont systemFontOfSize:12];
        _secondContentLable.textColor = RGBColor(78, 78, 78);
        _secondContentLable.text = @"1.5D*38mm 1.2D*38mm";
    }
    return _secondContentLable;
}

- (UIButton *)rightBut{
    if (_rightBut == nil) {
        self.rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBut.frame = CGRectMake(kUIScreenWidth - 70, 55, 50, 25);
        [_rightBut setTitle:@"待审核" forState:UIControlStateNormal];
        _rightBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBut setTitleColor:RGBColor(225, 46, 62) forState:UIControlStateNormal];
    }
    return _rightBut;
}
#pragma mark --
- (void)setModel:(MySupplyModel *)model{
    _model = model;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    self.priceLable.text = _model.jiage;
    self.titleLable.text = _model.title;
    self.contentLable.text = _model.content;
    self.secondContentLable.text = _model.guige;
    if (_model.isHidden) {
        self.rightBut.hidden = YES;
    }else{
        self.rightBut.hidden = NO;
    }
}


@end
