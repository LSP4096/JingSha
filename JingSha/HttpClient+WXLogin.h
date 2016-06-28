//
//  HttpClient+WXLogin.h
//  JingSha
//
//  Created by 苹果电脑 on 6/28/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient.h"

@interface HttpClient (WXLogin)
/**
 *  得到accessToken
 *
 *  @param code 临时票据code
 *
 *  @return accessToken等信息
 */
- (NSURLSessionDataTask *)getAccessTokenWithCode:(NSString *)code
                                     Complection:(JSONResultBlock)complection;

/**
 *  得到微信用户信息
 *
 *  @param openId      openId
 *  @param accesstoken token
 *  @param complection huidiao
 *
 *  @return 信息
 */
- (NSURLSessionDataTask *)getWeChatUserInfoWithOpenId:(NSString *)openId
                                          AccessToken:(NSString *)accesstoken
                                          Complection:(JSONResultBlock)complection;
@end
