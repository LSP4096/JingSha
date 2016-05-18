//
//  HotSearchTableViewCell.m
//  JingSha
//
//  Created by BOC on 15/11/7.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "HotSearchTableViewCell.h"

@interface HotSearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *firstBTn;

@property (weak, nonatomic) IBOutlet UIButton *secondBTn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@end

@implementation HotSearchTableViewCell

- (void)configureDataWithArray:(NSArray *)arr {
    [self.firstBTn setTitle:arr[0] forState:UIControlStateNormal];
    [self.secondBTn setTitle:arr[1] forState:UIControlStateNormal];
    [self.thirdBtn setTitle:arr[2] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
