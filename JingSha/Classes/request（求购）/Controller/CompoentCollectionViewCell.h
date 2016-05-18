//
//  CompoentCollectionViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/25.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComponentModel.h"

@protocol CompoentCollectionViewCellDelegate <NSObject>

- (void)textFieldchangedToModel:(NSString *)textFieldStr cells:(UICollectionViewCell *)cells;

@end

@interface CompoentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)ComponentModel *model;
@property (weak, nonatomic) IBOutlet UITextField *contenttextField;
//
//@property(nonatomic, assign)BOOL isSelected;

//
@property (nonatomic, assign)id<CompoentCollectionViewCellDelegate>delegate;
@end
