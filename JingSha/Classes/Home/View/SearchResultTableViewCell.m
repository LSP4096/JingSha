//
//  SearchResultTableViewCell.m
//  
//
//  Created by bocweb on 15/11/10.
//
//

#import "SearchResultTableViewCell.h"

@interface SearchResultTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end



@implementation SearchResultTableViewCell


- (void)configureDataWithModel:(SearchModel *)model
                   inputString:(NSString *)string {
    //使文字变红
    NSString *tit = model.title;
    NSRange range =[tit rangeOfString:string];
    NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:tit];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.titleLabel.attributedText = str1;
    self.timeLabel.text = model.time;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
