//
//  SPLatestRequestCell.h
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPLatestRequestcellDelegate <NSObject>

//点击了 more按钮
- (void)moreBtnClick:(UIButton *)sender;

@end

@interface SPLatestRequestCell : UITableViewCell

@property (nonatomic, strong) id <SPLatestRequestcellDelegate> delegate;

@end
