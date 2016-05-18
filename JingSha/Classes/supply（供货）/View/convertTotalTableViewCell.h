//
//  convertTotalTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuiHUanHistoryModel.h"

@interface convertTotalTableViewCell : UITableViewCell
@property (nonatomic, strong)DuiHUanHistoryModel * model;

@property (nonatomic, strong)DuiHUanHistoryModel * model2;



@property (weak, nonatomic) IBOutlet UILabel *leftLable;
@property (weak, nonatomic) IBOutlet UILabel *rightLable;
@end
