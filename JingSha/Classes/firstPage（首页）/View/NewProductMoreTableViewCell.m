//
//  NewProductMoreTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/9.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "NewProductMoreTableViewCell.h"

@interface NewProductMoreTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *chengfenLable;
@property (weak, nonatomic) IBOutlet UILabel *jiageLable;

@property (weak, nonatomic) IBOutlet UILabel *pruductPlace;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@end

@implementation NewProductMoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.messageBtn.layer.cornerRadius = 5;
    self.messageBtn.layer.borderWidth = 0.01;
    self.messageBtn.layer.masksToBounds = YES;
}

- (void)setModel:(ProOptionModel *)model{//这里返回的值全部都是有值的或者@“”的。没有<NULL>
    _model = model;
    self.jiageLable.text = str(@"%@/吨",_model.jiage);
    self.titleLable.text = _model.title;
    self.chengfenLable.text = _model.chengfen;
    
    self.pruductPlace.text = _model.zcd;
    self.time.text = _model.time;
}

- (IBAction)messageBtnClick:(id)sender {
    MyLog(@"liuyan");
}


@end
