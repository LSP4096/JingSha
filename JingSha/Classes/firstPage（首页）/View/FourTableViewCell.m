//
//  FourTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "FourTableViewCell.h"
@interface FourTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@end
@implementation FourTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentLable.verticalAlignment = VerticalAlignmentTop;
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = RGBColor(200, 200, 200).CGColor;
}

+ (CGFloat)callHight:(NSString *)contentString{
    CGRect rect = [contentString boundingRectWithSize: CGSizeMake(kUIScreenWidth - 40, 0)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
    
    return rect.size.height + 50;
}
@end
