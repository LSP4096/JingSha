//
//  XWNewsDetailViewController.h
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWNewsDetailViewController : UIViewController

@property (nonatomic, copy) NSString *sendUrlStr;///webView使用
@property (nonatomic, strong) NSDictionary *newsInfoDic;
@end
