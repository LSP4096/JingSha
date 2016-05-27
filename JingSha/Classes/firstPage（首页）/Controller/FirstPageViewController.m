//
//  FirstPageViewController.m
//  
//
//  Created by bocweb on 15/11/12.
//
//
#import "FirstPageViewController.h"
#import "XWMemberCenterViewController.h"  //个人中心页面
#import "SDCycleScrollView.h" //滚动第三方框架

#import "HeadViewTableViewCell.h"
//#import "NewProductTableViewCell.h"
//#import "MarketAttentionTableViewCell.h"
//#import "DidAttentionTableViewCell.h"
#import "SPLatestRequestCell.h"
#import "SPHotProductTableViewCell.h"
#import "SPExchangeCenterCell.h"

#import "NewsViewController.h"
#import "RequestViewController.h"
#import "SuperMarketViewController.h"
#import "FirstPageSearchViewController.h"
#define KSearchBtnTag 1000
#define KSecondBtnTag 2000
#import "MoreSupplierViewController.h"
#import "TotalProviderTableViewCell.h"
#import "RecommendDetailViewController.h"
#import "MoreRecommendViewController.h"
#import "AttentionViewController.h"
#import "AttentionDetailViewController.h"
#import "SupplyDetailViewController.h"
#import "BannerViewController.h"
#import "FirstPageAttModel.h"
#import "RKNotificationHub.h"
#import "HuodongViewController.h"
#import "ShangjiaViewController.h"
#import "RecommendDetailViewController.h"
@interface FirstPageViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HeadViewTableViewCellDelegate,

SPLatestRequestcellDelegate,
SPHotProductCellDelegata

//TotalProviderTableViewCellDelegate
//NewProductTableViewCellDelegate,
//DidAttentionTableViewCellDelegate
>

@property (strong, nonatomic) UIView *tableHeadView;

@property (strong, nonatomic) UITableView *contentTableView;
@property (strong, nonatomic) UIButton *secondSearchBtn;
@property (nonatomic, assign) CGFloat lastScrollOffset;

@property (nonatomic, assign) BOOL isSearchBarHiden;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) UIButton * rightTopBut;

@property (nonatomic, strong) TotalProviderTableViewCell *cell;
@property (nonatomic ,strong) NSMutableArray * attentionAry;//例子，实验市场关注里面返回的cell样式和高度
@property (nonatomic, assign) NSInteger NewProCount;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, copy) NSString * read;

//@property (nonatomic, strong) UILabel * titleViewLable;
@end

static NSString *const reuseIdentifierWithHead = @"HeadViewTableViewCell";
//static NSString *const reuseIdentWithNewProdect = @"NewProductTableViewCell";
//static NSString *const reuseIdentifierWithMarketAttention = @"MarketAttentionTableViewCell";
static NSString *const reuseIdentifierWithLatesRequest = @"SPLatestRequestCell";
static NSString *const reuseIdentifierWithHotProduct = @"SPHotProductTableViewCell";
static NSString *const reuseIdentifierWithExchangeCenter = @"SPExchangeCenterCell";

@implementation FirstPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self setupLeftAndRightItem];
    [self refreshFirstPageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTableView];

    [self registeCell];
}

/**
 *  下拉刷新
 */
- (void)refreshFirstPageData{
    [self loadData];
}

/**
 *  加载数据(这里只是为了得出新品推荐的个数，以便确定要显示的高度)
 */
- (void)loadData{
    NSString * netPath = @"pro/home_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"首页新品推荐数据%@\n", responseObj);
        [self getDataFromResponseObj:responseObj];
        [self.contentTableView.header endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"首页数据加载错误信息%@\n", error);
    }];
}

