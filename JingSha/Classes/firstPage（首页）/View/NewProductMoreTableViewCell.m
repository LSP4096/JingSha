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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleW;
@property (weak, nonatomic) IBOutlet UILabel *zhisu;
@property (weak, nonatomic) IBOutlet UILabel *jiageLable;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *supper;
@property (weak, nonatomic) IBOutlet UIView *cntView;
@property (nonatomic, strong) NSString *id;

@end

@implementation NewProductMoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cntView.layer.cornerRadius = 5;
    self.cntView.layer.borderWidth = 0.001;
    self.cntView.layer.masksToBounds = YES;
    
//    self.messageBtn.layer.cornerRadius = 12;
//    self.messageBtn.layer.borderWidth = 0.01;
//    self.messageBtn.layer.masksToBounds = YES;
}

- (void)setModel:(ProOptionModel *)model{//这里返回的值全部都是有值的或者@“”的。没有<NULL>
    _model = model;
    self.titleLable.text = _model.title;
    CGSize size = [_model.title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    if (size1.width > kUIScreenWidth / 3) {
        size1.width = kUIScreenWidth / 3;
    }
    _titleW.constant = size1.width;
    
    self.zhisu.text = _model.zhisu;
    self.jiageLable.text = str(@"%@ 元/吨",_model.jiage);
    self.supper.text = _model.gongsi;
    self.time.text = _model.time;
    self.id = _model.Id;
}

- (IBAction)messageBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil userInfo:@{@"id":self.id}];
}

/*
 @property (nonatomic, copy)NSString * chengfen;
 @property (nonatomic, copy)NSString * gongsi;
 @property (nonatomic, copy)NSString * guige;
 @property (nonatomic, copy)NSString * Id;
 @property (nonatomic, copy)NSString * jiage;
 @property (nonatomic, copy)NSString * photo;
 @property (nonatomic, copy)NSString * time;
 @property (nonatomic, copy)NSString * title;
 @property (nonatomic, copy)NSString * type;
 @property (nonatomic, copy)NSString * zcd;
 @property (nonatomic, copy)NSString * zhisu;
 @property (nonatomic, copy)NSString * sid;
 */

@end
