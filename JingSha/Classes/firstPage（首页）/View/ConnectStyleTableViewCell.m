//
//  ConnectStyleTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ConnectStyleTableViewCell.h"

@interface ConnectStyleTableViewCell  ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@end

@implementation ConnectStyleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ConnectModel *)model{
    _model = model;
    self.titleLabel.text = _model.titleStr;
    if (![_model.contentStr isKindOfClass:[NSNull class]]) {
        
        self.contentLable.text = _model.contentStr;
    }
}


@end
