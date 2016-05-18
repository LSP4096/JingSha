//
//  ContentTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 16/1/19.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
@protocol ContentTableViewCellDelegate <NSObject>

- (void)textViewChanged:(MyTextView *)sender;

@end

@interface ContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MyTextView *textview;
@property (nonatomic, assign)id<ContentTableViewCellDelegate>delegate;
@end
