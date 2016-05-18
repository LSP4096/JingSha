//
//  HelpAnswerViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/28.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "HelpAnswerViewController.h"

@interface HelpAnswerViewController ()

@property (nonatomic, strong)UILabel * contentLable;
@end

@implementation HelpAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"帮助详情";
    [self.view addSubview:self.contentLable];
}
- (UILabel *)contentLable{
    if (_contentLable == nil) {
        self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10, kNavigationBarHeight + 10, kUIScreenWidth - 20, 200)];
        _contentLable.font = [UIFont systemFontOfSize:15];
//        _contentLable.backgroundColor = [UIColor yellowColor];
        _contentLable.numberOfLines = 0;
        _contentLable.layer.masksToBounds = YES;
        _contentLable.layer.borderWidth = 1;
        _contentLable.layer.borderColor = RGBColor(240, 240, 240).CGColor;
        _contentLable.layer.cornerRadius = 5;
    }
    return _contentLable;
}

-(void)setContentString:(NSString *)contentString{
    _contentString = contentString;
    CGRect rect = [_contentString boundingRectWithSize:CGSizeMake(kUIScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    self.contentLable.frame = CGRectMake(10, kNavigationBarHeight + 10, kUIScreenWidth - 20, rect.size.height);
    self.contentLable.text = [NSString stringWithFormat:@"\t%@", [self subStringWithContentString:_contentString]];
}
- (NSString *)subStringWithContentString:(NSString *)string{
    NSRange range = {3, _contentString.length - 7};
    NSString * newStr = [string substringWithRange:range];
    return newStr;
}



@end
