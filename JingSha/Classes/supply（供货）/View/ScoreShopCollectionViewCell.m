//
//  ScoreShopCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ScoreShopCollectionViewCell.h"

@interface ScoreShopCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *jifenLable;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLable;

@end
@implementation ScoreShopCollectionViewCell

- (void)awakeFromNib {
    
}
- (void)setModel:(ShopCenterModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    self.shengyuLable.text = [NSString stringWithFormat:@"剩余数量%@", _model.num];
    self.jifenLable.text = _model.jifen;
    if (![_model.photo isKindOfClass:[NSNull class]]) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    }
}

@end
