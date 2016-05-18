//
//  OptionProductCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "OptionProductCollectionViewCell.h"

@implementation OptionProductCollectionViewCell

- (void)awakeFromNib {
    
}


//-(void)setIsSelected:(BOOL)isSelected{
//    _isSelected = isSelected;
//    if (_isSelected) {
//        self.stateImageView.image = [UIImage imageNamed:@"chcektrue"];
//    }else{
//        self.stateImageView.image = [UIImage imageNamed:@"checkfalse"];
//    }
//}

- (void)setModel:(ZYCPModel *)model{
    _model = model;
    if (_model.isSelected) {
        self.stateImageView.image = [UIImage imageNamed:@"chcektrue"];
    }else{
        self.stateImageView.image = [UIImage imageNamed:@"checkfalse"];
    }
    self.titleLable.text = _model.title;
}





@end
