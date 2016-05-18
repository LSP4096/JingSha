//
//  FiveTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (nonatomic, copy)NSString * starCount;
@end
