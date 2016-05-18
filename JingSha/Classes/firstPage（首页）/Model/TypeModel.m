//
//  TypeModel.m
//  JingSha
//
//  Created by 周智勇 on 16/1/10.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "TypeModel.h"

@implementation TypeModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"typeItems":[TypeModel class]};
}

@end
