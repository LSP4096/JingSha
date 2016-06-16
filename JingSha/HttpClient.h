//
//  HttpClient.h
//  JingSha
//
//  Created by 苹果电脑 on 6/16/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^JSONResultBlock)(id resoutObj, NSError *error);

@interface HttpClient : AFHTTPSessionManager

- (HttpClient *)sharedClient;

- (NSURLSessionDataTask *)getWithRequestName;

@end
