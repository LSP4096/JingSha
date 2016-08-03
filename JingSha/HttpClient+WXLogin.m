//
//  HttpClient+WXLogin.m
//  JingSha
//
//  Created by 苹果电脑 on 6/28/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient+WXLogin.h"

@implementation HttpClient (WXLogin)

- (NSURLSessionDataTask *)getAccessTokenWithCode:(NSString *)code Complection:(JSONResultBlock)complection {
    NSMutableDictionary * params = @{@"appid":kWXAppId, @"secret":kWXAppSecret, @"code":code, @"grant_type":@"authorization_code"}.mutableCopy;
    NSDictionary *allParams = [HttpClient jointParamsWithDict:params];
    NSURLSessionDataTask *task =  [self getWithRequestName:@"获取微信accessToken" RoutePath:@"https://api.weixin.qq.com/sns/oauth2/access_token" params:allParams block:complection];
    return task;
}

- (NSURLSessionDataTask *)getWeChatUserInfoWithOpenId:(NSString *)openId AccessToken:(NSString *)accesstoken Complection:(JSONResultBlock)complection {
    NSMutableDictionary *params = @{@"openid":openId ,@"access_token":accesstoken}.mutableCopy;
    NSDictionary *allParams = [HttpClient jointParamsWithDict:params];
    NSURLSessionDataTask *task = [self postWithRequestName:@"用户微信登录" RoutePath:@"https://api.weixin.qq.com/sns/userinfo?" params:allParams block:complection];
    return task;
}

- (NSURLSessionDataTask *)getUserIdWithOpenId:(NSString *)openid
                                  Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = nil;
    if (openid) {
        params = @{@"openid":openid }.mutableCopy;
    }
    NSDictionary *allParams = [HttpClient jointParamsWithDict:params];
    NSURLSessionDataTask *task = [self postWithRequestName:@"获取用户ID" RoutePath:@"login/getweixin" params:allParams block:complection];
    return task;
}

@end
