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

@end

@implementation RecommendSupplierTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CompanyListModel *)model{
    _model = model;
    self.gongsiLable.text = _model.gongsi;
    self.zycpLable.text = [NSString stringWithFormat:@"主营产品:%@", _model.zycp];
    self.zcdLable.text = _model.zcd;
    self.numLable.text = _model.num;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