/**
 *  分解取得的数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    NSDictionary * dict  = responseObj[@"data"];
    self.read = dict[@"read"];
    NSArray * newProAry = dict[@"newpro"];
    self.NewProCount = newProAry.count;
    self.pageCount = [dict[@"userlist"] count];
    self.attentionAry = [NSMutableArray array];
    if (![dict[@"guanzhu"] isKindOfClass:[NSNull class]]) {
        for (NSDictionary * smallDict in dict[@"guanzhu"]) {
            FirstPageAttModel * model = [FirstPageAttModel objectWithKeyValues:smallDict];
            [self.attentionAry addObject:model];
        }
    }
    [_contentTableView reloadData];
    [self setupLeftAndRightItem];
}

///左侧和右侧按钮
- (void)setupLeftAndRightItem{
    self.rightTopBut =[UIButton buttonWithType:UIButtonTypeCustom];
    _rightTopBut.frame = CGRectMake(kUIScreenWidth - 40, 40, 20, 20);
//    button.backgroundColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightTopBut];
    [_rightTopBut addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.read isEqualToString:@"1"]) {
        [_rightTopBut setImage:[UIImage imageNamed:@"HomeNews_"] forState:UIControlStateNormal];
    }else{
        [_rightTopBut setImage:[UIImage imageNamed:@"新闻详情-带图_03"] forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightTopBut];
}

//进入消息页面
- (void)rightItemClick {
    [_rightTopBut setImage:[UIImage imageNamed:@"新闻详情-带图_03"] forState:UIControlStateNormal];
    NewsViewController * newsVC = [[NewsViewController alloc] init];
    [self.navigationController pushViewController:newsVC animated:YES];
}

///注册cell
- (void)registeCell {
//    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"system"];
//    [self.contentTableView registerClass:[NewProductTableViewCell class] forCellReuseIdentifier:reuseIdentWithNewProdect];
//    [self.contentTableView registerNib:[UINib nibWithNibName:reuseIdentifierWithMarketAttention bundle:nil] forCellReuseIdentifier:reuseIdentifierWithMarketAttention];
//    [self.contentTableView registerNib:[UINib nibWithNibName:@"TotalProviderTableViewCell" bundle:nil] forCellReuseIdentifier:@"totalCell"];
//    [self.contentTableView registerClass:[DidAttentionTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.contentTableView registerNib:[UINib nibWithNibName:reuseIdentifierWithHead bundle:nil] forCellReuseIdentifier:reuseIdentifierWithHead];
    [self.contentTableView registerNib:[UINib nibWithNibName:reuseIdentifierWithLatesRequest bundle:nil] forCellReuseIdentifier:reuseIdentifierWithLatesRequest];
    [self.contentTableView registerNib:[UINib nibWithNibName:reuseIdentifierWithHotProduct bundle:nil] forCellReuseIdentifier:reuseIdentifierWithHotProduct];
    [self.contentTableView registerNib:[UINib nibWithNibName:reuseIdentifierWithExchangeCenter bundle:nil] forCellReuseIdentifier:reuseIdentifierWithExchangeCenter];
    
}
#pragma mark - tableView
- (void)setupTableView {
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.showsVerticalScrollIndicator = NO;
    self.contentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.contentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstPageData)];
    [self.view addSubview:self.contentTableView];
    
    _secondSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kUIScreenWidth * 0.85,30)];//35 * KProportionHeight
    _secondSearchBtn.layer.cornerRadius = 5;
    [_secondSearchBtn setTitle:@"请输入产品/企业/求购" forState:UIControlStateNormal];
    [_secondSearchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _secondSearchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    _secondSearchBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _secondSearchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_secondSearchBtn.width /2 * KProportionWidth, 0,  0);
    _secondSearchBtn.tag = KSecondBtnTag;
    _secondSearchBtn.backgroundColor = [UIColor whiteColor];
    
    [_secondSearchBtn addTarget:self action:@selector(handlePuthAllSelectedWith:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_secondSearchBtn.size.width - 30, (_secondSearchBtn.size.height - 20)/2, 20, 20)];
    imageView.image = [UIImage imageNamed:@"search"];
    [_secondSearchBtn addSubview:imageView];
}
/**titleView的搜索按钮相应事件 -- secondBtn*/
- (void)handlePuthAllSelectedWith:(UIButton *)sender {
    [SingleTon shareSingleTon].selectBag = sender.tag;
    FirstPageSearchViewController * firstPageSearchVC = [[FirstPageSearchViewController alloc] init];
    firstPageSearchVC.fd_prefersNavigationBarHidden = YES;//用这个方法保证push之后，导航栏会隐藏而且时机正好
    [self.navigationController pushViewController:firstPageSearchVC animated:YES];
    
}
#pragma mark -- HeadViewTableViewCell的代理
//轮播图上的搜索按钮 -- searchBtn 点击之后调用方法
- (void)handlePushToSearchWithSender:(UIButton *)sender{
    [self handlePuthAllSelectedWith:sender];
}
//- (void)clickedWantBuyViewToPush:(NSString *)sender{
//    RequestViewController  *requestVC = [[RequestViewController alloc] init];
//    [self.navigationController pushViewController:requestVC animated:YES];
//}
//- (void)clickedSuperMarketViewToPush:(NSString *)sender{
//    SuperMarketViewController * superMarketVC = [[SuperMarketViewController alloc] init];
//    [self.navigationController pushViewController:superMarketVC animated:YES];
//}
- (void)bannerPush:(BannerModel *)model{
    BannerViewController * bannerVC = [[BannerViewController alloc] init];
    bannerVC.TopTitle = model.title;
    bannerVC.HTMLUrl = model.link;
    if ([model.type isEqualToString:@"2"]) {//1活动2会议3企业推广
        [self.navigationController pushViewController:bannerVC animated:YES];
    }else if([model.type isEqualToString:@"1"]){//1
        HuodongViewController * huoVC = [[HuodongViewController alloc] init];
        huoVC.link = model.link;
        [self.navigationController pushViewController:huoVC animated:YES];
    }else{//3
//        ShangjiaViewController * shangjiaVC = [[ShangjiaViewController alloc] init];
//        shangjiaVC.link = model.link;
        RecommendDetailViewController * recommVC = [[RecommendDetailViewController alloc] init];
        recommVC.qiyeId = model.link;
        [self.navigationController pushViewController:recommVC animated:YES];
    }
}

