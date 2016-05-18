//
//  MyRequestModel.m
//  JingSha
//
//  Created by 周智勇 on 15/12/31.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MyRequestModel.h"

@implementation MyRequestModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"Id" : @"id"};//@return 字典中的key是属性名，value是从字典中取值用的key
}
@end
