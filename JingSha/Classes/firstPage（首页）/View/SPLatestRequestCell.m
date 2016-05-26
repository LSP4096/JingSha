//
//  SPLatestRequestCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SPLatestRequestCell.h"
#define KLabelHight (21 * KProportionHeight)
#define KLabelWeight (100 * KProportionHeight)

@interface SPLatestRequestCell ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *LabelView;

@end

@implementation SPLatestRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.LabelView.frame = CGRectMake(128 * KProportionHeight, 45 * KProportionHeight, 277 * KProportionHeight, 96 * KProportionHeight);
    [self baseLabelUI];
}

- (void)baseLabelUI {
    for (int i =  0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            CGFloat label_Y =  (j + 1) * (self.LabelView.frame.size.height - 3 * KLabelHight) / 4 + KLabelHight * j - 5;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.LabelView.frame.size.width * 1/2 * i, label_Y, KLabelWeight, KLabelHight)];
            label.tag = 100 * i + j * 200;
            label.text = @"text";
            [self.LabelView addSubview:label];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//点击 more按钮
- (IBAction)moreBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
        [self.delegate moreBtnClick:sender];
    }
}

@end
