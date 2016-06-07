//
//  SPExchangeCenterCell.h
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPExchangeCenterDelegate <NSObject>
- (void)exchangeMoreBtnClick;
<<<<<<< HEAD
- (void) putIntoExchangeDetail:(NSString *)Id;
=======
-(void)putIntoExchangeDetail:(NSString *)Id;
>>>>>>> origin/master

@end

@interface SPExchangeCenterCell : UITableViewCell
@property (nonatomic, strong)id <SPExchangeCenterDelegate> delegate;
@end
