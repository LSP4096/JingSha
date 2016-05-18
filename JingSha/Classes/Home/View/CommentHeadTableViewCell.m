//
//  CommentHeadTableViewCell.m
//  
//
//  Created by bocweb on 15/11/13.
//
//

#import "CommentHeadTableViewCell.h"

@interface CommentHeadTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *columnLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end


@implementation CommentHeadTableViewCell
- (void)configureDataWithDic:(NSDictionary *)dic {
    self.titleLabel.text = dic[@"title"];
    self.columnLabel.text = dic[@"cid"];
    self.sourceLabel.text = dic[@"source"];
    self.authorLabel.text = dic[@"author"];
    self.timeLabel.text = dic[@"time"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
