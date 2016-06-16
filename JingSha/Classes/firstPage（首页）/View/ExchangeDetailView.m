//
//  ExchangeDetailView.m
//  JingSha
//
//  Created by 苹果电脑 on 6/2/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "ExchangeDetailView.h"
#import "SCLAlertView.h"

@implementation ExchangeDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)setModel:(SuppleMsgModel *)model {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 62, 74)];
    imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str(@"%@",model.photo)]]];
    [self addSubview:imgView];
    UILabel *lastLabel = nil;
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 2, i * imgView.size.height / 4 + 5, self.width - imgView.size.width - 10, imgView.frame.size.height / 4)];
        label.tag = i + 100;
        label.font = [UIFont systemFontOfSize:11.0];
        if (label.tag == 100) {
            label.text = model.title;
        } else if (label.tag == 101) {
            label.text = [NSString stringWithFormat:@"数量:%@",model.guige];
        } else {
            if (!model.jiage) {
                model.jiage = @"0元/吨";
            }
            lastLabel = label;
            label.text = [NSString stringWithFormat:@"价格:%@元/吨",model.jiage];
        }
        [self addSubview:label];
    }
    
    UIButton *regiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regiBtn setTitle:@"意向报名" forState:UIControlStateNormal];
    regiBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [regiBtn setBackgroundColor:RGBColor(35, 143, 219) forState:UIControlStateNormal];
    regiBtn.layer.cornerRadius = 11;
    regiBtn.layer.borderWidth = 0.001;
    regiBtn.layer.masksToBounds = YES;
    [regiBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    regiBtn.frame = CGRectMake(CGRectGetMaxX(imgView.frame) + 2,CGRectGetMaxY(lastLabel.frame) + 5 , self.width - imgView.size.width - 20, imgView.frame.size.height / 4 + 5);
    [self addSubview:regiBtn];
}

- (void)clickRegisterBtn {
    [[SCLAlertView sharedInstance] showTitle:@"开发中，喵......" subTitle:nil closeButtonTitle:nil duration:1.5f];
}

@end
