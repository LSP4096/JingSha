//
//  CommentContentTableViewCell.m
//  
//
//  Created by bocweb on 15/11/13.
//
//

#import "CommentContentTableViewCell.h"

@interface CommentContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avartView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;


@property (nonatomic, copy) NSString *pid;

@end


@implementation CommentContentTableViewCell
- (void)setModel:(CommentModel *)model {
    _model = model;
    [self.avartView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"]];
    _avartView.layer.cornerRadius = _avartView.height / 2;
    _avartView.layer.masksToBounds = YES;
    self.userNameLabel.text = model.username;
    self.timeLabel.text = model.time;
    self.zanLabel.text = model.zan;
    self.contentLabel.text = model.title;
    _pid = model.pid;
}
- (IBAction)handleZan:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sendCommentPid:)]) {
        [self.delegate sendCommentPid:_pid];
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
