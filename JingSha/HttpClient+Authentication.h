//
//  HttpClient+Authentication.h
//  JingSha
//
//  Created by 苹果电脑 on 6/20/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient.h"

@interface HttpClient (Authentication)

/**
 *  登录接口
 *
 *  @param account     账号
 *  @param password    密码
 *  @param complection 完成的回调
 *
 *  @return 。
 */
- (NSURLSessionDataTask *)LoginWithAccount:(NSString *)account
                Password:(NSString *)password
             Complection:(JSONResultBlock)complection;

/**
 *  登出接口
 *
 *  @param complection 完成的回调
 *
 *  @return 。
 */
- (NSURLSessionDataTask *)LogOutWithComplection:(JSONResultBlock)complection;

/**
 *  获取注册的验证码
 *
 *  @param number      手机号
 *  @param complection 完成的回调
 *
 *  @return 验证码
 */
- (NSURLSessionDataTask *)SendCodeWithPhoneNumber:(NSString *)number
                                      Complection:(JSONResultBlock)complection;

/**
 *  用户注册
 *
 *  @param accountName 电话
 *  @param password    密码
 *  @param name        名称
 *
 *  @return 注册
 */
- (NSURLSessionDataTask *)registersWithAccountName:(NSString *)accountName
                                          Password:(NSString *)password
                                          UserName:(NSString *)name
                                              Code:(NSString *)code
                                       Complection:(JSONResultBlock )complection;

/**
 *  获取重置密码的验证码
 *
 *  @param number      手机号
 *  @param complection 完成的回调
 *
 *  @return 验证码
 */
- (NSURLSessionDataTask *)ResetPasswordCodeWithPhoneNumber:(NSString *)number
                                      Complection:(JSONResultBlock)complection;

/**
 *  重置密码
 *
 *  @param number      手机号
 *  @param password    密码
 *  @param code        验证码
 *  @param complection 完成回调
 *
 *  @return 。
 */
- (NSURLSessionDataTask *)ResetPasswordWithPhoneNumber:(NSString *)number
                                              Password:(NSString *)password
                                                  Code:(NSString *)code
                                           Complection:(JSONResultBlock)complection;

//获取用户信息
- (NSURLSessionDataTask *)postUserinfoComplection:(JSONResultBlock)complection;
//图片上传
- (NSURLSessionDataTask *)postUpLoadImgWithImgs:(NSArray *)imgs Complection:(JSONResultBlock)complection;

@end
