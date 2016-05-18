//
//  BigPhotoTableViewCell.h
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWNewsModel.h"
@interface BigPhotoTableViewCell : UITableViewCell
- (void)configureDataWithModel:(XWNewsModel *)model;
@end
