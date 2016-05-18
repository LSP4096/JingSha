//
//  IssueModel.h
//  JingSha
//
//  Created by 周智勇 on 15/12/30.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IssueModel : NSObject

@property (nonatomic, copy)NSString * rightState;
@property (nonatomic, copy)NSString * leftTitle;
@property (nonatomic, copy)NSString * contentStr;

@property (nonatomic, assign)BOOL isPromote;//弹窗
@property (nonatomic, assign)BOOL isDown;//下拉
@property (nonatomic, assign)BOOL isPush;//所属类别push出新的页面、、、、、新修改的
@end
