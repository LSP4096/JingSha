//
//  AddSupplyTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSupplyModel.h"
#import "MyTextView.h"
@protocol AddSupplyTableViewCellDelegate <NSObject>

- (void)getValueFromTextView:(MyTextView *)sender cells:(UITableViewCell *)cells;
- (void)getImage:(UIButton *)sender;
- (void)deletePic:(UIButton *)sender cells:(UITableViewCell *)cells;

@end

@interface AddSupplyTableViewCell : UITableViewCell
@property (nonatomic, strong)AddSupplyModel * model;
@property (nonatomic, strong)AddSupplyModel * alterModel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (nonatomic, assign)id<AddSupplyTableViewCellDelegate>delegate;

@end
