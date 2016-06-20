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

#import "RequestDetailViewController.h"
#import "SupplyDetailViewController.h"
#import "JSLastRequestDetailCell.h"
#import "SingUpViewController.h"

@interface FirstPageViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HeadViewTableViewCellDelegate,

SPLatestRequestcellDelegate,
SPHotProductCellDelegata,
SPExchangeCenterDelegate,
JSLasterRequestDetailCellDelegate
//
//TotalProviderTableViewCellDelegate,
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
@property (nonatomic, assign) NSInteger NewBuyCount;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBaoJiaBtn:) name:@"BaoJia" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BaoJia" object:nil];
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
    @WeakObj(self);
    [[HttpClient sharedClient] getFirstPageInfoComplecion:^(id resoutObj, NSError *error) {
        @StrongObj(self)
        if (error) {
            MyLog(@"首页数据加载错误信息%@", error);
        } else {
            [Strongself getDataFromResponseObj:resoutObj];
            [Strongself.contentTableView.header endRefreshing];
        }
    }];
}

/**
 *  分解取得的数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    NSDictionary * dict  = responseObj[@"data"];
    self.read = dict[@"read"];
    NSArray * newProAry = dict[@"newpro"];
    NSArray *newBuyArr = dict[@"newbuy"];
    self.NewProCount = newProAry.count;
    self.NewBuyCount = newBuyArr.count;
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
//    firstPageSearchVC.fd_prefersNavigationBarHidden = YES;//用这个方法保证push之后，导航栏会隐藏而且时机正好
    [self.navigationController pushViewController:firstPageSearchVC animated:YES];
    
}
#pragma mark -- HeadViewTableViewCell的代理
//轮播图上的搜索按钮 -- searchBtn 点击之后调用方法
- (void)handlePushToSearchWithSender:(UIButton *)sender{
    [self handlePuthAllSelectedWith:sender];
}
- (void)clickedWantBuyViewToPush:(NSString *)sender{
    RequestViewController  *requestVC = [[RequestViewController alloc] init];
    [self.navigationController pushViewController:requestVC animated:YES];
}
- (void)clickedSuperMarketViewToPush:(NSString *)sender{
    SuperMarketViewController * superMarketVC = [[SuperMarketViewController alloc] init];
    [self.navigationController pushViewController:superMarketVC animated:YES];
}
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
/**
 *  cell代理
 *
 *  @param model 传入数据
 */
- (void)pushToDetailPageVC:(RequestMsgModel *)model{
    RequestDetailViewController * requestDetailVC = [[RequestDetailViewController alloc] init];
    requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.Id, KUserImfor[@"userid"]];
    requestDetailVC.Id = model.Id;
    requestDetailVC.shareContent = model.jianjie;
    requestDetailVC.shareTitle = model.title;
    [self.navigationController pushViewController:requestDetailVC animated:YES];
}
/**
 *  报价按钮
 *
 *  @param Id ID
 */
- (void)clickBaoJiaBtn:(NSNotification *)no {
    NSString *id = no.userInfo[@"id"];
    SingUpViewController * singUpVC = [[SingUpViewController alloc] init];
    singUpVC.Id = id;
    [self.navigationController pushViewController:singUpVC animated:YES];
}

#pragma mark - SPHotProductCellDelegata
//热门推荐more按钮
- (void)HotProductMoreBtnClick:(id)sender {
    
    MoreRecommendViewController * moreRecommendVC = [[MoreRecommendViewController alloc] init];
//    moreRecommendVC.fd_prefersNavigationBarHidden = YES;
    [self.navigationController pushViewController:moreRecommendVC animated:YES];
}

- (void)pushToDetailVCFromCell:(NSString *)string {
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@",string, KUserImfor[@"userid"]];
    supplyVC.chanpinId = string;
    [self.navigationController pushViewController:supplyVC animated:YES];
}

#pragma mark - SPExchagneCellDelegate
//交易中心more按钮
- (void)exchangeMoreBtnClick {
    SuperMarketViewController * superMarketVC = [[SuperMarketViewController alloc] init];
    [self.navigationController pushViewController:superMarketVC animated:YES];
}

-(void)putIntoExchangeDetail:(NSString *)Id {
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", Id, KUserImfor[@"userid"]];
    supplyVC.chanpinId = Id;
    [self.navigationController pushViewController:supplyVC animated:YES];
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
    if (indexPath.section == 0) {
        return 180 * KProportionHeight;
    }
    else if(indexPath.section == 1){
        return 160 * KProportionHeight;
    } else if(indexPath.section == 2) {
        return 45 + self.NewBuyCount * 90 * KProportionHeight;
    }else {
        if (self.NewProCount <= 3) {
            return 261 * KProportionHeight * 1/2;
        }
        if (self.NewProCount > 3 && self.NewProCount <= 6) {
            return 261 * KProportionHeight;
        }
        return 261 * KProportionHeight * 3/2;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
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
            SPExchangeCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithExchangeCenter forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
        case 2:
        {
            SPLatestRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithLatesRequest forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中时的颜色 无
            cell.delegate = self;
            return cell;
            
        }
        default:
        {
            SPHotProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWithHotProduct forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
    }
}


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
    CGFloat scrollViewY = (float)scrollView.contentOffset.y;
    if (scrollViewY > 180 * KProportionHeight) {
        //该显示在上边
        self.navigationItem.titleView = _secondSearchBtn;
    }else{
        self.navigationItem.titleView = nil;
    }
    
}

@end
