//
//  ExchangeDetailView.m
//  JingSha
//
//  Created by 苹果电脑 on 6/2/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "ExchangeDetailView.h"

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
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, i * self.height / 5, self.width - 5, self.height / 5)];
        label.tag = i + 100;
        label.font = [UIFont systemFontOfSize:11.0];
        if (label.tag == 100) {
            label.text = model.title;
        } else if (label.tag == 101) {
            label.text = [NSString stringWithFormat:@"产地:%@",model.zcd];
        } else if (label.tag == 102) {
            label.text = [NSString stringWithFormat:@"价格:%@",model.jiage];
        } else if (label.tag == 103) {
            label.text = [NSString stringWithFormat:@"数量:%@",model.guige];
        } else {
            if (!model.time) {
                model.time = @"2016-6-1";
            }
            label.text = [NSString stringWithFormat:@"时间:%@",model.time];
        }
        
        [self addSubview:label];
    }
}

@end
