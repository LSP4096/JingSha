//
//  SPHotProductTableViewCell.h
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SPHotProductCellDelegata <NSObject>
- (void)HotProductMoreBtnClick:(id)sender;
- (void)pushToDetailVCFromCell:(NSString *)string;

@end

@interface SPHotProductTableViewCell : UITableViewCell
@property (nonatomic, strong) id <SPHotProductCellDelegata> delegate;

@end
