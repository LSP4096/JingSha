//
//  WantBuyTableViewCell.m
//  JingSha
//
//  Created by 苹果电脑 on 6/3/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "WantBuyTableViewCell.h"
@interface WantBuyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *cntView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *quotes;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIButton *BaoJia;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (nonatomic, strong) NSString *id;

@end

@implementation WantBuyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cntView.layer.cornerRadius = 5;
    self.cntView.layer.borderWidth = 0.001;
    self.cntView.layer.masksToBounds = YES;
    
    self.titleImg.layer.cornerRadius = 12;
    self.titleImg.layer.borderWidth = 0.001;
    self.titleImg.layer.masksToBounds = YES;
    
    self.BaoJia.layer.cornerRadius = 13;
    self.BaoJia.layer.borderWidth = 0.001;
    self.BaoJia.layer.masksToBounds = YES;
}

- (void)setModel:(RequestMsgModel *)model{
    _model = model;
    self.title.text = _model.title;
    self.time.text = _model.time;
    
    if ([_model.baojia isEqualToString:@"1"]) {
        self.quotes.text = @"已有人报价";
    }else {
        self.quotes.text = @"暂无报价信息";
    }
    
    if (IsStringEmpty(model.num)) {
        self.num.text = @"电议";
    } else {
        self.num.text = model.num;
    }

    self.place.text = @"暂无";
    self.id = model.Id;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBaoJiaBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaoJia" object:nil userInfo:@{@"id":self.id}];
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
 
 @property (nonatomic, copy)NSString * num;
 //我的报价
 @property (nonatomic, copy)NSString * bao;//我的报价的状态
 @property (nonatomic, copy)NSString * bid;//我的报价的求购的id
 */