//
//  CheckQuoteTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckQuoteModel.h"
@protocol CheckQuoteTableViewCellDelegate <NSObject>
- (void)delegatePushToJudgeVC:(UIButton *)sender;

@end

@interface CheckQuoteTableViewCell : UITableViewCell

@property (nonatomic, strong)CheckQuoteModel * model;

@property (nonatomic, assign)id<CheckQuoteTableViewCellDelegate>delegate;
@end
