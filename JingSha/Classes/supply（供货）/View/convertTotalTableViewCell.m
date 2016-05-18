//
//  convertTotalTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "convertTotalTableViewCell.h"

@interface convertTotalTableViewCell ()


@end

@implementation convertTotalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(DuiHUanHistoryModel *)model{
    _model = model;
    self.leftLable.text = @"兑换时间";
    self.rightLable.text = _model.time;
}

-(void)setModel2:(DuiHUanHistoryModel *)model2{
    _model2 = model2;
    self.leftLable.text = @"兑换状态";
    if ([_model2.audit isEqualToString:@"0"]) {
        self.rightLable.text = @"兑换失败";
    }else{
        self.rightLable.text = @"兑换成功";
    }
}



@end
