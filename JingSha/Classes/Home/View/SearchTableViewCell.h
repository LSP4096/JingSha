//
//  SearchTableViewCell.h
//  JingSha
//
//  Created by BOC on 15/11/9.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *firstBrn;

@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
- (void)configureDataWithArray:(NSArray *)array;


@end
