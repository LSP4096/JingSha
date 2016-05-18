//
//  SuperMarketCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SuperMarketCollectionViewCell.h"
//#import "JHTickerView.h"

@interface SuperMarketCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *guigeLable;
@property (weak, nonatomic) IBOutlet UILabel *jiageLable;

@end

@implementation SuperMarketCollectionViewCell

- (void)awakeFromNib {

}

- (void)setModel:(SuppleMsgModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    self.gongsiLable.text = _model.gongsi;
    self.guigeLable.text = _model.guige;
    self.jiageLable.text = [NSString stringWithFormat:@"￥%@",_model.jiage];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
}

@end
