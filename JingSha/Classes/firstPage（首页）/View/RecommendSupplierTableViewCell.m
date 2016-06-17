//
//  RecommendSupplierTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/7.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RecommendSupplierTableViewCell.h"

@interface RecommendSupplierTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *zycpLable;
@property (weak, nonatomic) IBOutlet UILabel *zcdLable;
@property (weak, nonatomic) IBOutlet UILabel *numLable;

@property (weak, nonatomic) IBOutlet UIView *cntView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numW;

@end

@implementation RecommendSupplierTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cntView.layer.cornerRadius = 5;
    self.cntView.layer.borderWidth = 0.001;
    self.cntView.layer.masksToBounds = YES;
}

- (void)setModel:(CompanyListModel *)model{
    _model = model;
    
    CGSize size = [_model.num sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _numW.constant = size1.width;
    
    self.gongsiLable.text = _model.gongsi;
    self.zycpLable.text = [NSString stringWithFormat:@"%@", _model.zycp];
    self.zcdLable.text = _model.zcd;
    self.numLable.text = _model.num;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.logo] placeholderImage:img(@"NetBusy")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
