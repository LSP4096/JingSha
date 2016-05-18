//
//  RequestViewController.m
//  
//
//  Created by bocweb on 15/11/12.
//
//

#import "RequestViewController.h"
#import "JingSha-Prefix.pch"
#import "MyQuotedViewController.h"
#import "WantBuyTableViewCell.h"
#import "RequestDetailViewController.h"//H5页面，这个用不着了
#import "RequestMsgModel.h"
 #import "UIScrollView+EmptyDataSet.h"
#import "IssueRequestViewController.h"
#define kTopViewHeight 65
#define kPageCount 15
@interface RequestViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong)UISearchBar * searchBar;
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, copy)NSString * wanStr;
@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"求购信息";
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, kTopViewHeight)];
    [self.view addSubview:view];
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight - 1, kUIScreenWidth, 1)];
    bottomView.backgroundColor = RGBColor(230, 230, 230);
    [view addSubview:bottomView];
    //搜素框
    [view addSubview:self.searchBar];

    //UITableView
    [self.view addSubview:self.baseTable];
    [self configerRigTopButton];
    [self configerBottomView];
    
    self.pageNum = 1;
    self.dataAry = [NSMutableArray array];
    [self refreshNewData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.pageNum = 1;
//    self.dataAry = [NSMutableArray array];
//    [self refreshNewData];
}

/**
 *  下拉刷新
 */
- (void)refreshNewData{
    [self configerDataWithPage:1 keyword:nil];
}
/**
 *  上拉加载更多
 */
- (void)loadMoreData{
    [self configerDataWithPage:self.pageNum + 1 keyword:nil];
}
/**
 *  获取原始数据
 */
- (void)configerDataWithPage:(NSInteger)page keyword:(NSString *)keyword{
    NSString * netPath = @"pro/buy_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(page) forKey:@"page"];
    if (keyword != nil) {
        [allParams setObject:keyword forKey:@"keyword"];
    }
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
        [self getDataFromResponseObj:responseObj currentPage:page];
    } failure:^(NSError *error) {
        MyLog(@"首页求购信息错误:%@",error);
    }];
}
- (void)getDataFromResponseObj:(id)responseObj currentPage:(NSInteger)page{
    self.pageNum = page;
    if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {//数据为空
        //
    }else{
        if (page == 1) {
            self.dataAry = [NSMutableArray array];
        }
        for (NSDictionary * dict in responseObj[@"data"]) {
            RequestMsgModel * model = [RequestMsgModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTable reloadData];
}

#pragma mark-- UISearchBar代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [_searchBar resignFirstResponder];
        [self.dataAry removeAllObjects];
        [self configerDataWithPage:1 keyword:searchText];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.dataAry removeAllObjects];
    [self configerDataWithPage:1 keyword:searchBar.text];
}


/**
 *  导航栏右侧按钮
 */
- (void)configerRigTopButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    [button setTitle:@"我的报价" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark -- 导航栏右侧按钮响应事件
- (void)rightBarButtonClick{
    MyLog(@"右侧按钮点击");
    MyQuotedViewController * MyQuotedVC = [[MyQuotedViewController alloc] init];
    [self.navigationController pushViewController:MyQuotedVC animated:YES];
}
#pragma mark--Lazy Loading
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 10, kUIScreenWidth - 40, 40)];
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder = @"请输入关键字";
        _searchBar.searchBarStyle = 2;
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate =self;
        _searchBar.showsCancelButton = NO;
    }
    return _searchBar;
}
- (UITableView *)baseTable{
    if (!_baseTable) {
        _baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + kTopViewHeight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - kTopViewHeight - 45) style:UITableViewStylePlain];
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        _baseTable.rowHeight = 90;
        _baseTable.tableFooterView = [[UIView alloc] init];
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_baseTable registerNib:[UINib nibWithNibName:@"WantBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"wantCell"];
        //为了设置cell分割线的偏移
        if ([_baseTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_baseTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_baseTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [_baseTable setLayoutMargins:UIEdgeInsetsZero];
        }
        //
        _baseTable.emptyDataSetDelegate = self;
        _baseTable.emptyDataSetSource = self;
    }
    return _baseTable;
}

- (void)configerBottomView{
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0, kUIScreenHeight - 45, kUIScreenWidth, 45);
    bottomBtn.backgroundColor = RGBColor(30, 75, 145);
    [bottomBtn setTitle:@"发布求购" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bottomBtn addTarget:self action:@selector(bottomBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}
- (void)bottomBtnClicked{
    
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getWanStr:responseObj];
    } failure:^(NSError *error) {
        
    }];
}
- (void)getWanStr:(id)response{
    _wanStr = response[@"data"][@"wan"];
    if ([_wanStr isEqualToString:@"0"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"企业信息未完善,不能发布" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        IssueRequestViewController * issueVC = [[IssueRequestViewController alloc] init];
        [self.navigationController pushViewController:issueVC animated:YES];
    }
}
#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无求购信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}

#pragma mark ---UITableView的代理方法
// 这个会在表格视图的其中一个单元变为可视前立刻被调用，它是你在表格视图单元显示在屏幕上之前的外观定制的最后机会
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置需要的偏移量,这个UIEdgeInsets左右偏移量不要太大，不然会titleLabel也会便宜的。
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 10);
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { // iOS8的方法
        // 设置边界为0，默认是{8,8,8,8}
        [cell setLayoutMargins:inset];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
        return cell;
    }
    WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
    cell.model = self.dataAry[indexPath.row];
    cell.myBaojia = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    [self.baseTable deselectRowAtIndexPath:indexPath animated:YES];
    RequestDetailViewController * requestDetailVC = [[RequestDetailViewController alloc] init];
    RequestMsgModel * model = self.dataAry[indexPath.row];
    requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.Id, KUserImfor[@"userid"]];
    requestDetailVC.Id = model.Id;
    requestDetailVC.shareContent = model.jianjie;
    requestDetailVC.shareTitle = model.title;
    [self.navigationController pushViewController:requestDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
