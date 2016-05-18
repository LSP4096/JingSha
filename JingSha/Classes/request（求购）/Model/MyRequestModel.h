//
//  MyRequestModel.h
//  JingSha
//
//  Created by 周智勇 on 15/12/31.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRequestModel : NSObject
@property (nonatomic, copy)NSString * Id;//信息id
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * jianjie;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * zhishu;
@property (nonatomic, copy)NSString * chengfen;
@property (nonatomic, copy)NSString * guige;
@property (nonatomic, copy)NSString * baojia;//是否有人报价
@property (nonatomic, copy)NSString * zhuangtai;//1审核中2拒绝3同意/求购中4完成
@property (nonatomic, copy)NSString * Type;//1纱线 2化纤
@property (nonatomic, copy)NSString * baonum;//报价的个数
@property (nonatomic, copy)NSString * photo;//信息图片
@end
