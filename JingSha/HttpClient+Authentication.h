//
//  HttpClient+Authentication.h
//  JingSha
//
//  Created by 苹果电脑 on 6/20/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient.h"

@interface HttpClient (Authentication)

//登录接口
- (NSURLSessionDataTask *)LoginWithAccount:(NSString *)account Password:(NSString *)password Complection:(JSONResultBlock)complection;
//登出接口
- (NSURLSessionDataTask *)LogOutWithComplection:(JSONResultBlock)complection;
//获取注册的验证码
- (NSURLSessionDataTask *)SendCodeWithPhoneNumber:(NSString *)number Complection:(JSONResultBlock)complection;
// 用户注册
- (NSURLSessionDataTask *)registersWithAccountName:(NSString *)accountName Password:(NSString *)password UserName:(NSString *)name Code:(NSString *)code Complection:(JSONResultBlock )complection;
//获取重置密码的验证码
- (NSURLSessionDataTask *)ResetPasswordCodeWithPhoneNumber:(NSString *)number Complection:(JSONResultBlock)complection;
//重置密码
- (NSURLSessionDataTask *)ResetPasswordWithPhoneNumber:(NSString *)number Password:(NSString *)password Code:(NSString *)code Complection:(JSONResultBlock)complection;
//获取用户信息
- (NSURLSessionDataTask *)postUserinfoComplection:(JSONResultBlock)complection;
//签到
- (NSURLSessionDataTask *)postSignComplection:(JSONResultBlock)complection;
//图片上传
- (NSURLSessionDataTask *)postUpLoadImageForUserinfoWithImagePathList:(NSArray *)imageList block:(JSONResultBlock)resoultBlock;
//提交编辑
- (NSURLSessionDataTask *)postUpdataWithImagePathList:(NSArray *)imageList Name:(NSString *)name Sex:(NSString *)sex Compony:(NSString *)compony addr:(NSString *)addr Block:(JSONResultBlock)complection;

@end
