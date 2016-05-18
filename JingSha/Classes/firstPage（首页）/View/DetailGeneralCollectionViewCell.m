//
//  DetailGeneralCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/7.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "DetailGeneralCollectionViewCell.h"

@interface DetailGeneralCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *jiageLable;

@end
@implementation DetailGeneralCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(ProListModel *)model{
    _model = model;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    self.titleLable.text = _model.title;
    self.jiageLable.text = _model.jiage;
}

@end
