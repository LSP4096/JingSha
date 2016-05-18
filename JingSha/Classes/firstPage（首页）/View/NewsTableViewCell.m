//
//  NewsTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *proTieleLable;
@property (weak, nonatomic) IBOutlet UILabel *yuanyinLable;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = RGBColor(229, 229, 229).CGColor;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
}

- (void)setModel:(NewsModel *)model{
    _model = model;
    self.timeLable.text = _model.time;
    self.titleLable.text = _model.title;
    self.proTieleLable.text = _model.protitle;
//    self.contentLable.text = _model.content;
    self.yuanyinLable.text = _model.yuanyin;
//    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_model.] placeholderImage:<#(UIImage *)#> completed:<#^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)completedBlock#>]
}

- (IBAction)playTelPhone:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0571-57579788"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}




@end
