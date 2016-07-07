//
//  HttpClient+FirstPage.h
//  JingSha
//
//  Created by 苹果电脑 on 6/17/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "HttpClient.h"

@interface HttpClient (FirstPage)

/**
 *  首页数据
 *  @return response
 */
- (NSURLSessionDataTask *)getFirstPageInfoComplecion:(JSONResultBlock)complection;


//消息列表
- (NSURLSessionDataTask *)getNewsListWithPage:(NSInteger)page
                                    PageCount:(NSInteger)pagecount
                                  Complection:(JSONResultBlock)complection;
//交易中心
- (NSURLSessionDataTask *)getExchangesCenterWithPage:(NSInteger)page
                                           PageCount:(NSInteger)pagecount
                                                Type:(NSInteger)type
                                             KeyWord:(NSString *)keyword
                                         Complection:(JSONResultBlock)complection;

//最新求购
- (NSURLSessionDataTask *)getLasterRequestWithPage:(NSInteger)page Count:(NSInteger)count KeyWord:(NSString *)keyword Complection:(JSONResultBlock)complection;

@end