#pragma mark - SPLatestRequestCell的代理
//最新求购more按钮
- (void)moreBtnClick:(UIButton *)sender {
    RequestViewController  *requestVC = [[RequestViewController alloc] init];
     requestVC.fd_prefersNavigationBarHidden = YES;
    [self.navigationController pushViewController:requestVC animated:YES];
}

#pragma mark - SPHotProductCellDelegata
//热门产品more按钮
- (void)HotProductMoreBtnClick:(id)sender {
    
    MoreRecommendViewController * moreRecommendVC = [[MoreRecommendViewController alloc] init];
//    moreRecommendVC.fd_prefersNavigationBarHidden = YES;
    [self.navigationController pushViewController:moreRecommendVC animated:YES];
}

#pragma mark -－－ UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
//每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 3) {
//        if (self.attentionAry.count != 0) {
//            return self.attentionAry.count;
//        }else{
//            return 1;
//        }
//    }else{
        return 1;
//    }
}
//返回cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 210 * KProportionHeight;
//    }else if (indexPath.section == 1){
//        if (self.NewProCount <= 3) {
//            return 200 * KProportionHeight * 1/2;
//        }
//        if (self.NewProCount > 3 && self.NewProCount <= 6) {
//            return 200 * KProportionHeight;
//        }
//        return 200 * KProportionHeight * 3/2;
//    }else if (indexPath.section == 2){
//        return 300 * KProportionHeight;
//    }else{
//        if (self.attentionAry.count != 0) {
////            FirstPageAttModel * model = self.attentionAry[indexPath.row];
////            NSArray * ary = [model typelist];
//            NSArray * ary = @[];
//            return [DidAttentionTableViewCell callHight:ary];
//        }else{
//            return 150;
//        }
//    }
    if (indexPath.section == 0) {
        return 180 * KProportionHeight;
    }
    else {
//        return 160 * KProportionHeight;
        return 160;
    }
}

//区头视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 35)];
//    headSectionView.backgroundColor = [UIColor whiteColor];
//    //类型
//    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kUIScreenWidth / 4, 25)];
//    typeLabel.font = [UIFont systemFontOfSize:14];
//    [headSectionView addSubview:typeLabel];
//    //more
//    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth - typeLabel.width / 2 - 20, typeLabel.frame.origin.y, typeLabel.width / 2 + 20, 25)];
//    [moreBtn addTarget:self action:@selector(handleMore:) forControlEvents:UIControlEventTouchUpInside];
//    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [headSectionView addSubview:moreBtn];
//    
//    switch (section) {
//        case 1:
//        {
//            typeLabel.text = @"最新求购";
//            typeLabel.textColor = RGBColor(250, 144, 27);
//            [moreBtn setTitle:@"...." forState:UIControlStateNormal];
//            moreBtn.tag = 100;
//            [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        }
//            break;
//        case 2:
//        {
//            typeLabel.text = @"热门产品";
//            typeLabel.textColor = RGBColor(249, 103, 63);
//            [moreBtn setTitle:@"more>" forState:UIControlStateNormal];
//            moreBtn.tag = 200;
//            [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        }
//            break;
//        case 3:
//        {
//            typeLabel.text = @"交易中心";
//            typeLabel.textColor = RGBColor(25, 182, 230);
//            [moreBtn setTitle:@"关注" forState:UIControlStateNormal];
//            moreBtn.tag = 300;
//            [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        }
//            break;
//        default:
//            return nil;
//            break;
//    }
//    return headSectionView;
//}

