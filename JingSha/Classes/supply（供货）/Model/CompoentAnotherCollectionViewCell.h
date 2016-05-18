//
//  CompoentAnotherCollectionViewCell.h
//  JingSha
//
//  Created by 周智勇 on 16/1/22.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComponentModel.h"


@interface CompoentAnotherCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)ComponentModel * anotherModel;

@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UITextField *precentField;

@end
