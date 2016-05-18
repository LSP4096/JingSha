//
//  ProvinceModel.h
//  JingSha
//
//  Created by 周智勇 on 15/12/16.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject

@property (nonatomic, copy)    NSString *province; //当前省名
@property (nonatomic, strong)   NSArray *cities; //所有城市

@property (nonatomic, assign)   BOOL isOpen; //是否打开

@end
