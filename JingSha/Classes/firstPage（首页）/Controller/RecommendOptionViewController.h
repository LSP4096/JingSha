//
//  RecommendOptionViewController.h
//  JingSha
//
//  Created by 周智勇 on 15/12/7.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendOptionViewController : UIViewController
//加一个属性，来判断进入的纱线还是化纤的筛选
//@property (nonatomic ,strong)NSString * whichToSelect;

//加一个属性判断进入的产品、供应商、求购
@property (nonatomic, strong)NSString * searchTitle;

//点击搜索的可选按钮进来，实际搜索的就是点击的按钮的文字内容
@property (nonatomic, copy)NSString * optionSearchText;
@end
