//
//  AddSupplyViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSupplyViewController : UIViewController
@property (nonatomic, copy)NSString * typeString;//是哪一个类型，纱线还是化纤

@property (nonatomic, assign)BOOL isAlter;
@property (nonatomic, copy)NSString * proid;
@end
