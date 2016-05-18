//
//  SleepTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/1/18.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "SleepTableViewCell.h"

@interface SleepTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@end

@implementation SleepTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
    [self.stateImageView addGestureRecognizer:tap];
    self.stateImageView.userInteractionEnabled = YES;
}

- (void)setModel:(SleepModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    if (_model.isChecked) {
//        [self.checkButton setImage:[UIImage imageNamed:@"Me_selected"] forState:UIControlStateNormal];
        self.stateImageView.image = [UIImage imageNamed:@"chcektrue"];
    }else{
//        [self.checkButton setImage:nil forState:UIControlStateNormal];
         self.stateImageView.image = [UIImage imageNamed:@"checkfalse"];
    }
    
    self.dayTextField.text = _model.timeStr;
}


- (void)imageViewClicked:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sleepclicked:)]) {
        [self.delegate sleepclicked:self];
    }
}



@end
