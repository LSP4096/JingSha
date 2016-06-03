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
@property (weak, nonatomic) IBOutlet UILabel *class;
@property (weak, nonatomic) IBOutlet UILabel *resouce;
@property (weak, nonatomic) IBOutlet UILabel *zhisu;
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
    
        if (_model.baojia ) {
            self.quotes.text = @"已有人报价";
        }else {
            self.quotes.text = @"暂无报价信息";
        }
        self.class.text = @"大类:暂无";
        self.resouce.text = str(@"原料:%@",_model.chengfen);
        self.zhisu.text = str(@"支数:%@",_model.zhisu);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

/*
 @property (nonatomic, copy)NSString * jiage;
 @property (nonatomic, copy)NSString * Id;
 @property (nonatomic, copy)NSString * title;
 @property (nonatomic, copy)NSString * jianjie;
 @property (nonatomic, copy)NSString * time;
 @property (nonatomic, copy)NSString * zhisu;
 @property (nonatomic, copy)NSString * chengfen;
 @property (nonatomic, copy)NSString * guige;
 @property (nonatomic, copy)NSString * type;
 @property (nonatomic, copy)NSString * baojia;//是否有人报价
 @property (nonatomic, copy)NSString * zhuangtai;//1审核中2拒绝3同意/求购中4完成
 @property (nonatomic, copy)NSString * Type;//1纱线 2化纤  我的求购
 */