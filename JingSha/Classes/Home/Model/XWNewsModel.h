//
//  XWNewsModel.h
//  JingSha
//
//  Created by BOC on 15/11/3.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWNewsModel : NSObject



/** 是否有版图*/
@property (nonatomic, copy) NSString *bantype;
/** 版图列表*/
@property (nonatomic, strong) NSArray *banlist;


/** 点击量*/
@property (nonatomic, copy) NSString *click;
/** 简介*/
@property (nonatomic, copy) NSString *content;
/** 新闻ID*/
@property (nonatomic, copy) NSString *newsid; //下面也用到了
/** 图片*/
@property (nonatomic, strong) NSArray *photo;
/** 发布时间*/
@property (nonatomic, copy) NSString *time;
/** 标题*/
@property (nonatomic, copy) NSString *title;
/** 图片类型 无图 1图 3图*/
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *sid; //收藏界面使用

@property (nonatomic, copy) NSString *newstitle; //个人中心 -- 我的评论使用

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)xwnewModelWithDictionary:(NSDictionary *)dic;


@property (nonatomic, assign) NSInteger cID;
@property (nonatomic, strong) NSDictionary *dataSource;
- (id)initWithcID:(NSInteger)cID
           newsid:(NSString *)newsid
       dataSource:(NSDictionary *)dic;
+ (id)xwnewsModelWithcID:(NSInteger)cID
           newsid:(NSString *)newsid
       dataSource:(NSDictionary *)dic;
@end
