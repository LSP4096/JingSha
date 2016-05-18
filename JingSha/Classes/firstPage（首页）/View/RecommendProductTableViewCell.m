//
//  RecommendProductTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/9.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RecommendProductTableViewCell.h"

@interface RecommendProductTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *chengfenLable;
@property (weak, nonatomic) IBOutlet UILabel *zcdLable;
@property (weak, nonatomic) IBOutlet UILabel *zhisuLable;
@property (weak, nonatomic) IBOutlet UILabel *jiageLable;
@end

@implementation RecommendProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(ProOptionModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    self.gongsiLable.text = _model.gongsi;
    self.chengfenLable.text = _model.chengfen;
    self.zcdLable.text = _model.zcd;
    self.zhisuLable.text = _model.zhisu;
    self.jiageLable.text = _model.jiage;
}



@end
