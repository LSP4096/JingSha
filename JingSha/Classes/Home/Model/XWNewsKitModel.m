//
//  XWNewsKitModel.m
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "XWNewsKitModel.h"

@implementation XWNewsKitModel


- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.kitType = dic[@"type"];
        self.newslistArr = dic[@"newslist"];
    }
    return self;
}
+ (id)xwNewsKitModelWithDictionary:(NSDictionary *)dic {
    return [[XWNewsKitModel alloc] initWithDictionary:dic];
}


@end
