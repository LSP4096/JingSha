//
//  ProductPromptViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductPromptViewController : UIViewController

@property (nonatomic, copy)NSString * cid;
@property (nonatomic, copy)void (^myBlock)(NSArray * productAry);
@end
