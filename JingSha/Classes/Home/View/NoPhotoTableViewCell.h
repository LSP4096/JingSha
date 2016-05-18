//
//  NoPhotoTableViewCell.h
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWNewsModel.h"
@interface NoPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *clickLabel;


@property (weak, nonatomic) IBOutlet UILabel *pubTime;

- (void)configureDataWithModel:(XWNewsModel *)model;
@end
