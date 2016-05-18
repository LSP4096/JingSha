//
//  AlwaysCityTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 16/1/26.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlwaysCityTableViewCellDelegate <NSObject>

- (void)alwaycityClicked:(UIButton *)sender cell:(UITableViewCell *)cells;

@end
@interface AlwaysCityTableViewCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray * array;

@property (nonatomic, assign)id<AlwaysCityTableViewCellDelegate>delegate;
@end
