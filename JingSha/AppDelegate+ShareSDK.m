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
    [ShareSDK registerApp:@"12c00583791f6"
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
                             [appInfo SSDKSetupWeChatByAppId:@"wxef37270a3109f624"
                                                   appSecret:@"cc188b3c1dc39115f983a0ef272e66c8"];
                         }
                             break;
                         case SSDKPlatformTypeQQ:
                         {
                             [appInfo SSDKSetupQQByAppId:@"1104978366"
                                                  appKey:@"1eAcBPNqzgqanUXS"
                                                authType:@"SSDKAuthTypeSSO"];
                         }
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                         {
                             [appInfo SSDKSetupSinaWeiboByAppKey:@"1649734259"
                                                       appSecret:@"b96788584a4150c4a1afd16be3a7361f"
                                                     redirectUri:@"http://www.sharesdk.cn"
                                                        authType:@"SSDKAuthTypeBoth"];
                         }
                             break;
                         default:
                             break;
                     }
                 }];
}
@end
