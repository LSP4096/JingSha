//
//  SCLAlertView+FRAlertView.m
//  FryRice
//
//  Created by hasayakey on 11/17/15.
//  Copyright © 2015 Wiseyep Technology. All rights reserved.
//

#import "SCLAlertView+FRAlertView.h"

static SCLAlertView *sharedInstance = nil;

@implementation SCLAlertView (FRAlertView)

+ (instancetype)sharedInstance {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.shouldDismissOnTapOutside = YES;
    alert.hideAnimationType = SlideOutToBottom;
    alert.showAnimationType = SlideInFromTop;
    alert.backgroundType = Shadow;
    alert.statusBarHidden = NO;
    alert.statusBarStyle = UIStatusBarStyleLightContent;
    return alert;
}

+ (instancetype)customTypeInstance {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.hideAnimationType = SlideOutToBottom;
    alert.showAnimationType = SlideInFromTop;
    alert.backgroundType = Shadow;
    alert.statusBarHidden = YES;
    return alert;
}

+ (instancetype)sharedInstanceShowStatusBar {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.shouldDismissOnTapOutside = YES;
    alert.hideAnimationType = SlideOutToLeft;
    alert.showAnimationType = SlideInFromTop;
    alert.backgroundType = Shadow;
    alert.statusBarHidden = NO;
    return alert;
}

@end
