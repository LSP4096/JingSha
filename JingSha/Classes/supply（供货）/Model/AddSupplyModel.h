//
//  AddSupplyModel.h
//  JingSha
//
//  Created by 周智勇 on 15/12/31.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddSupplyModel : NSObject

//这个只用于添加供应的图文详细的model，其余的复用IssueModel
@property (nonatomic, copy)NSString * detailStr;
@property (nonatomic, strong)UIImage * detailImage;
@property (nonatomic, copy)NSString * backImageStr;
@end
