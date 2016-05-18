//
//  TwoTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConpanyMessageModel.h"
@interface TwoTableViewCell : UITableViewCell

@property (nonatomic ,strong)ConpanyMessageModel * model;

+ (CGFloat)callHight:(NSString *)contentString;
@end
