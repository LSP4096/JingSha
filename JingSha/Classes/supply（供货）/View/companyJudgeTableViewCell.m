//
//  companyJudgeTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "companyJudgeTableViewCell.h"
#import "HCSStarRatingView.h"
@interface companyJudgeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starBackView;
@end
@implementation companyJudgeTableViewCell

- (void)awakeFromNib {

}

+(CGFloat)callHeight:(JudgeModel *)model{
    CGRect rect = [model.title boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    
    return 63 + rect.size.height;
}


-(void)setModel:(JudgeModel *)model{
    _model = model;
    self.starBackView.value = [_model.xingji integerValue]/2;
    self.gongsiLable.text = _model.gongsi;
    self.contentLable.text = _model.title;
    CGRect rect = [_model.title boundingRectWithSize: CGSizeMake(self.width - 30, 0)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    self.contentLable.frame = CGRectMake(_contentLable.frame.origin.x, _contentLable.frame.origin.y, self.width - 40, rect.size.height);
}

@end
