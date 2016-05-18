//
//  convertTopTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "convertTopTableViewCell.h"

@interface convertTopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *jifenLable;

@end
@implementation convertTopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DuiHUanHistoryModel *)model{
    _model = model;
    if (![_model.photo isKindOfClass:[NSNull class]]) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    }
    self.titleLable.text = _model.title;
    self.jifenLable.text = _model.jifen;
}


@end
