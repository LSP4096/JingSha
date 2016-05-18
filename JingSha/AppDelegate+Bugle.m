//
//  AppDelegate+Bugle.m
//  JingSha
//
//  Created by 苹果电脑 on 5/18/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "AppDelegate+Bugle.h"
#import <Bugly/CrashReporter.h>

@implementation AppDelegate (Bugle)

- (void)configureBugle {
    
    [[CrashReporter sharedInstance] enableLog:YES];
    [[CrashReporter sharedInstance] installWithAppId:@"900018522"];
}

@end
