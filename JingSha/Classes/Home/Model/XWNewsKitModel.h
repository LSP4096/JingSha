//
//  XWNewsKitModel.h
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWNewsModel.h"
@interface XWNewsKitModel : NSObject

/**KitType框架类型 */
@property (nonatomic, copy) NSString *kitType;

@property (nonatomic, strong) NSArray *newslistArr;
@property (nonatomic, strong) XWNewsModel *xwNewsModel;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)xwNewsKitModelWithDictionary:(NSDictionary *)dic;

@end
