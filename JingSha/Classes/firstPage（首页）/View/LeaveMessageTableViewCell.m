//
//  LeaveMessageTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/15.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "LeaveMessageTableViewCell.h"

@interface LeaveMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIView *backView;
@end


@implementation LeaveMessageTableViewCell

- (void)awakeFromNib {
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 3;
}

- (void)setModel:(LeaveMesModel *)model{
    _model = model;
    self.titleLable.text = _model.leftTitle;
    if (_model.contentText == nil || [_model.contentText isKindOfClass:[NSNull class]] || _model.contentText.length == 0) {
        
    }else{
        self.contentField.text = _model.contentText;
    }
    
    if ([self.titleLable.text isEqualToString:@"公司名称:"]) {
        self.contentField.userInteractionEnabled = NO;
        self.backView.backgroundColor = RGBColor(219, 219, 219);
    }
}

@end
