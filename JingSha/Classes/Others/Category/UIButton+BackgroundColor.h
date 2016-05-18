//
//  UIButton+BackgroundColor.h
//

#import <UIKit/UIKit.h>

@interface UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

- (void)setCornerBackgroundColor:(UIColor *)backgroundColor withRadius:(CGFloat)radius forState:(UIControlState)state;

@end
