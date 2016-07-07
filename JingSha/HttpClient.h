//
//  HttpClient.h
//  JingSha
//
//  Created by 苹果电脑 on 6/16/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "NSString+Hash.h"

typedef void(^JSONResultBlock)(id resoutObj, NSError *error);

@interface HttpClient : AFHTTPSessionManager

+ (HttpClient *)sharedClient;
+ (NSDictionary *)jointParamsWithDict:(NSDictionary *)params;

- (NSURLSessionDataTask *)getWithRequestName:(NSString *)requestName
                                   RoutePath:(NSString *)path
                                      params:(NSDictionary *)params
                                       block:(JSONResultBlock)resultBlock;

- (NSURLSessionDataTask *)postWithRequestName:(NSString *)requestName
                                    RoutePath:(NSString *)path
                                       params:(NSDictionary *)params
                                        block:(JSONResultBlock)resultBlock;

- (NSURLSessionDataTask *)postUpLoadImageWithName:(NSString *)name
                                        RoutePath:(NSString *)path
                                           params:(NSDictionary *)params
                                            block:(JSONResultBlock)resoultBlock;


@end
