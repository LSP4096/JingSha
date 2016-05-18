
//  IssueRequestViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/18.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueRequestViewController : UIViewController

//@property (nonatomic, copy)NSString * typeString;//是哪一个类型，纱线还是化纤
@property (nonatomic, strong)NSArray * selectedTitle;
@property (nonatomic, strong)NSArray * selectedContent;

@property (nonatomic, copy)NSString * bid;//用来修改  求购的id

@property (nonatomic, assign)BOOL isAlter;


@end
