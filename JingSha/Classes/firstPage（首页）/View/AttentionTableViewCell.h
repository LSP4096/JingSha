
//  AttentionTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/11.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionModel.h"

@protocol AttentionTableViewCellDelegate <NSObject>

- (void)didClickedAttentionBut:(UIButton *)sender;

@end
@interface AttentionTableViewCell : UITableViewCell

@property (nonatomic, strong)AttentionModel * model;
@property (nonatomic, assign)id<AttentionTableViewCellDelegate>delegate;
@end
