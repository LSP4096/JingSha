//
//  DownTableViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/26.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownTableViewControllerDelegate <NSObject>

- (void)CellGetValue:(NSString *)value;

@end

@interface DownTableViewController : UITableViewController

@property (nonatomic, copy)NSString * cid;

//
@property (nonatomic, weak)id<DownTableViewControllerDelegate>delegate;
@end
