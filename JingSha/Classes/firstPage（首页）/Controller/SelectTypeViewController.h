//
//  SelectTypeViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTypeViewController : UIViewController

@property (nonatomic, copy) void (^myblock)(NSString *typeStr);

@property (nonatomic, copy)NSString * typeNum;
@end
