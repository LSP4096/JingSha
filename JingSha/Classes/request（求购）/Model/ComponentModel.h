//
//  ComponentModel.h
//  JingSha
//
//  Created by 周智勇 on 15/12/25.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComponentModel : NSObject
@property (nonatomic, copy)NSString * title;//选项标题
@property (nonatomic, assign)BOOL isSelected;//选中状态
@property (nonatomic, copy)NSString * contentString;//输入框内容


@property (nonatomic, assign)BOOL isAdd;
@end
