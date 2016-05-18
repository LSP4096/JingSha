//
//  BannerTopTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 16/1/18.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueModel.h"
@interface BannerTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentField;

@property (nonatomic, strong)IssueModel *model;
@end
