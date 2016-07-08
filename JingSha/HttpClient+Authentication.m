//
//  HttpClient+Authentication.m
//  JingSha
//
//  Created by 苹果电脑 on 6/20/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient+Authentication.h"

@implementation HttpClient (Authentication)

- (NSURLSessionDataTask *)LoginWithAccount:(NSString *)account
                Password:(NSString *)password
             Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:account forKey:@"tel"];
    [params setObject:password forKey:@"password"];
    
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self postWithRequestName:@"用户登录" RoutePath:@"userinfo/login" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)LogOutWithComplection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:KUserImfor[@"userid"] forKey:@"userid"];
    
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self postWithRequestName:@"用户登出" RoutePath:@"userinfo/loginout" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)SendCodeWithPhoneNumber:(NSString *)number
                                      Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:number forKey:@"tel"];
    [params setObject:@"1" forKey:@"type"];
    
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self postWithRequestName:@"获取验证码" RoutePath:@"userinfo/createcode" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)registersWithAccountName:(NSString *)accountName
                                          Password:(NSString *)password
                                          UserName:(NSString *)name
                                              Code:(NSString *)code
                                       Complection:(JSONResultBlock )complection {

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:accountName forKey:@"tel"];
    [params setObject:password forKey:@"password"];
    [params setObject:name forKey:@"username"];
    [params setObject:code forKey:@"code"];
    
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self postWithRequestName:@"用户注册" RoutePath:@"userinfo/reg" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)ResetPasswordCodeWithPhoneNumber:(NSString *)number
                                               Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:number forKey:@"tel"];
    [params setObject:@"2" forKey:@"type"];
    
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self postWithRequestName:@"获取验证码" RoutePath:@"userinfo/createcode" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)ResetPasswordWithPhoneNumber:(NSString *)number
                                              Password:(NSString *)password
                                                  Code:(NSString *)code
                                           Complection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:number forKey:@"tel"];
    [params setObject:password forKey:@"password"];
    [params setObject:code forKey:@"code"];
    
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    
    NSURLSessionDataTask *task = [self postWithRequestName:@"重置密码" RoutePath:@"userinfo/forgetpwd" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)postUserinfoComplection:(JSONResultBlock)complection {
    
    NSMutableDictionary *params = @{@"userid":KUserImfor[@"userid"]}.mutableCopy;
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    NSURLSessionDataTask *task = [self postWithRequestName:@"获得用户信息" RoutePath:@"userinfo/userinfo_post" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)postUpLoadImageForUserinfoWithImagePathList:(NSArray *)imageList
                                                       block:(JSONResultBlock)resoultBlock {

    NSMutableDictionary *params = @{@"userid":[SingleTon shareSingleTon].userInformation[@"userid"]}.mutableCopy;

    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
  
    NSURLSessionDataTask *task = [self postUpLoadImageWithName:@"photo" RoutePath:@"userinfo/userinfoedit" imagePathList:imageList params:paramAll block:resoultBlock];
    return task;
}

- (NSURLSessionDataTask *)postSignComplection:(JSONResultBlock)complection {

    NSMutableDictionary *params = @{@"userid":KUserImfor[@"userid"]}.mutableCopy;
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    NSURLSessionDataTask *task = [self postWithRequestName:@"签到" RoutePath:@"userinfo/qiandao" params:paramAll block:complection];
    return task;
}

- (NSURLSessionDataTask *)postUpdataWithImagePathList:(NSArray *)imageList Name:(NSString *)name Sex:(NSString *)sex Compony:(NSString *)compony addr:(NSString *)addr Block:(JSONResultBlock)complection{
    
    NSMutableDictionary *params = @{@"userid":KUserImfor[@"userid"],
                                    @"passWord":[SingleTon shareSingleTon].userPassWoed,
                                    @"username":name,
                                    @"sex":sex,
                                    @"gongsi":compony,
                                    @"addr":addr
                                    }.mutableCopy;
    
    NSDictionary *paramAll = [HttpClient jointParamsWithDict:params];
    NSURLSessionDataTask *task = [self postUpLoadImageWithName:@"photo" RoutePath:@"userinfo/userinfoedit" imagePathList:imageList params:paramAll block:complection];
    return task;
}


@end
