//
//  convertDetailMessageTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "convertDetailMessageTableViewCell.h"

@interface convertDetailMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *telLable;
@property (weak, nonatomic) IBOutlet UILabel *addLable;
@end
@implementation convertDetailMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(DuiHUanHistoryModel *)model{
    _model = model;
    self.nameLable.text = _model.name;
    self.telLable.text = _model.tel;
    self.addLable.text = _model.addr;
}




@end
