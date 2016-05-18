//
//  ComponentPartViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/18.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComponentPartViewController : UIViewController

@property (nonatomic, copy)NSString * cid;
@property (nonatomic, copy) void (^myblock)(NSArray *nameArray, NSArray *percentArray);


@property (nonatomic, strong)NSArray * saveNameArray;
@property (nonatomic, strong)NSArray * savePrecentArray;
@end
