//
//  NSString+Helper.m
//  ARErp
//
//  Created by ZRAR on 14/11/6.
//  Copyright (c) 2014年 ZRAR. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 是否空字符串
- (BOOL)isEmptyString
{
    return (self.length == 0);
}

@end
