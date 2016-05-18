//
//  CompTypeViewController.h
//  JingSha
//
//  Created by 周智勇 on 16/1/14.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompTypeViewController : UIViewController
@property (nonatomic, copy) void (^myblock)(NSString * leimuStr);
@end
