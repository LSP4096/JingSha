//
//  CompanyCollectTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/1/12.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "CompanyCollectTableViewCell.h"

@interface CompanyCollectTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *zycpLable;
@end

@implementation CompanyCollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CompamyCollectModel *)model{
    _model = model;
    
     self.gongsiLable.text = _model.gongsi;
    self.zycpLable.text = _model.zycp;
    
    if (_model.logo == nil || [_model.logo isKindOfClass:[NSNull class]]) {
        self.logoImageView.image = [UIImage imageNamed:@"NetBusy"];
    }else{
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:_model.logo] placeholderImage:nil completed:nil];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
