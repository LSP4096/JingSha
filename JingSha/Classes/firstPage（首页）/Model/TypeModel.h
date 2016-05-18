//
//  TypeModel.h
//  JingSha
//
//  Created by 周智勇 on 16/1/10.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeModel : NSObject
@property (nonatomic, copy)NSString * Id;//大类.子类的id
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * guanzhu;//用不到

@property (nonatomic, strong) NSArray *typeItems;

@property (nonatomic, assign)BOOL isOpen;
@property (nonatomic, assign)BOOL isSelected;
@end
//大类  子类通用的model