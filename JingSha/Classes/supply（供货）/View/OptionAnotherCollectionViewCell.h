//
//  OptionAnotherCollectionViewCell.h
//  JingSha
//
//  Created by 周智勇 on 16/1/23.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCPModel.h"
@interface OptionAnotherCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)ZYCPModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UITextField *contentField;

@property (nonatomic, assign)BOOL isSelected;
@end
