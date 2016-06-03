//
//  WantBuyTableViewCell.h
//  JingSha
//
//  Created by 苹果电脑 on 6/3/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMsgModel.h"
@interface WantBuyTableViewCell : UITableViewCell

@property (nonatomic, strong)RequestMsgModel * model;

@property (nonatomic, assign)BOOL myBaojia;

@end
