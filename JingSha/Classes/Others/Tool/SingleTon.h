//
//  SingleTon.h
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTon : NSObject

+ (SingleTon *)shareSingleTon;

@property (nonatomic, strong) NSDictionary *userInformation;
@property (nonatomic, copy) NSString *userPassWoed;

@property (nonatomic, strong) NSMutableDictionary *mDic;

@property (nonatomic, assign) NSInteger selectBag;

//
@property (nonatomic, copy)NSString * leibieStr;
@property (nonatomic, copy)NSString * zhisuStr;
@property (nonatomic, copy)NSString * zcdStr;
@property (nonatomic, copy)NSString * qiyefenleiStr;


@end
