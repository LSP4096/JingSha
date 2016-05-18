//
//  CompanyInfoViewController.m
//  
//
//  Created by bocweb on 15/11/24.
//
//

#import "CompanyInfoViewController.h"
#import "PublicTableViewCell.h"

#define kPage 1
#define kEachPageCount 10
#define KCollectionBtnHeight 45
#define KsmallBGLabelHeight 2
#define KBGColor RGBColor(235, 235, 235)
#define KSepralColor RGBColor(226, 226, 226)
static NSString *const reuseIdentifier = @"PublicTableViewCell";
@interface CompanyInfoViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _currentPage;
}
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *arrList;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *smallBGLabel;
@end

@implementation CompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"企业信息";
    self.view.backgroundColor = KBGColor;
    [self setupTableView];
    [self setupCompanyTypeBtn];
    [self configureData];
}
/*在选择第三个按钮的是时候调用*/
- (void)setupTableView {
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + KCollectionBtnHeight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - KCollectionBtnHeight) style:UITableViewStyleGrouped];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.backgroundColor = KBGColor;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    //内容为空的时候tableView显示
    _contentTableView.emptyDataSetDelegate = self;
    _contentTableView.emptyDataSetSource = self;
    
    [self.view addSubview:_contentTableView];
    
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"system"];
    [self.contentTableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}
/**DZNEmptyDataSetDelegate, DZNEmptyDataSetSource*/
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}
///请求数据
- (void)configureData {
    [self refreshDataList];
    [self downRefresh];
}
#pragma mark - 下拉刷新 ，上拉加载
- (void)refreshDataList
{
    [self loadNewDataList];
}

- (void)loadNewDataList
{
    [self loadDataListWithPage:1];
}

- (void)loadMoreDataListWithPage:(NSInteger)page
{
    [self loadDataListWithPage:_currentPage + 1];
}
- (void)loadDataListWithPage:(NSInteger)page {
    if (self.selectBtn.tag == 1000 || self.selectBtn.tag == 1001) {
        self.arrList = nil;
        [self.contentTableView reloadData];
        return;
    }
    NSString *netPath = @"userinfo/shoucan_list";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:[SingleTon shareSingleTon].userInformation[@"userid"] forKey:@"userid"];
    [allParameters setObject:@(page) forKey:@"page"];
    [allParameters setObject:@(kEachPageCount) forKey:@"pagecount"];
    
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        
        [self.contentTableView.header endRefreshing];
        [self.contentTableView.footer endRefreshing];
        [self reloadDataWithPage:page responseObj:responseObj];
    } failure:^(NSError *error) {
        [self.contentTableView.header endRefreshing];
        [self.contentTableView.footer endRefreshing];
    }];
    
}
- (void)reloadDataWithPage:(NSInteger)page responseObj:(NSDictionary *)responseObj {
    _currentPage = page;
    NSInteger totalCount = [responseObj[@"total"] integerValue];
    if (page == 1) { //下拉刷新
        self.arrList = [NSMutableArray array];
    }
    
//    NSArray *arrList = responseObj[@"data"];
//    for (NSDictionary *dict in arrList) {
//        XWNewsModel *model = [XWNewsModel xwnewModelWithDictionary:dict];
//        [self.arrList addObject:model];
//    }
//    [self.contentTableView reloadData];
    
    //判断是否要添加上拉加载
//    NSInteger loadCount = kEachPageCount * (page - 1) + _arrList.count;
//    MyLog(@"%zd", loadCount);
//    if (totalCount > loadCount && !self.contentTableView.footer) {
//        self.contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataListWithPage:)];
//    }else if(totalCount == loadCount){
//        self.contentTableView.footer = nil;
//    }
}
- (void)downRefresh {
    self.contentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataList)];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *typeArray = @[@"联 系 人 ：",@"部门职位：",@"电\t话：",@"传\t真：",@"手\t机：",@"邮\t箱：",@"QQ：",@"地\t址："];
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = KBGColor;
    if (indexPath.row == 0) {
        cell.topView.backgroundColor = KBGColor;
        cell.bottomView.backgroundColor = KSepralColor;
    } else {
        cell.topView.backgroundColor = KSepralColor;
       cell.bottomView.backgroundColor = KSepralColor;
    }
    cell.typeLabel.text = typeArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*企业信息切换按钮*/
- (void)setupCompanyTypeBtn {
    NSArray *titleArray = @[@"企业介绍", @"认证信息", @"联系方式"];
    CGFloat btnY = kNavigationBarHeight;
    CGFloat btnW = kUIScreenWidth / 3;
    CGFloat btnH = KCollectionBtnHeight;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        btn.backgroundColor = RGBColor(249, 249, 249);
        [btn addTarget:self action:@selector(handleChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = KBGColor.CGColor;
        btn.adjustsImageWhenHighlighted = NO;
        btn.adjustsImageWhenDisabled = NO;
        btn.tag = 1000+i;
        [self.view addSubview:btn];
        
        //默认显示资讯收藏
        if (i == 2) {
            self.selectBtn = btn;
            btn.backgroundColor = KBGColor;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btnW * i, kNavigationBarHeight, btnW, KsmallBGLabelHeight)];
            label.backgroundColor = RGBColor(255, 145, 0);
            [self.view addSubview:label];
            self.smallBGLabel = label;
        }
    }
}
///收藏按钮响应事件
- (void)handleChange:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [self rotate:sender];
    _smallBGLabel.transform = CGAffineTransformIdentity;
    sender.selected = !sender.selected;
    if (sender != self.selectBtn) {
        sender.backgroundColor = KBGColor;
        self.selectBtn.backgroundColor = RGBColor(249, 249, 249);
        self.selectBtn = sender;
    }
    [self loadNewDataList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}
#pragma mark - 旋转动画
- (void)rotate:(UIButton *)sender {
    CGPoint point = sender.center;
    self.smallBGLabel.frame = CGRectMake(sender.frame.origin.x, kNavigationBarHeight, sender.frame.size.width, KsmallBGLabelHeight);
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    spring.velocity = [NSValue valueWithCGPoint:point];
    [_smallBGLabel.layer pop_addAnimation:spring forKey:@"rotationAnimation"];
}
/**
 *  分割线
 */
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
@end
