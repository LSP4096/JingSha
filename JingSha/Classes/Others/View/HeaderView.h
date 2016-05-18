//
//  HeaderView.h
//  CityListDemo
//
//  Created by Frank on 15/8/5.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvinceModel.h"
#import "TypeModel.h"
@protocol HeaderViewDelegate <NSObject>
- (void)buttonClick:(UIButton *)sender;
@end

@interface HeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) id<HeaderViewDelegate> delegate;
@property (nonatomic, strong)ProvinceModel * model;
@property (nonatomic, strong)TypeModel * typeModel;

@end
