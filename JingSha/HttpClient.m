//
//  HttpClient.m
//  JingSha
//
//  Created by 苹果电脑 on 6/16/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient.h"
#import "HttpResponse.h"

typedef void(^afSuccessBlock)(NSURLSessionDataTask *task, id responseObj);
typedef void(^afFailBlock)(NSURLSessionDataTask *task, NSError *error);

@implementation HttpClient

+ (HttpClient *)sharedClient {
    static HttpClient *sheardClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        
        sheardClient = [[HttpClient alloc]initWithBaseURL:[NSURL URLWithString:kBaseURL] sessionConfiguration:config];
        sheardClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", @"text/json", @"text/javascript", nil];
    });
    return sheardClient;
}

- (NSURLSessionDataTask *)getWithRequestName:(NSString *)requestName
                                   RoutePath:(NSString *)path
                                      params:(NSDictionary *)params
                                       block:(JSONResultBlock)resultBlock {
    
    return [self sessionDataTaskWithRequestName:requestName RoutePath:path HttpMethod:@"get" params:params block:resultBlock];
}

- (NSURLSessionDataTask *)postWithRequestName:(NSString *)requestName RoutePath:(NSString *)path
                                       params:(NSDictionary *)params
                                        block:(JSONResultBlock)resultBlock {
    
    return [self sessionDataTaskWithRequestName:requestName RoutePath:path HttpMethod:@"post" params:params block:resultBlock];
}


- (NSURLSessionDataTask *)sessionDataTaskWithRequestName:(NSString *)requestName
                                               RoutePath:(NSString *)path
                                              HttpMethod:(NSString *)httpMethod
                                                  params:(NSDictionary *)params
                                                   block:(JSONResultBlock)resultBlock {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableString *requestDescripString = [NSMutableString stringWithFormat:@""];
    [requestDescripString appendString:@"\n========================Request Info==========================\n"];
    [requestDescripString appendFormat:@"request Name:%@\n",requestName];
    [requestDescripString appendFormat:@"request Url:%@%@\n",kBaseURL,path];
    [requestDescripString appendFormat:@"request Method:%@\n",httpMethod];
    [requestDescripString appendFormat:@"request Params:%@\n",params];
    [requestDescripString appendString:@"\n==============================================================\n"];
    NSLog(@"%@",requestDescripString);
    
    /**
     *  用断言进行安全检查
     */
    NSParameterAssert(path);
    NSParameterAssert(httpMethod);
    
    //请求成功的回调
    afSuccessBlock successBlock = ^(NSURLSessionDataTask *task, id responseObj){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        resultBlock(responseObj, nil);
    };
    
    //请求失败的回调
    afFailBlock failBlock = ^(NSURLSessionDataTask *task, NSError *error){
        if(resultBlock) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD showError:@"网络不给力"];
            resultBlock(nil, error);
        }
    };
    
    if ([httpMethod isEqualToString:@"get"]) {
        return [self GET:path parameters:params success:successBlock failure:failBlock];
    } else if ([httpMethod isEqualToString:@"post"]) {
        return [self POST:path parameters:params success:successBlock failure:failBlock];
    } else if ([httpMethod isEqualToString:@"put"]) {
        return [self PUT:path parameters:params success:successBlock failure:failBlock];
    } else if ([httpMethod isEqualToString:@"delete"]){
        return [self DELETE:path parameters:params success:successBlock failure:failBlock];
    } else {
//        [self POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            for (int index=0; index<imageList.count; index++) {
//                UIImage * image=[imageList objectAtIndex:index];
//                NSData * imageData=UIImageJPEGRepresentation(image, 0.8);
//                NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index];
//                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/file"];
//            }
//        } success:successBlock failure:failBlock];
        return nil;
    }
    
}

+ (NSDictionary *)jointParamsWithDict:(NSDictionary *)params
{
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    // 拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    NSDate *actionTime =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString *formatterTime = [dateFormatter stringFromDate:actionTime];
    NSString *userString = @"bocweb";
    NSString *signSting = [NSString stringWithFormat:@"%@%@",formatterTime,userString];
    NSString *md5SignString = [signSting md5String];
    
    // 拼接sign参数
    [allParams setObject:md5SignString forKey:@"sign"];
    [allParams setObject:formatterTime forKey:@"timeline"];
    
    return allParams;
}


@end
