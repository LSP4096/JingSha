//
//  SPHotProductTableViewCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SPHotProductTableViewCell.h"
@interface SPHotProductTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation SPHotProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(HotProductMoreBtnClick:)]) {
        [self.delegate HotProductMoreBtnClick:sender];
    }
}

@end
