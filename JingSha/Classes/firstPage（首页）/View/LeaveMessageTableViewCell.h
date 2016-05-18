//
//  LeaveMessageTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/15.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveMesModel.h"
@interface LeaveMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *contentField;

@property (nonatomic, strong)LeaveMesModel * model;

@end
