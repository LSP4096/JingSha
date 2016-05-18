//
//  OptionProductCollectionViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCPModel.h"
@interface OptionProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)ZYCPModel * model;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

//
@property (nonatomic, assign)BOOL isSelected;
@end
