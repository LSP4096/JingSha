//
//  MessageContentTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@protocol MessageContentTableViewCellDelegate <NSObject>

- (void)answerMessage;

@end
@interface MessageContentTableViewCell : UITableViewCell

@property (nonatomic, assign)id<MessageContentTableViewCellDelegate>delegate;
@property (nonatomic, strong)MessageModel * model;
//@property (nonatomic, copy)NSString * contentString;

+ (CGFloat)callHight:(NSString *)contentString;
@end
