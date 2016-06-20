//
//  HttpClient+FirstPage.m
//  JingSha
//
//  Created by 苹果电脑 on 6/17/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient+FirstPage.h"

@implementation HttpClient (FirstPage)

- (NSURLSessionDataTask *)getFirstPageInfoComplecion:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:KUserImfor[@"userid"] forKey:@"userid"];
    
    // 拼接sign参数
    NSDictionary *allParams = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self getWithRequestName:@"首页信息" RoutePath:@"pro/home_list2" params:allParams block:complection];
    return task;
}

@end
