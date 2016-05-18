//
//  AttentionCollectionViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/15.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttentionCollectionViewCellDelegate <NSObject>
- (void)pushToDetailVC:(NSString *)string;

@end

@interface AttentionCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UITableView *baseTable;

@property (nonatomic, strong)NSMutableArray * ary;
@property (nonatomic, assign)NSInteger rowCount;
@property (nonatomic, weak)id<AttentionCollectionViewCellDelegate>delegate;


@property (nonatomic, copy)NSString * searchText;
@end
