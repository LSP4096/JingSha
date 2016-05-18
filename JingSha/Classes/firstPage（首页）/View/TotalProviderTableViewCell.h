//
//  TotalProviderTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TotalProviderTableViewCellDelegate <NSObject>

- (void)changePageNumber:(int)pageNumber;
- (void)pushToDetailPageVC:(NSString *)string;
@end

@interface TotalProviderTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIScrollView *baseScrollView;

@property (nonatomic, weak)id<TotalProviderTableViewCellDelegate>delegate;
@end
