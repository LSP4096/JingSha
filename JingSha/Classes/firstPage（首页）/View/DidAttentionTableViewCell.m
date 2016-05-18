//
//  DidAttentionTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "DidAttentionTableViewCell.h"

@interface DidAttentionTableViewCell ()
@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)UIButton * button;
@property (nonatomic, strong)NSArray * array;
@property (nonatomic, strong)NSMutableArray * attentionAry;


@end

@implementation DidAttentionTableViewCell

- (void)awakeFromNib {
    [self.contentView addSubview:self.backImageView];
//    self.bottomHeight = 0;
}

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, kUIScreenWidth - 40, 120)];
        _backImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whichAttentionClickedddd:)];
        [_backImageView addGestureRecognizer:tap];
        [self addSubview:_backImageView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(self.backImageView.width/2 - 50, 45, 100, 30);
        _button.backgroundColor = [UIColor clearColor];
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = RGBColor(255, 255, 255).CGColor;
        _button.tag = 1000;
        [_backImageView addSubview:_button];
    }
    return _backImageView;
}
/**
 *  返回cell高度
 */
+ (CGFloat)callHight:(NSArray *)array{//《最多返回四行选项数据》
//    if (array.count <= 4 && array.count >0) {//少于4个的
//        return 200;
//    }else if(array.count > 4 && array.count <= 8){//大于四个的
//        return 245;
//    }else if(array.count > 8 && array.count <= 12){
//        return 290;
//    }else if (array.count == 0){
//        return 170;
//    }else{
//        return 335;
//    }
     return 140;
}

#pragma mark -- 
- (void)setModel:(FirstPageAttModel *)model{
    _model = model;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
//    self.array = _model.typelist;
//    self.attentionAry = [NSMutableArray array];
//    [self.attentionAry removeAllObjects];
//    for (NSDictionary * dict in _array) {
//        [_attentionAry addObject:dict[@"title"]];
//    }
//    
//    CGFloat Row = 0;
//    for (UIView * view in self.contentView.subviews) {
//        [view removeFromSuperview];
//    }
//    if (_attentionAry.count <= 4 && _attentionAry.count > 0) {
//    
//        for (int i = 0; i < _attentionAry.count; i++) {
//            UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
//            but.frame  =CGRectMake(20 + (kUIScreenWidth - 40)/(_attentionAry.count)*i, 135, (kUIScreenWidth - 40)/_attentionAry.count, 45);
//            [self.contentView addSubview:but];
//            if ((i + 1) % _attentionAry.count) {
//                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20 + (kUIScreenWidth - 40)/_attentionAry.count *((i + 1) % _attentionAry.count), 135, 1, 45)];
//                view.backgroundColor = RGBColor(234, 234, 234);
//                [self.contentView addSubview:view];
//            }
//            [but setTitle:_attentionAry[i] forState:UIControlStateNormal];
//            [but setTitleColor:RGBColor(107, 107, 107) forState:UIControlStateNormal];
//            but.titleLabel.font = [UIFont systemFontOfSize:13];
//            but.tag = 1000 + i;
//            [but addTarget:self action:@selector(whichAttentionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_button addTarget:self action:@selector(whichAttentionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_button setTitle:_model.title forState:UIControlStateNormal];
//            Row = i/4 + 1;
//        }
//    }else if(_attentionAry.count == 0){
//        [_button addTarget:self action:@selector(whichAttentionClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_button setTitle:_model.title forState:UIControlStateNormal];
//        
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kUIScreenWidth, 20)];
//        view.backgroundColor =RGBColor(234, 234, 234);
//        [self.contentView addSubview:view];
//    }else{
//        for (int i = 0; i < _attentionAry.count; i++) {
//            UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
//            but.frame  =CGRectMake(20 + (kUIScreenWidth - 40)/4* (i%4), 135 + i/4 * 45, (kUIScreenWidth - 40)/4, 45);
//            [but setTitle:_attentionAry[i] forState:UIControlStateNormal];
//            [but setTitleColor:RGBColor(107, 107, 107) forState:UIControlStateNormal];
//            but.titleLabel.font = [UIFont systemFontOfSize:13];
//            but.tag = 1000 + i;
//            [but addTarget:self action:@selector(whichAttentionClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [_button addTarget:self action:@selector(whichAttentionClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [_button setTitle:_model.title forState:UIControlStateNormal];
//            [self.contentView addSubview:but];
//            if ((i + 1)%4) {
//                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20 + (kUIScreenWidth - 40)/4 *((i + 1)%4), 135 + i/4 * 45, 1, 45)];
//                view.backgroundColor = RGBColor(234, 234, 234);
//                [self.contentView addSubview:view];
//            }
//            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20, 135 + i/4 * 45, kUIScreenWidth - 40, 1)];
//            view.backgroundColor = RGBColor(234, 234, 234);
//            [self.contentView addSubview:view];
//            
//            Row = i/4+1;
//        }
//        
//    }
//    if (Row == 0) {
//        Row = 1;
//    }
//    if (self.array.count != 0) {
//        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 135 + Row*45, kUIScreenWidth, 20)];
//        bottomView.backgroundColor = RGBColor(236, 236, 236);
//        [self.contentView addSubview:bottomView];
//    }
}

/**
 *  已经关注的市场关注的点击事件,跳转到相应的详细界面
 */
- (void)whichAttentionClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedDidAttention:which:)]) {
        [self.delegate clickedDidAttention:self.model.title which:sender.tag];
    }
}

- (void)whichAttentionClickedddd:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedDidAttention:which:)]) {
        [self.delegate clickedDidAttention:self.model.title which:1000];
    }
}

@end
