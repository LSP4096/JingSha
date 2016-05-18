//
//  convertHistoryCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "convertHistoryCell.h"

@interface convertHistoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *fenzhiLable;
@property (weak, nonatomic) IBOutlet UILabel *zhuangTaiLable;

@end
@implementation convertHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DuiHUanHistoryModel *)model{
    _model = model;
    self.fenzhiLable.text = _model.jifen;
    if ([_model.audit isEqualToString:@"1"]) {
        self.zhuangTaiLable.text = @"兑换成功";
    }else{
        self.zhuangTaiLable.text = @"兑换失败";
    }
//    self.zhuangTaiLable.text = _model.audit;//1 成功 0 未成功
    self.titleLable.text = _model.title;
    if (![_model.photo isKindOfClass:[NSNull class]]) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    }
}

@end
