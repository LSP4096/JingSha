//
//  DidAttentionTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstPageAttModel.h"

@protocol DidAttentionTableViewCellDelegate <NSObject>

- (void)clickedDidAttention:(id)sender which:(NSInteger)btnTag;

@end

@interface DidAttentionTableViewCell : UITableViewCell

@property (nonatomic, strong)FirstPageAttModel * model;
@property (nonatomic, assign)id<DidAttentionTableViewCellDelegate>delegate;

+ (CGFloat)callHight:(NSArray *)array;
@end
