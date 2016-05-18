//
//  MessageContentTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MessageContentTableViewCell.h"
#import "MyLable.h"
@interface MessageContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet MyLable *messageContentLable;


@end

@implementation MessageContentTableViewCell

- (void)awakeFromNib {
    
    self.answerButton.layer.masksToBounds = YES;
    self.answerButton.titleLabel.numberOfLines = 0;
    self.answerButton.layer.cornerRadius = 5;
    [self.messageContentLable setVerticalAlignment:VerticalAlignmentTop];
}
- (IBAction)answerMessage:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(answerMessage)]) {
        [self.delegate answerMessage];
    }
}

-(void)setModel:(MessageModel *)model{
    _model = model;
    CGRect rect = [_model.title boundingRectWithSize: CGSizeMake(kUIScreenWidth - 75, 0)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height < 70) {
        self.messageContentLable.frame = CGRectMake(15, 15, kUIScreenWidth - 75,70);
    }else{
    self.messageContentLable.frame = CGRectMake(15, 15, kUIScreenWidth - 75, rect.size.height);
    }
    self.messageContentLable.text = _model.title;
}

+ (CGFloat)callHight:(NSString *)contentString{
    CGRect rect = [contentString boundingRectWithSize: CGSizeMake(kUIScreenWidth - 75, 0)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    if (rect.size.height < 70) {
        return 70 + 40;
    }else{
        return rect.size.height + 40;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
