//
//  TopHeaderView.h
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopHeaderViewDelegate <NSObject>

- (void)pushToStandingsIntroduce;
- (void)pushToStandingsShop;
@end

@interface TopHeaderView : UIView

@property (nonatomic, strong)UILabel * currentCountLable;
@property (nonatomic, strong)UIButton * standingsIntroduce;
@property (nonatomic, strong)UILabel * countLable;
@property (nonatomic, strong)UILabel * scoreLable;
@property (nonatomic, strong)UIButton * convertButton;
@property (nonatomic, copy)NSString * jifen;
//
@property (nonatomic, weak)id<TopHeaderViewDelegate>delegate;

@end
