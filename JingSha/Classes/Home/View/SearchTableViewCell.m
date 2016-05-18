//
//  SearchTableViewCell.m
//  JingSha
//
//  Created by BOC on 15/11/9.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell ()



@end



@implementation SearchTableViewCell

- (void)configureDataWithArray:(NSArray *)array {
    //需要判断是否有大于三个
    if (array.count == 1) {
        self.firstBrn.hidden = NO;
        [self.firstBrn setTitle:array[0] forState:UIControlStateNormal];
        self.secondBtn.hidden = YES;
        self.thirdBtn.hidden = YES;
    } else if (array.count == 2) {
        self.firstBrn.hidden = NO;
        self.secondBtn.hidden = NO;
         [self.firstBrn setTitle:array[0] forState:UIControlStateNormal];
        [self.secondBtn setTitle:array[1] forState:UIControlStateNormal];
        self.thirdBtn.hidden = YES;
    } else if (array.count == 3) {
        self.firstBrn.hidden = NO;
        self.secondBtn.hidden = NO;
        self.thirdBtn.hidden = NO;
        [self.firstBrn setTitle:array[0] forState:UIControlStateNormal];
        [self.secondBtn setTitle:array[1] forState:UIControlStateNormal];
        [self.thirdBtn setTitle:array[2] forState:UIControlStateNormal];
    } else if (array == nil) {
        self.firstBrn.hidden = YES;
        self.secondBtn.hidden = YES;
        self.thirdBtn.hidden = YES;
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
