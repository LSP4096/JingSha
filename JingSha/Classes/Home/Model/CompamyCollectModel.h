//
//  CompamyCollectModel.h
//  JingSha
//
//  Created by 周智勇 on 16/1/12.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompamyCollectModel : NSObject
@property (nonatomic, copy)NSString * gongsi;
@property (nonatomic, copy)NSString * logo;
@property (nonatomic, copy)NSString * sid;//收藏记录的id  取消收藏的时候用到
@property (nonatomic, copy)NSString * uid;
@property (nonatomic, copy)NSString * zycp;

@end
