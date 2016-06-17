//
//  JSLastRequestDetailCell.m
//  JingSha
//
//  Created by 苹果电脑 on 6/8/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "JSLastRequestDetailCell.h"
@interface JSLastRequestDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleW;
@property (weak, nonatomic) IBOutlet UILabel *zhisu;
@property (weak, nonatomic) IBOutlet UILabel *requestCount;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (nonatomic, strong) NSString *Id;

@end

@implementation JSLastRequestDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.priceBtn.layer.cornerRadius = 11;
    self.priceBtn.layer.borderWidth = 0.001;
    self.priceBtn.layer.masksToBounds = YES;
    
    self.imgView.layer.cornerRadius = 12;
    self.imgView.layer.borderWidth = 0.001;
    self.imgView.layer.masksToBounds = YES;
}

-(void)setModel:(RequestMsgModel *)model {
    self.title.text = model.title;
    CGSize size = [model.title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    if (size1.width > kUIScreenWidth / 3) {
        size1.width = kUIScreenWidth / 3;
    }
    _titleW.constant = size1.width;
    
    self.zhisu.text = model.zhisu;
    if (IsStringEmpty(model.num)) {
        self.requestCount.text = @"电议";
    } else {
        self.requestCount.text = model.num;
    }
    
    self.place.text = @"暂无";
    self.time.text = model.time;
    self.Id = model.Id;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickPriceBtn:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaoJia" object:nil userInfo:@{@"id":self.Id}];
}

@end
