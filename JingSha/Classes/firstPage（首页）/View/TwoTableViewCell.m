//
//  TwoTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "TwoTableViewCell.h"

@interface TwoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;


@end

@implementation TwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ConpanyMessageModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    if (![_model.contentStr isKindOfClass:[NSNull class]]) {
        self.contentLable.text = _model.contentStr;
    }
}


+ (CGFloat)callHight:(NSString *)contentString{
    CGRect rect = [contentString boundingRectWithSize: CGSizeMake(kUIScreenWidth - 115, 0)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height;
}
@end
