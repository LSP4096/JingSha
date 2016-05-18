//
//  CitiesTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/16.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeModel.h"
@interface CitiesTableViewCell : UITableViewCell

@property (nonatomic, assign, getter=isChecked) BOOL checked;
@property (nonatomic, copy) NSString *cityName;


@property (nonatomic, strong)TypeModel * model;

@end
