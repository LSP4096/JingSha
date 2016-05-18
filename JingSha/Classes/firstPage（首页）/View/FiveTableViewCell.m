//
//  FiveTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "FiveTableViewCell.h"
#import "HCSStarRatingView.h"
@interface FiveTableViewCell ()
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starBackView;

@end

@interface FiveTableViewCell ()

@end

@implementation FiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setStarCount:(NSString *)starCount{
    self.starBackView.backgroundColor = [UIColor clearColor];
    _starCount = starCount;
    self.starBackView.value = [_starCount integerValue]/2;
    self.starBackView.userInteractionEnabled = NO;
}


@end
