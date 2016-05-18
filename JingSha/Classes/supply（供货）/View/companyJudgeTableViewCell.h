//
//  companyJudgeTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JudgeModel.h"
@interface companyJudgeTableViewCell : UITableViewCell

@property (nonatomic, strong)JudgeModel * model;

+(CGFloat)callHeight:(JudgeModel *)model;
@end
