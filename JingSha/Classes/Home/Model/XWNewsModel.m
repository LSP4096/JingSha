//
//  XWNewsModel.m
//  JingSha
//
//  Created by BOC on 15/11/3.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "XWNewsModel.h"

@implementation XWNewsModel


- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
//        [self setValuesForKeysWithDictionary:dic];
      
        if (((NSString *)dic[@"title"]).length) {
            self.title = dic[@"title"];
        } else {
        self.title = @"暂无";
        }
        self.content = dic[@"content"];
        self.time = dic[@"time"];
        self.photo = dic[@"photo"];
        self.click = [NSString stringWithFormat:@"%@", dic[@"click"]];
        self.type = [NSString stringWithFormat:@"%@", dic[@"type"]];
        self.newsid = [NSString stringWithFormat:@"%@", dic[@"newsid"]];
        
        if (dic[@"sid"] != nil) {
            self.sid = [NSString stringWithFormat:@"%@", dic[@"sid"]];
        }
        if (dic[@"newstitle"] != nil) {
            self.newstitle = [NSString stringWithFormat:@"%@", dic[@"newstitle"]];
        }
    }
    return self;
}
+ (id)xwnewModelWithDictionary:(NSDictionary *)dic {
    return [[XWNewsModel alloc] initWithDictionary:dic];
}
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"newsid"]) {
        self.newsid = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"type"]) {
        self.type= [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"click"]) {
        self.click = [NSString stringWithFormat:@"%@", value];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
/**
 *  数据存储使用
 */
- (id)initWithcID:(NSInteger)cID
           newsid:(NSString *)newsid
       dataSource:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.cID = cID;
        self.newsid = newsid;
        self.dataSource = dic;
    }
    return self;
}
+ (id)xwnewsModelWithcID:(NSInteger)cID
                  newsid:(NSString *)newsid
              dataSource:(NSDictionary *)dic {
        return [[XWNewsModel alloc] initWithcID:cID newsid:newsid dataSource:dic];
}

@end
