//
//  SPExchangeCenterCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SPExchangeCenterCell.h"
@interface SPExchangeCenterCell ()

@end

@implementation SPExchangeCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    [self.delegate exchangeMoreBtnClick];
}

@end
