//
//  SearchModel.m
//  JingSha
//
//  Created by BOC on 15/11/7.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "SearchModel.h"

@interface SearchModel ()

@end


@implementation SearchModel
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
//        [self setValuesForKeysWithDictionary:dic];
        self.click = [NSString stringWithFormat:@"%@", dic[@"click"]];
        self.newsid = [NSString stringWithFormat:@"%@", dic[@"newsid"]];
        self.title = dic[@"title"];
        self.time = dic[@"time"];
    }
    return self;
}
+ (id)searchModelWithDictionary:(NSDictionary *)dic {
    return [[SearchModel alloc] initWithDictionary:dic];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
