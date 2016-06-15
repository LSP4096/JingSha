//
//  SuperMarketTabViewCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/31/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SuperMarketTabViewCell.h"
#import "SCLAlertView.h"

@interface SuperMarketTabViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *pliceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *cntView;

@end

@implementation SuperMarketTabViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cntView.layer.cornerRadius = 5;
    self.cntView.layer.borderWidth = 0.001;
    self.cntView.layer.masksToBounds = YES;
    
    self.signBtn.layer.cornerRadius = 6;
    self.signBtn.layer.borderWidth = 0.001;
    self.signBtn.layer.masksToBounds = YES;
    
}

- (void)setModel:(SuppleMsgModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
    self.numLabel.text = model.zhisu;
    self.pliceLabel.text = [NSString stringWithFormat:@"￥%@",_model.jiage];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)signBtnClick:(id)sender {
    [[SCLAlertView sharedInstance] showTitle:@"开发中，喵......" subTitle:nil closeButtonTitle:nil duration:1.f];
}

@end
