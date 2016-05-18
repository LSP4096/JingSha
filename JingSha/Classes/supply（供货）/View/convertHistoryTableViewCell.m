//
//  convertHistoryTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "convertHistoryTableViewCell.h"

@interface convertHistoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *jifenLable;

@end
@implementation convertHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(JifenModel *)model{
    _model = model;
    self.titleLable.text = _model.title;
    self.timeLable.text = _model.time;
    if ([_model.type isEqualToString:@"1"]) { //1+ 2-
        self.jifenLable.text = [NSString stringWithFormat:@"+%@", _model.jifen];
    }else{
        self.jifenLable.text = [NSString stringWithFormat:@"-%@", _model.jifen];
    }
}

@end
