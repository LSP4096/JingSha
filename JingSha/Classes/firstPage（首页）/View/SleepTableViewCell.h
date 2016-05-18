//
//  SleepTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 16/1/18.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SleepModel.h"



@protocol SleepTableViewCellDelegate <NSObject>

- (void)sleepclicked:(UITableViewCell *)cells;

@end

@interface SleepTableViewCell : UITableViewCell

@property (nonatomic, strong)SleepModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;

@property (nonatomic, weak)id<SleepTableViewCellDelegate>delegate;

@end
