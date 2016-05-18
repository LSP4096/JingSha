//
//  CompoentAnotherCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/1/22.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "CompoentAnotherCollectionViewCell.h"

@interface CompoentAnotherCollectionViewCell ()<UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;



@end

@implementation CompoentAnotherCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.precentField setKeyboardType:UIKeyboardTypePhonePad];
}

-(void)setAnotherModel:(ComponentModel *)anotherModel{
    _anotherModel = anotherModel;
    self.contentField.text = _anotherModel.title;
    self.precentField.text = _anotherModel.contentString;
    if (_anotherModel.isSelected) {//被选中
//        [self.stateButton setImage:[UIImage imageNamed:@"chcektrue"] forState:UIControlStateNormal];
        self.stateImage.image = [UIImage imageNamed:@"chcektrue"];
        self.contentField.userInteractionEnabled = YES;
        self.precentField.userInteractionEnabled = YES;
    }else{
//        [self.stateButton setImage:[UIImage imageNamed:@"checkfalse"] forState:UIControlStateNormal];
        self.stateImage.image = [UIImage imageNamed:@"checkfalse"];
        self.contentField.userInteractionEnabled = NO;
        self.precentField.userInteractionEnabled = NO;
        self.contentField.text = nil;
        self.precentField.text = nil;
    }
}



@end
