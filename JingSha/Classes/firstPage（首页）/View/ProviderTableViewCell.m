//
//  ProviderTableViewCell.m
//  
//
//  Created by bocweb on 15/11/23.
//
//

#import "ProviderTableViewCell.h"

@interface ProviderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoView;//logo
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end


@implementation ProviderTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(RecommendSupplyModel *)model{
    _model = model;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:_model.logo] placeholderImage:[UIImage imageNamed:@"网络暂忙-193-133"] completed:nil];
    
//    CGRect rect = [_model.gongsi boundingRectWithSize: CGSizeMake([[UIScreen mainScreen] bounds].size.width - 240, 0)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
//    self.NameLabel.frame = CGRectMake(self.NameLabel.x, self.NameLabel.y, self.NameLabel.width, rect.size.height);
//    CGRect frame = self.contentLabel.frame;
//    self.contentLabel.y = 10 + rect.size.height + 3;
//    self.contentLabel.frame = frame;
    
    
    self.NameLabel.text = _model.gongsi;
    self.addressLabel.text = _model.zcd;
    self.contentLabel.text = [NSString stringWithFormat:@"主营产品:%@", _model.zycp];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
