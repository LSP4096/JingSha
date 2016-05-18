//
//  CompoentCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/25.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CompoentCollectionViewCell.h"

@interface CompoentCollectionViewCell ()<UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation CompoentCollectionViewCell

- (void)awakeFromNib {
    self.contenttextField.delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangetext) name:UITextFieldTextDidChangeNotification object:nil];
    [self.contenttextField setKeyboardType:UIKeyboardTypeNumberPad];
}
- (void)textDidChangetext{
//   self.model.contentString = self.contenttextField.text;
}
- (void)setModel:(ComponentModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    self.contenttextField.text = _model.contentString;
    if (_model.isSelected) {//被选中
        self.stateImage.image = [UIImage imageNamed:@"chcektrue"];
        self.contenttextField.userInteractionEnabled = YES;
    }else{
        self.stateImage.image = [UIImage imageNamed:@"checkfalse"];
        self.contenttextField.userInteractionEnabled = NO;
        self.contenttextField.text = nil;
    }
}
#pragma mark ---
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldchangedToModel:cells:)]) {
        [self.delegate textFieldchangedToModel:textField.text cells:self];
    }
    
    return YES;
}

@end
