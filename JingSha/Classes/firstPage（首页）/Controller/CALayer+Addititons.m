//
//  CALayer+Addititons.m
//  JingSha
//
//  Created by 周智勇 on 15/12/4.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CALayer+Addititons.h"

@implementation CALayer (Addititons)
//为了兼容CALayer 的KVC ，你得给CALayer增加一个分类
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
