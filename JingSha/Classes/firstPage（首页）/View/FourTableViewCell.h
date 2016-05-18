//
//  FourTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLable.h"
@interface FourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet MyLable *contentLable;





+ (CGFloat)callHight:(NSString *)contentString;
@end
