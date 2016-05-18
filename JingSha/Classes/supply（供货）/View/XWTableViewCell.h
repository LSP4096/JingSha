//
//  XWTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/28.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@property (nonatomic, copy)NSString * starCount;
@end
