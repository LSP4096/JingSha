//
//  CompoentLongCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/25.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CompoentLongCollectionViewCell.h"

@interface CompoentLongCollectionViewCell ()
//@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;

@end

@implementation CompoentLongCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentField setKeyboardType:UIKeyboardTypeNumberPad];
}
- (void)setModel:(ComponentModel *)model{
    _model = model;
    self.titleLable.text = model.title;
    if (model.isSelected) {//被选中
//        [self.stateButton setImage:[UIImage imageNamed:@"chcektrue"] forState:UIControlStateNormal];
        self.stateImage.image = [UIImage imageNamed:@"chcektrue"];
        
    }else{
//        [self.stateButton setImage:[UIImage imageNamed:@"checkfalse"] forState:UIControlStateNormal];
        self.stateImage.image = [UIImage imageNamed:@"checkfalse"];
    }
}

@end
