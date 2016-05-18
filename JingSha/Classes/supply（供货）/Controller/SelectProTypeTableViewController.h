//
//  SelectProTypeTableViewController.h
//  JingSha
//
//  Created by 周智勇 on 16/2/24.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectProTypeTableViewController : UITableViewController

@property (nonatomic, copy) void (^myblock)(NSString *typeStr);
@property (nonatomic, copy)NSString * typeNum;

@property (nonatomic, assign)BOOL isShaixuan;
@end
