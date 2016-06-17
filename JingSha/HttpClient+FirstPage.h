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

@end
