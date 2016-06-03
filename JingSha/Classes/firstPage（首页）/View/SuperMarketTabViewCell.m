//
//  SuperMarketTabViewCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/31/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SuperMarketTabViewCell.h"

@interface SuperMarketTabViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *productPlace;
@property (weak, nonatomic) IBOutlet UILabel *pliceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SuperMarketTabViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.signBtn.layer.cornerRadius = 6;
    self.signBtn.layer.borderWidth = 0.001;
    self.signBtn.layer.masksToBounds = YES;
    
}

- (void)setModel:(SuppleMsgModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
    self.productPlace.text = model.zcd;
    self.numLabel.text = model.zhisu;
    self.pliceLabel.text = [NSString stringWithFormat:@"￥%@",_model.jiage];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)signBtnClick:(id)sender {
    MyLog(@"sign");
}

@end