//区尾
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 2) {
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
//        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
//        NSInteger count = 0;
//        if (self.pageCount >=1 && self.pageCount <= 3) {
//            count = 1;
//        }else if (self.pageCount >= 4 && self.pageCount <= 6){
//            count = 2;
//        }else if (self.pageCount >= 7 && self.pageCount <= 9){
//            count = 3;
//        }else if (self.pageCount >=10 && self.pageCount <= 12){
//            count = 4;
//        }
//        if (count == 1) {
//            self.pageControl.hidden = YES;
//        }
//        _pageControl.numberOfPages = count;
//        _pageControl.currentPage = 0;
//        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
//        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//        [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:_pageControl];
//        return view;
//    }else{
//        return nil;
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return section ? 35 : 0.001;
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 2) {
//        return 30;
//    }else if (section == 3){
//        return 0.001;
//    }else{
//        return 13;
//    }
    if (section == 1||section == 2) {
        return 4;
    } else {
        return 0.001;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HeadViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithHead forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
            break;
            case 1:
        {
//            NewProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentWithNewProdect forIndexPath:indexPath];
            SPLatestRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithLatesRequest forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中时的颜色 无
            cell.delegate = self; 
            return cell;
        }
            break;
        case 2:
        {
//            self.cell = [tableView dequeueReusableCellWithIdentifier:@"totalCell"];
            SPHotProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithHotProduct forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
        default:
        {
//            if (self.attentionAry.count == 0) {//没有关注信息的时候
//                MarketAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithMarketAttention forIndexPath:indexPath];
//                [cell.marketAttentionBut addTarget:self action:@selector(handleCHange:) forControlEvents:UIControlEventTouchUpInside];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//            }else{//有关注的时候显示
//                DidAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//                cell.model = self.attentionAry[indexPath.row];
//                cell.delegate = self;
//                return cell;
//            }
            SPExchangeCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithExchangeCenter forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
}

/**
 *  主页面新品推荐点击事件
 */
//- (void)pushToDetailVCFromCell:(NSString *)string{
//    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
//    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@",string, KUserImfor[@"userid"]];
//    supplyVC.chanpinId = string;
//    [self.navigationController pushViewController:supplyVC animated:YES];
//}
//
///**
// *  已经关注的市场关注的点击事件,跳转到相应的详细界面
// */
//-(void)clickedDidAttention:(id)sender which:(NSInteger)btnTag{
//    AttentionDetailViewController * attentionDetailVC = [[AttentionDetailViewController alloc] init];
////    attentionDetailVC.titleAry = sender;
//    attentionDetailVC.titleName = sender;
//    attentionDetailVC.contsentCount = btnTag - 1000;
//    [self.navigationController pushViewController:attentionDetailVC animated:YES];
//}

/**
 *  点击UIPageController的响应事件。使推荐供应商界面偏移
 */
//- (void)pageChange:(UIPageControl *)sender{
//    [self.cell.baseScrollView setContentOffset:CGPointMake(kUIScreenWidth * sender.currentPage, 0) animated:YES];
//}
#pragma mark -- 执行代理方法
//- (void)changePageNumber:(int)pageNumber{
//    self.pageControl.currentPage = pageNumber;
//}
//
//- (void)pushToDetailPageVC:(NSString *)string{
//    RecommendDetailViewController * recommendDetailVC = [[RecommendDetailViewController alloc] init];
//    recommendDetailVC.qiyeId = string;//代理传过来的企业id
//    [self.navigationController pushViewController:recommendDetailVC animated:YES];
//}
///**点击市场关注 右侧的 关注按钮*/
//- (void)handleCHange:(UIButton *)sender {
//    AttentionViewController * attentionVC = [[AttentionViewController alloc] init];
//    [self.navigationController pushViewController:attentionVC animated:YES];
//}
///**
// * 更多的按钮响应事件
// */
//- (void)handleMore:(UIButton *)sender {
//    if (sender.tag == 100) {
//        MyLog(@"更多新品");
//        MoreRecommendViewController * moreRecommendVC = [[MoreRecommendViewController alloc] init];
////        moreRecommendVC.fd_prefersNavigationBarHidden = YES;
//        [self.navigationController pushViewController:moreRecommendVC animated:YES];
//    } else if (sender.tag == 200) {
//        MyLog(@"更多供应商");
//        MoreSupplierViewController * moreVC = [[MoreSupplierViewController alloc] init];
//        [self.navigationController pushViewController:moreVC animated:YES];
//    } else if (sender.tag == 300) {
//        [self handleCHange:nil];
//    }
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //选中后变回颜色
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 设置分割线
-(void)viewDidLayoutSubviews
{
    if ([self.contentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contentTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.contentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.contentTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    MyLog(@"%f", (float)scrollView.contentOffset.y);
    CGFloat scrollViewY = (float)scrollView.contentOffset.y;
    if (scrollViewY > 180 * KProportionHeight) {
        //该显示在上边
        self.navigationItem.titleView = _secondSearchBtn;
    }else{
//        self.navigationItem.titleView = _titleViewLable;
        self.navigationItem.titleView = nil;
    }
    
}

/*
#pragma mark - tableView上滑隐藏searchBar
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", self.lastScrollOffset);
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat y = scrollView.contentOffset.y;
        HeadViewTableViewCell *cell = (HeadViewTableViewCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (y < self.lastScrollOffset) {
            //屏幕向下滚动
//            MyLog(@"下");
            if (scrollView.contentOffset.y < (180 * KProportionHeight) && scrollView.contentOffset.y > 0 && self.secondSearchBtn.hidden == NO) {
//                MyLog(@"要出现了");
                _isSearchBarHiden = NO;
                POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                opacityAnimation.fromValue = @(0);
                opacityAnimation.toValue = @(1);
                [cell.searchBarBtn.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
                
                POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
                CGPoint pointBtn = cell.searchBarBtn.center;
                positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(187.5 * KProportionWidth, 180*KProportionHeight)];
                positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(pointBtn.x, kNavigationBarHeight - 40 *KProportionHeight)];
                [cell.searchBarBtn.layer pop_addAnimation:positionAnimation forKey:@"opacityAnimation"];
                
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
                scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.1f, 0.1f)];
                [cell.searchBarBtn.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
                
                self.navigationItem.titleView = _secondSearchBtn;
                POPBasicAnimation *opacityAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                opacityAnimation1.fromValue = @(1);
                opacityAnimation1.toValue = @(0);
                [_secondSearchBtn.layer pop_addAnimation:opacityAnimation1 forKey:@"opacityAnimation"];
                
                UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                titleView.text = @"中国纱线网";
                titleView.textColor = [UIColor whiteColor];
                self.navigationItem.titleView = titleView;
            }
            
        } else {
            //向上滚动
//            MyLog(@"上");
//            MyLog(@"要消失了");
            if (scrollView.contentOffset.y > (160 * KProportionHeight) && _isSearchBarHiden == NO) {
                self.secondSearchBtn.hidden = NO;
                POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                opacityAnimation.fromValue = @(1);
                opacityAnimation.toValue = @(0);
                [cell.searchBarBtn.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
                
                POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
                CGPoint pointBtn = cell.searchBarBtn.center;
                positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(187.5*KProportionWidth, 160*KProportionHeight)];
                positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(pointBtn.x, kNavigationBarHeight - 40*KProportionHeight)];
                [cell.searchBarBtn.layer pop_addAnimation:positionAnimation forKey:@"opacityAnimation"];
                
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.1f, 0.1f)];
                [cell.searchBarBtn.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
                _isSearchBarHiden = YES;
                
                self.navigationItem.titleView = _secondSearchBtn;
                POPBasicAnimation *opacityAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                opacityAnimation1.fromValue = @(0);
                opacityAnimation1.toValue = @(1);
                [_secondSearchBtn.layer pop_addAnimation:opacityAnimation1 forKey:@"opacityAnimation"];
                
                POPSpringAnimation *scaleAnimation1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation1.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.1f, 0.1f)];
                scaleAnimation1.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
                [self.secondSearchBtn.layer pop_addAnimation:scaleAnimation1 forKey:@"scaleAnimation"];
            }
        }
        self.lastScrollOffset = y;

    }
}
*/
@end
