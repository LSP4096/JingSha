//
//  BottomTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "BottomTableViewCell.h"

@interface BottomTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *quoteToOthers;//向他报价
@property (weak, nonatomic) IBOutlet UIButton *checkConnectStyle;//查看联系方式

@end
@implementation BottomTableViewCell

- (void)awakeFromNib {
    [self.quoteToOthers addTarget:self action:@selector(quoteToOthersClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.checkConnectStyle addTarget:self action:@selector(checkConnectStyleClicked) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -- 两个按钮响应事件
- (void)quoteToOthersClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(quoteToOthers)]) {
        [self.delegate quoteToOthers];
    }
}
- (void)checkConnectStyleClicked{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
