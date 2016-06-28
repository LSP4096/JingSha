//
//  AppDelegate+ShareSDK.m
//  JingSha
//
//  Created by 苹果电脑 on 5/18/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@implementation AppDelegate (ShareSDK)

- (void)configureShare {
    /**
     *  分享
     */
    [ShareSDK registerApp:kShareAppId
          activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                         {
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             //                [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                         }
                             break;
                         case SSDKPlatformTypeQQ :
                         {
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                         }
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                         {
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                         }
                         default:
                             break;
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                         {
                             [appInfo SSDKSetupWeChatByAppId:kWXAppId
                                                   appSecret:kWXAppSecret];
                         }
                             break;
                         case SSDKPlatformTypeQQ:
                         {
                             [appInfo SSDKSetupQQByAppId:kQQAppId
                                                  appKey:kQQAppSecret
                                                authType:@"SSDKAuthTypeSSO"];
                         }
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                         {
                             [appInfo SSDKSetupSinaWeiboByAppKey:kSinaWeiboAppId
                                                       appSecret:kSinaWeiboAppSecret
                                                     redirectUri:kSinaWeiboRedirectUri
                                                        authType:@"SSDKAuthTypeBoth"];
                         }
                             break;
                         default:
                             break;
                     }
                 }];
}
@end
