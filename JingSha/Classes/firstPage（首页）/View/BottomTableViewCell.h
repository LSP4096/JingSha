//
//  BottomTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomTableViewCellDetagate <NSObject>
//向他报价按钮的代理事件
- (void)quoteToOthers;
//查看联系方式按钮事件
- (void)checkConnectStyle;
@end

@interface BottomTableViewCell : UITableViewCell
@property (nonatomic, weak)id<BottomTableViewCellDetagate>delegate;

@end

