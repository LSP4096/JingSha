//
//  XWTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/28.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "XWTableViewCell.h"
#import "HCSStarRatingView.h"

@interface XWTableViewCell ()

@property (weak, nonatomic) IBOutlet HCSStarRatingView *xingjiView;
@end

@implementation XWTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setStarCount:(NSString *)starCount{
    _starCount = starCount;
    self.xingjiView.value = [_starCount integerValue];
}
@end
