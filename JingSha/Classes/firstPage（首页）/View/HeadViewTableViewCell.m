//
//  HeadViewTableViewCell.m
//  
//
//  Created by bocweb on 15/11/12.
//    
//

#import "HeadViewTableViewCell.h"
#import "SDCycleScrollView.h"

//#define KTableHeaderViewHeight (300 * KProportionWidth)
#define KSDCycleScrollViewHeight (180 * KProportionHeight)
#define KSearchBarHeight (40 * KProportionHeight)
#define KShoppingheight (41 * KProportionHeight)
#define KSearchBtnTag 1000
#define KSecondBtnTag 2000
@interface HeadViewTableViewCell () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *wantBuyView;
@property (weak, nonatomic) IBOutlet UIView *superMarketView;
//
@property (nonatomic, strong)NSMutableArray * bannerDataAry;
@end


@implementation HeadViewTableViewCell

- (void)awakeFromNib {
//    UITapGestureRecognizer *WantBuyTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wantBuyViewClicked)];
//    [self.wantBuyView addGestureRecognizer:WantBuyTapGesture];
//    UITapGestureRecognizer *SuperMarketTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superMarketViewClicked)];
//    [self.superMarketView addGestureRecognizer:SuperMarketTapGesture];
    
    [self loadHomePageData];
}

/**
 *  加载首页数据
 */
- (void)loadHomePageData{
    NSString * netPath = @"pro/home_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"首页数据%@", responseObj);
        [self getDataFromResponseObj:responseObj];
        [self configureData];
    } failure:^(NSError *error) {
        MyLog(@"首页数据加载错误信息%@", error);
    }];
}

/**
 *  分解取得的数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    NSDictionary * dict  = responseObj[@"data"];
    self.bannerDataAry = [NSMutableArray array];
    for (NSDictionary * smallDict in dict[@"banlist"]) {
        BannerModel * model = [BannerModel objectWithKeyValues:smallDict];
        [self.bannerDataAry addObject:model];
    }
}


//- (void)wantBuyViewClicked{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedWantBuyViewToPush:)]) {
//        [self.delegate clickedWantBuyViewToPush:@"点击了求购信息，对应API"];
//    }
//}
//
//- (void)superMarketViewClicked{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedSuperMarketViewToPush:)]) {
//        [self.delegate clickedSuperMarketViewToPush:@"点击了纤维市场，对应API"];
//    }
//}

//配置滚动视图
- (void)configureData {
    //轮播图片
    NSMutableArray *imagesURLs = [NSMutableArray new];
    for (int i = 0; i < self.bannerDataAry.count; i++) {
        [imagesURLs addObject:[self.bannerDataAry[i] photo]];
    }
    NSArray * imagesURLStrings = [NSArray arrayWithArray:imagesURLs];
    //文字
    
    //添加版图
     self.sdcycleScroll = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, KSDCycleScrollViewHeight)];
    _sdcycleScroll.placeholderImage = [UIImage imageNamed:@"NetBusy"];
    _sdcycleScroll.imageURLStringsGroup = imagesURLStrings;
//    _sdcycleScroll.titlesGroup = titles;
    _sdcycleScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdcycleScroll.delegate = self;
    _sdcycleScroll.isButtomTitleLabel = NO;
    _sdcycleScroll.dotColor = [UIColor whiteColor];
    _sdcycleScroll.titleLabelTextColor = RGBColor(35, 35, 35);
    _sdcycleScroll.pageControlDotSize = CGSizeMake(5, 5);
    _sdcycleScroll.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];
    _sdcycleScroll.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    [self.headView addSubview:_sdcycleScroll];
    //添加搜索框 -- 图片！！！
    _searchBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth * 0.075, CGRectGetMaxY(_sdcycleScroll.frame) - KSearchBarHeight - 20, kUIScreenWidth * 0.85, KSearchBarHeight)];
    _searchBarBtn.layer.cornerRadius = 5;
    [_searchBarBtn setTitle:@"请输入产品/企业/求购" forState:UIControlStateNormal];
    _searchBarBtn.alpha = 0.9;
    [_searchBarBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _searchBarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _searchBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _searchBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    _searchBarBtn.backgroundColor = [UIColor whiteColor];
    _searchBarBtn.tag = KSearchBtnTag;
    [_searchBarBtn addTarget:self action:@selector(handelPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:_searchBarBtn];
    //放大镜🔍
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_searchBarBtn.size.width - 30, (_searchBarBtn.size.height - 20)/2, 20, 20)];
    imageView.image = [UIImage imageNamed:@"search"];
    [_searchBarBtn addSubview:imageView];
}

//点击搜索框响应事件
- (void)handelPush:(UIButton *)sender {
    [SingleTon shareSingleTon].selectBag = sender.tag;
    if ([self.delegate respondsToSelector:@selector(handlePushToSearchWithSender:)]) {
        [self.delegate handlePushToSearchWithSender:sender];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"---点击了第%zd张图片", index);
//    MyLog(@"%@", [self.bannerDataAry[index] link]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerPush:)]) {
        [self.delegate bannerPush:self.bannerDataAry[index]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
