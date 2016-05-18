//
//  SingleTon.m
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "SingleTon.h"

@implementation SingleTon

+ (SingleTon *)shareSingleTon {
    static SingleTon *ton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ton = [[SingleTon alloc] init];
    });
    return ton;
}

- (NSMutableDictionary *)mDic {
    if (_mDic == nil) {
        self.mDic = [NSMutableDictionary dictionary];
    }
    return _mDic;
}

@end
