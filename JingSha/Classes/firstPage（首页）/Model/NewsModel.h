//
//  NewsModel.h
//  JingSha
//
//  Created by 周智勇 on 16/1/8.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic, copy)NSString * Id;//xin信息id
@property (nonatomic, copy)NSString * content;//信息说明
@property (nonatomic, copy)NSString * protitle;//审核失败标题（针对求购信息审核之类）
@property (nonatomic, copy)NSString * time;//发布时间
@property (nonatomic, copy)NSString * tong;//是否通过审核（1通过 2拒绝）
@property (nonatomic, copy)NSString * type;//信息类别（1求购 2供应产品 待完善）
@property (nonatomic, copy)NSString * yuanyin;//审核失败原因（针对求购信息审核之类）
@property (nonatomic, copy)NSString * title;//信息标题
@property (nonatomic, copy)NSString * pro_buy_id;

@property (nonatomic, copy)NSString * procontent;

@end
