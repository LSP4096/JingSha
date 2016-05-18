//
//  SearchModel.h
//  JingSha
//
//  Created by BOC on 15/11/7.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
//点击数
@property (nonatomic, copy) NSString *click;
//新闻ID
@property (nonatomic, copy) NSString *newsid;
//发布时间
@property (nonatomic, copy) NSString *time;
//标题
@property (nonatomic, copy) NSString *title;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)searchModelWithDictionary:(NSDictionary *)dic;
@end
