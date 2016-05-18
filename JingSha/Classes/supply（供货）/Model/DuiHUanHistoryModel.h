//
//  DuiHUanHistoryModel.h
//  JingSha
//
//  Created by 周智勇 on 16/2/14.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuiHUanHistoryModel : NSObject

@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * jifen;
@property (nonatomic, copy)NSString * audit;//兑换状态
@property (nonatomic, copy)NSString * photo;
@property (nonatomic, copy)NSString * did;//这条记录的id


//兑换详细也用这个Model,不过是多加了下边的几个属性
@property (nonatomic, copy)NSString * addr;
@property (nonatomic, copy)NSString * content;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * tel;
@property (nonatomic, copy)NSString * time;


@end
