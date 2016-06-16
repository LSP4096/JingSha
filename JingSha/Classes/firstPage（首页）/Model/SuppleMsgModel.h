//
//  SuppleMsgModel.h
//  JingSha
//
//  Created by 周智勇 on 16/1/8.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuppleMsgModel : NSObject
@property (nonatomic, copy)NSString * Id;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * photo;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * gongsi;
@property (nonatomic, copy)NSString * type;//信息大类 1纱线 2化纤
@property (nonatomic, copy)NSString * guige;
@property (nonatomic, copy)NSString * jiage;
@property (nonatomic, copy)NSString * chengfen;
@property (nonatomic, copy)NSString * zcd;//搜索结果的时候用
@property (nonatomic, copy)NSString * zhisu;//搜索结果的时候用
@property (nonatomic, copy)NSString * num;

@end
