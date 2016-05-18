//
//  MyCommentViewController.m
//  
//
//  Created by bocweb on 15/11/19.
//
//

#import "MyCommentViewController.h"
#import "XWNewsModel.h"
#import "MyCommentTableViewCell.h"
#import "XWNewsDetailViewController.h"
#import "MemberEditViewController.h"
#define kPage 1
#define kEachPageCount 10
@interface MyCommentViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, MyCommentTableViewCellDelegate>
{
    NSInteger _currentPage;
}
@property (nonatomic, strong) NSMutableArray *arrList;
@property (nonatomic, strong) UITableView *contentTableView;
@end
static NSString *const MyCommentCellIdentifier = @"MyCommentTableViewCell";
@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评论";
    self.arrList = [NSMutableArray array];
    [self setupTableView];
    [self configureData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataListWithPage:_currentPage];
}
- (void)setupTableView {
    self.contentTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.emptyDataSetDelegate = self;
    _contentTableView.emptyDataSetSource = self;
    _contentTableView.estimatedRowHeight = 200;
    [self.view addSubview:_contentTableView];
    //注册cell
    [_contentTableView registerNib:[UINib nibWithNibName:MyCommentCellIdentifier bundle:nil] forCellReuseIdentifier:MyCommentCellIdentifier];
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCommentCellIdentifier];
//
    XWNewsModel *model = self.arrList[indexPath.section];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGFloat height = [model.content boundingRectWithSize:CGSizeMake(cell.contentLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    CGRect frame = cell.contentLabel.frame;
    frame.size.height = height;
    cell.contentLabel.frame = frame;
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCommentCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.newsModel = self.arrList[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - MyCommentTableViewCellDelegate
- (void)handlePushDetailWithSendUrl:(NSString *)str {
    XWNewsDetailViewController *detailVC = [[XWNewsDetailViewController alloc] init];
    detailVC.sendUrlStr = str;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)handleEditWithSendDic:(NSDictionary *)dic {
    MemberEditViewController *editVC = [[MemberEditViewController alloc] initWithNibName:@"MemberEditViewController" bundle:nil];
    editVC.sendDic = dic;
    [self.navigationController pushViewController:editVC animated:YES];
}
#pragma mark - 无数据时显示
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无评论记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}
//配置数据
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

- (void)loadMoreDataList
{
    [self loadDataListWithPage:_currentPage + 1];
}
- (void)loadDataListWithPage:(NSInteger)page {
    NSString *netPath = @"userinfo/my_pinglun_list";
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(page) forKey:@"page"];
    [allParams setObject:@(kEachPageCount) forKey:@"pagecount"];
    
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
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
    
    NSArray *arrList = responseObj[@"data"];
    for (NSDictionary *dict in arrList) {
        XWNewsModel *model = [XWNewsModel xwnewModelWithDictionary:dict];
    [self.arrList addObject:model];
    }
    [self.contentTableView reloadData];
    
    //判断是否要添加上拉加载
    NSInteger loadCount = kEachPageCount * (page - 1) + arrList.count;
    MyLog(@"%zd", loadCount);
    if (totalCount > loadCount && !self.contentTableView.footer) {
        self.contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataList)];
    }else if(totalCount == loadCount){
        self.contentTableView.footer = nil;
    }
}
- (void)downRefresh {
    self.contentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataList)];
}

@end
