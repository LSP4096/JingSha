//
//  JSLastRequestDetailCell.h
//  JingSha
//
//  Created by 苹果电脑 on 6/8/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMsgModel.h"

@protocol JSLasterRequestDetailCellDelegate <NSObject>

- (void)clickBaoJiaBtn:(id)Id;

@end
@interface JSLastRequestDetailCell : UITableViewCell

@property (nonatomic, strong) RequestMsgModel *model;
@property (nonatomic, strong) id <JSLasterRequestDetailCellDelegate> delegate;

@end
