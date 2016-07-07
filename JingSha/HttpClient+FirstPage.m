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

- (NSURLSessionDataTask *)getNewsListWithPage:(NSInteger)page
                                    PageCount:(NSInteger)pagecount
                                  Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = @{@"userid":KUserImfor[@"userid"], @"page":@(page), @"pagecount":@(pagecount)}.mutableCopy;
    NSDictionary *allParams = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self postWithRequestName:@"消息列表" RoutePath:@"userinfo/my_email_list" params:allParams block:complection];
    return task;
    
}

- (NSURLSessionDataTask *)getExchangesCenterWithPage:(NSInteger)page
                                           PageCount:(NSInteger)pagecount
                                                Type:(NSInteger)type
                                             KeyWord:(NSString *)keyword
                                         Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = @{@"userid":KUserImfor[@"userid"], @"page":@(page), @"pagecount":@(pagecount), @"type":@(2)}.mutableCopy;
    if (keyword) {
        [params setObject:keyword forKey:@"keyword"];
    }
    NSDictionary *allParams = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self getWithRequestName:@"交易中心" RoutePath:@"pro/pro_list" params:allParams block:complection];
    return task;
}

- (NSURLSessionDataTask *)getLasterRequestWithPage:(NSInteger)page
                                             Count:(NSInteger)count
                                           KeyWord:(NSString *)keyword
                                       Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = @{@"userid":KUserImfor[@"userid"], @"page":@(page), @"pagecount":@(count)}.mutableCopy;
    if (keyword) {
        [params setObject:keyword forKey:@"keyword"];
    }
    NSDictionary *allParams = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self getWithRequestName:@"最新求购" RoutePath:@"pro/buy_list" params:allParams block:complection];
    return task;
}

@end
