//
//  TableHeaderView.h
//  JingSha
//
//  Created by 周智勇 on 15/12/18.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableHeaderView;
@protocol TableHeaderViewDelegate <NSObject>

- (void)cameraBtnClicked:(TableHeaderView *)headerView canCamera:(BOOL)isCan;
- (void)deleteBut:(UIImageView *)sender;
@end

@interface TableHeaderView : UIView
@property (nonatomic, strong)UIImageView * picImageView1;
@property (nonatomic, strong)UIImageView * picImageView2;
@property (nonatomic, strong)UIImageView * picImageView3;
@property (nonatomic, strong)UIImageView * picImageView4;

@property (nonatomic, strong)UIButton * cameraBut;
@property (nonatomic, assign)int count;
//
@property (nonatomic, weak)id<TableHeaderViewDelegate> delegate;
@end
