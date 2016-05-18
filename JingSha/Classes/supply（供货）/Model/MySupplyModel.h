//
//  MySupplyModel.h
//  JingSha
//
//  Created by 周智勇 on 15/12/31.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySupplyModel : NSObject

@property (nonatomic, copy)NSString * Id;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * jiage;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * guige;
@property (nonatomic, copy)NSString * content;//供应简介
@property (nonatomic, copy)NSString * photo;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSString * total;//总条数

@property (nonatomic, assign)BOOL isHidden;

@end
