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
    
    return [self sessionDataTaskWithRequestName:requestName
                                      RoutePath:path
                                     HttpMethod:@"get"
                                         params:params
                                          block:resultBlock];
}

- (NSURLSessionDataTask *)postWithRequestName:(NSString *)requestName
                                    RoutePath:(NSString *)path
                                       params:(NSDictionary *)params
                                        block:(JSONResultBlock)resultBlock {
    return [self sessionDataTaskWithRequestName:requestName
                                      RoutePath:path
                                     HttpMethod:@"post"
                                         params:params
                                          block:resultBlock];
}

- (NSURLSessionDataTask *)sessionDataTaskWithRequestName:(NSString *)requestName
                                               RoutePath:(NSString *)path
                                              HttpMethod:(NSString *)httpMethod
                                                  params:(NSDictionary *)params
                                                   block:(JSONResultBlock)resultBlock {
    /**
     *  请求信息打印输出
     */
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
    
    //数据返回为数组形式！！
//    void (^parseArrayBlock)(NSArray *dicArr, JSONResultBlock resultBlock) = ^void(NSArray *dicArr,JSONResultBlock resultBlock){
//        
//        NSMutableArray *muArr = [NSMutableArray new];
//        if (modelClass) {
//            __block NSError *error = nil;
//            //遍历数组（面对大量的数组推荐使用——下面方式），小量用(for in)
//            [muArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                id model = [[modelClass alloc] initWithDictionary:obj error:&error];
//                if (model) {
//                    [muArr addObject:model];
//                }
//                else if (error) {
//                    *stop =  YES;
//                }
//            }];
//            if (resultBlock) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (error) {
//                        NSLog(@"[%@]parse error:%@", path, error.userInfo.debugDescription);
//                        resultBlock(nil, error);
//                    } else {
//                        resultBlock(muArr, nil);
//                    }
//                });
//            }
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                resultBlock(dicArr, nil);
//            });
//        }
//    };
    
    //数据返回为字典形式
//    void (^parseDicBlock)(NSDictionary *dic, JSONResultBlock resultBloack) = ^void(NSDictionary *dic, JSONResultBlock resultBloack){
//        
//        NSError *error = nil;
//        
//        if (modelClass) {
//            id model = [[modelClass alloc]initWithDictionary:dic error:&error];
//            if (model) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (resultBlock) {
//                        resultBlock(model, nil);
//                    }
//                });
//            } else if(error) {
//                NSLog(@"[%@]parse error:%@", path, error.userInfo.debugDescription);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (resultBlock) {
//                        resultBlock(nil,error);
//                    }
//                });
//            }
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                resultBlock(dic, nil);
//            });
//        }
//    };
    
    //请求成功的回调
    afSuccessBlock successBlock = ^(NSURLSessionDataTask *task, id responseObj){
        
//        NSError *error = nil;
//        HttpResponse *response = [[HttpResponse alloc] initWithDictionary:responseObj error:&error];
        
//        NSMutableString *ResponseDescripString = [NSMutableString stringWithFormat:@""];
//        [ResponseDescripString appendString:@"\n========================Response Info===========================\n"];
//        [ResponseDescripString appendFormat:@"响应名字:%@\n",requestName];
//        [ResponseDescripString appendFormat:@"Response count:%@\n",response.msg];
//        [ResponseDescripString appendFormat:@"Response start:%@\n",response.return_code];
////        [ResponseDescripString appendFormat:@"响应的解析内容:\n%@\n",response.data];
//        [ResponseDescripString appendFormat:@"响应的原始内容:\n%@\n",responseObj];
//        [ResponseDescripString appendString:@"===============================================================\n"];
//        NSLog(@"%@",ResponseDescripString);
        
//        if (error) {
//            NSLog(@"[%@]parse error:%@", path, error.userInfo.debugDescription);
//            if (resultBlock) {
//                resultBlock(nil, error);
//            }
//            return;
//        }
        resultBlock(responseObj, nil);
//        if  (response.return_code.integerValue == 0 && response.data) {
//            id data = response.data;
//            // 是否是array
//            if ([data isKindOfClass:[NSArray class]]) {
//                parseArrayBlock(data, resultBlock);
//            } else if ([data isKindOfClass:[NSDictionary class]]) {
//                parseDicBlock(data, resultBlock);
//            } else {
//                parseDicBlock(data, nil);
//            }
//        } else {
//            if (response.return_code.integerValue == 1) {
//                
//                NSError *error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:-1000 userInfo:@{@"errorMsg":response.msg}];
//                if (resultBlock) {
//                    resultBlock(nil, error);
//                }
//                return;
//            } else {
//                resultBlock(responseObj, nil);
//            }
//        }
        
    };
    
    //请求失败的回调
    afFailBlock failBlock = ^(NSURLSessionDataTask *task, NSError *error){
        if(resultBlock) {
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
