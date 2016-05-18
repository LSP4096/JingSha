//
//  RequestMsgModel.h
//  JingSha
//
//  Created by 周智勇 on 16/1/4.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMsgModel : NSObject

@property (nonatomic, copy)NSString * jiage;
@property (nonatomic, copy)NSString * Id;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * jianjie;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * zhisu;
@property (nonatomic, copy)NSString * chengfen;
@property (nonatomic, copy)NSString * guige;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSString * baojia;//是否有人报价
@property (nonatomic, copy)NSString * zhuangtai;//1审核中2拒绝3同意/求购中4完成
@property (nonatomic, copy)NSString * Type;//1纱线 2化纤  我的求购


//我的报价
@property (nonatomic, copy)NSString * bao;//我的报价的状态
@property (nonatomic, copy)NSString * bid;//我的报价的求购的id

@end
