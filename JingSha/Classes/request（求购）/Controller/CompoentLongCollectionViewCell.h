//
//  CompoentLongCollectionViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/25.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComponentModel.h"
@interface CompoentLongCollectionViewCell : UICollectionViewCell

//@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, strong)ComponentModel * model;
@property (weak, nonatomic) IBOutlet UITextField *contentField;

@end
