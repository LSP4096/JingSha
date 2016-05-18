//
//  WantBuyTableViewCell.h
//  JingSha
//
//  Created by 周智勇 on 15/12/2.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMsgModel.h"
@interface WantBuyTableViewCell : UITableViewCell

@property (nonatomic, strong)RequestMsgModel * model;

@property (nonatomic, assign)BOOL myBaojia;
@end
