//
//  RequestDetailViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestDetailViewController : UIViewController

@property (nonatomic, assign)BOOL isCanAlter;
@property (nonatomic, copy)NSString *classTitle;//判断是化纤  还是  纱线。两个显示的cell不一样


@property (nonatomic, copy)NSString * HTMLUrlStr;
@property (nonatomic, copy)NSString * Id;//求购的Id

@property (nonatomic, copy)NSString * shareTitle;
@property (nonatomic, copy)NSString * shareContent;

//@property (nonatomic, assign)BOOL  fromNews;

@end
