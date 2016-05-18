//
//  OptionAnotherCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/1/23.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "OptionAnotherCollectionViewCell.h"

@implementation OptionAnotherCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        self.stateImageView.image = [UIImage imageNamed:@"chcektrue"];
        self.contentField.userInteractionEnabled = YES;
    }else{
        self.stateImageView.image = [UIImage imageNamed:@"checkfalse"];
        self.contentField.userInteractionEnabled = NO;
        self.contentField.text = nil;
    }
}
@end
