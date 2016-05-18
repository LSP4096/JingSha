//
//  AcceptPromteViewController.h
//  JingSha
//
//  Created by 周智勇 on 16/1/7.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AcceptPromteViewControllerDelegate <NSObject>

- (void)hiddenPromote;
- (void)hiddenPromoteAndJudge:(NSString *)jid;

@end

@interface AcceptPromteViewController : UIViewController
@property (nonatomic, copy)NSString * jid;

@property (nonatomic, assign)id<AcceptPromteViewControllerDelegate>delegate;
@end
