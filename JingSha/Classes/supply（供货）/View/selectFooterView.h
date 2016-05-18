//
//  selectFooterView.h
//  JingSha
//
//  Created by 周智勇 on 15/12/24.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectFooterViewDelegate <NSObject>

- (void)confirmRefresh;

@end

@interface selectFooterView : UIView
@property (nonatomic, copy)NSString * string;

@property (nonatomic, weak)id<selectFooterViewDelegate>delegate;

@end
