//
//  AppDelegate+IQKeyBoard.m
//  JingSha
//
//  Created by 苹果电脑 on 5/18/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "AppDelegate+IQKeyBoard.h"

@implementation AppDelegate (IQKeyBoard)

- (void)configureKeyBoard {
    //键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

@end
