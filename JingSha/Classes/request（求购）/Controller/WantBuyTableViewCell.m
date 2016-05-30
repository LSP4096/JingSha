//
//  WantBuyTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/2.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "WantBuyTableViewCell.h"

@interface WantBuyTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subtitle1;//规格
@property (weak, nonatomic) IBOutlet UILabel *subTitle2;//原料
@property (weak, nonatomic) IBOutlet UILabel *subContent1;
@property (weak, nonatomic) IBOutlet UILabel *subContent2;

@property (weak, nonatomic) IBOutlet UILabel *subTitle3; // 大类
@property (weak, nonatomic) IBOutlet UILabel *subContent3;
@property (weak, nonatomic) IBOutlet UILabel *quotes; //报价人数

@end

@implementation WantBuyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(RequestMsgModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    self.timeLable.text = _model.time;

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
}

@end
