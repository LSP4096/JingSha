//
//  WantBuyTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/2.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "WantBuyTableViewCell.h"

@interface WantBuyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *introductLable;
@property (weak, nonatomic) IBOutlet UILabel *subtitle1;//规格
@property (weak, nonatomic) IBOutlet UILabel *subTitle2;//原料
@property (weak, nonatomic) IBOutlet UILabel *subContent1;
@property (weak, nonatomic) IBOutlet UILabel *subContent2;
@property (weak, nonatomic) IBOutlet UILabel *pricelable;
@property (weak, nonatomic) IBOutlet UILabel *baojiaLable;

@end

@implementation WantBuyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(RequestMsgModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    self.timeLable.text = _model.time;
    self.introductLable.text = _model.jianjie;

    if ([_model.type isEqualToString:@"2"]) {//纱线
//        self.subtitle1.text = @"规格:";
        if (_model.guige.length != 0) {
            self.subtitle1.text = @"规格:";
            self.subContent1.text = _model.guige;
        }
    }else{
        self.subtitle1.text = @"支数:";
        if (_model.zhisu.length != 0) {
            self.subContent1.text = _model.zhisu;
        }
        
//        self.subTitle2.text = @"原料:";
        if (_model.chengfen.length != 0) {
            self.subTitle2.text = @"原料:";
            self.subContent2.text = _model.chengfen;
        }
    }
    
    
    
    if (_model.baojia && [_model.baojia isEqualToString:@"1"]) {
        self.stateButton.hidden = NO;
        [self.stateButton setImage:[UIImage imageNamed:@"quote"] forState:UIControlStateNormal];
    }
    if (_model.baojia && [_model.baojia isEqualToString:@"0"]) {
        //m没有报价
        self.stateButton.hidden = YES;
    }

    
    
    if (_model.zhuangtai) {
//        [self.stateButton setImage:[UIImage imageNamed:@"quote"] forState:UIControlStateNormal];
        if ([_model.zhuangtai isEqualToString:@"1"]) {
            [self.stateButton setTitle:@"审核中" forState:UIControlStateNormal];
            [self.stateButton setTitleColor:RGBColor(253, 26, 42) forState:UIControlStateNormal];
        }else if ([_model.zhuangtai isEqualToString:@"2"]){
            [self.stateButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [self.stateButton setTitleColor:RGBColor(253, 26, 42) forState:UIControlStateNormal];
        }else if ([_model.zhuangtai isEqualToString:@"3"]){
            [self.stateButton setTitle:@"求购中" forState:UIControlStateNormal];
            [self.stateButton setTitleColor:RGBColor(254, 128, 8) forState:UIControlStateNormal];
        }else if ([_model.zhuangtai isEqualToString:@"4"]){
            [self.stateButton setTitle:@"完成" forState:UIControlStateNormal];
            [self.stateButton setTitleColor:RGBColor(55, 200, 195) forState:UIControlStateNormal];
        }else{
            
        }
    }
    if (_model.bao) {
        if ([_model.bao isEqualToString:@"1"]) {//我的报价 已达成
            [self.stateButton setImage:[UIImage imageNamed:@"reach"] forState:UIControlStateNormal];
        }else if ([_model.bao isEqualToString:@"0"]){//我的报价 已报价
            [self.stateButton setImage:[UIImage imageNamed:@"quote"] forState:UIControlStateNormal];
        }
    }
    self.pricelable.text = _model.jiage;
}


- (void)setMyBaojia:(BOOL)myBaojia{
    _myBaojia = myBaojia;
    if (!_myBaojia) {
        self.pricelable.hidden = YES;
        self.baojiaLable.hidden = YES;
    }
}

@end
