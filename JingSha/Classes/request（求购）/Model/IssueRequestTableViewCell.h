//
//  IssueRequestTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/30.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueModel.h"

@protocol IssueRequestTableViewCellDelegate <NSObject>
- (void)showUnitView:(UIButton *)sender;

@end

@interface IssueRequestTableViewCell : UITableViewCell

@property (nonatomic, strong)IssueModel * model;
@property (nonatomic, strong)UITextField * contentField;
@property (nonatomic, strong)UIButton * rightButton;

@property (nonatomic, assign)BOOL canChange;
@property (nonatomic, assign)BOOL isRequest;//这里主要是因为求购的价格为非必填项。。。而在添加产品供应的时候价格为必填项，所以加一个属性判断到底是哪一个页面。并且添加产品时还要提醒价格可以为  面议

@property (nonatomic, weak)id<IssueRequestTableViewCellDelegate>delegate;
@end
