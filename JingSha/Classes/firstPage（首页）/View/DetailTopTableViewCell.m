//
//  DetailTopTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "DetailTopTableViewCell.h"
#import "SDCycleScrollView.h"
@interface DetailTopTableViewCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic, strong)SDCycleScrollView * sdCycleScrollView;
@end
@implementation DetailTopTableViewCell

- (void)awakeFromNib {
    [self.topView addSubview:self.sdCycleScrollView];
}
#pragma mark --Lazy Laoding
-(SDCycleScrollView *)sdCycleScrollView{
    if (!_sdCycleScrollView) {
        self.sdCycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, self.size.height)];
        _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdCycleScrollView.autoScrollTimeInterval = 2;//滚动时间,默认1秒
        _sdCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _sdCycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _sdCycleScrollView.delegate = self;
        //配置图片
        [self configerData];
    }
    return _sdCycleScrollView;
}
- (void)configerData{
    //轮播图片
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w=400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    //文字
    NSArray *titles = @[@"1",
                        @"2",
                        @"3",
                        @"4"
                        ];
    _sdCycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _sdCycleScrollView.titlesGroup = titles;
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MyLog(@"点击了第%ld张图片",index);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(topImageClick:title:)]) {
//        //        NSLog(@"&*&*&*&&*%@", self.albumIdAry);
//        NSNumber * str = [self.albumIdAry objectAtIndex:index];
//        NSString * titles = [self.titlesArray objectAtIndex:index];
//        [self.delegate topImageClick:str title:titles];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
