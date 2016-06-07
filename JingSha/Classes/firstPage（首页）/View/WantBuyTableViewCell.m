//
//  WantBuyTableViewCell.m
//  JingSha
//
//  Created by 苹果电脑 on 6/3/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "WantBuyTableViewCell.h"
@interface WantBuyTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *daCail;
@property (weak, nonatomic) IBOutlet UILabel *resouce;
@property (weak, nonatomic) IBOutlet UILabel *zhisu;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *quotes;

@end

@implementation WantBuyTableViewCell

- (void)awakeFromNib {
    // Initialization code
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
    self.daCail.text = @"大类:暂无";
    self.resouce.text = str(@"原料:%@",_model.chengfen);
    self.zhisu.text = str(@"支数:%@",_model.zhisu);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
