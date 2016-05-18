//
//  MoreSupplierViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/7.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MoreSupplierViewController.h"
#import "RecommendDetailViewController.h"
#import "RecommendSupplierTableViewCell.h"
#import "RecommendOptionViewController.h"
#import "CompanyListModel.h"
#import "UIScrollView+EmptyDataSet.h"
#define kPageCount 10
@interface MoreSupplierViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UIView * rightMenuView;
@property (nonatomic, assign)BOOL isHidden;
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;

@property (nonatomic, assign)NSInteger type;
@property (nonatomic, strong)UIButton * rightButton;
@end

@implementation MoreSupplierViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.searchBar.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.searchBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isHidden = YES;
    [self configerNavgationBar];
    self.pageNum = 1;
    self.type = 0;
    [self RefreshNewData];//第一次调用刷新
    [self.view addSubview:self.baseTable];
    [self configerRightMenu];
}

- (NSMutableArray *)dataAry{
    if (_dataAry == nil) {
        self.dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
/**
 *  获取原始数据
 */
- (void)configerDataWithPage:(NSInteger)page keyword:(NSString *)keyword{
    NSString * netPath = @"pro/user_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(page) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    if (keyword != nil) {
        [allParams setObject:keyword forKey:@"keyword"];
    }
    [allParams setObject:@(self.type) forKey:@"type"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"企业列表%@", responseObj);
        [self getDataFromResponseObj:responseObj keyword:(NSString *)keyword];
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj keyword:(NSString *)keyword{
    if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {//没有数据
        if (keyword == nil) {
            
        }else{//搜索的时候没有结果数据
        }
    }else{//有数据
        NSArray * dataAry = responseObj[@"data"];
        for (NSDictionary * dict in dataAry) {
            CompanyListModel * model = [CompanyListModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTable reloadData];
}

/**
 *  刷新新数据
 */
- (void)RefreshNewData{
    [self.dataAry removeAllObjects];
    [self configerDataWithPage:1 keyword:nil];
    self.pageNum = 1;
}
/**
 *  加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerDataWithPage:self.pageNum keyword:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [searchBar resignFirstResponder];
        self.dataAry = [NSMutableArray array];
        [self configerDataWithPage:1 keyword:searchBar.text];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.dataAry removeAllObjects];
    [self configerDataWithPage:1 keyword:searchBar.text];
}

#pragma mark -- 配置导航栏
- (void)configerNavgationBar{
    CGRect mainViewBounds = self.navigationController.view.bounds;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainViewBounds) + 60,CGRectGetMinY(mainViewBounds) + 27,mainViewBounds.size.width - 120,30)];
    self.searchBar.delegate = self;
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];//取消搜索框背景色
    self.navigationItem.titleView = _searchBar;
    //右侧按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame  =CGRectMake(mainViewBounds.size.width - 40, 0, 40, 30);
    [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [_rightButton setTitle:@"全部" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
}


//配置右侧下拉菜单
- (void)configerRightMenu{
    self.rightMenuView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth - 100, 64, 100, 120)];
//    _rightMenuView.backgroundColor = RGBColor(240, 240, 240);
    _rightMenuView.hidden = YES;
    [self.view addSubview:_rightMenuView];
    //全部按钮
    UIButton * but3 = [UIButton buttonWithType:UIButtonTypeCustom];
    but3.frame = CGRectMake(0, 0, 100, 40);
    [but3 setTitle:@"全部" forState:UIControlStateNormal];
    but3.titleLabel.font = [UIFont systemFontOfSize:14];
    but3.tag = 3000;
    but3.layer.borderWidth = 1;
    but3.layer.borderColor = RGBColor(240, 240, 240).CGColor;
    [but3 setTitleColor:RGBColor(123, 123, 123) forState:UIControlStateNormal];
    but3.backgroundColor = [UIColor whiteColor];
    [but3 addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightMenuView addSubview:but3];
    
    //纱线按钮
    UIButton * but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(0, 40, 100, 40);
    [but1 setTitle:@"纱线" forState:UIControlStateNormal];
    but1.titleLabel.font = [UIFont systemFontOfSize:14];
    but1.tag = 1000;
    but1.layer.borderWidth = 1;
    but1.layer.borderColor = RGBColor(240, 240, 240).CGColor;
    [but1 setTitleColor:RGBColor(123, 123, 123) forState:UIControlStateNormal];
    but1.backgroundColor = [UIColor whiteColor];
    [but1 addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightMenuView addSubview:but1];
    //化纤按钮
    UIButton * but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame = CGRectMake(0, 80, 100, 40);
    [but2 setTitle:@"化纤" forState:UIControlStateNormal];
    but2.titleLabel.font = [UIFont systemFontOfSize:14];
    but2.tag = 2000;
    but2.layer.borderWidth = 1;
    but2.layer.borderColor = RGBColor(240, 240, 240).CGColor;
    [but2 setTitleColor:RGBColor(123, 123, 123) forState:UIControlStateNormal];
    but2.backgroundColor = [UIColor whiteColor];
    [but2 addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightMenuView addSubview:but2];
}
- (void)rightBarButtonClicked{
    _isHidden = !_isHidden;
    if (self.isHidden) {
        _rightMenuView.hidden = YES;
    }else{
        _rightMenuView.hidden = NO;
    }
}
#pragma mark -- 纱线和化纤 可选按钮响应事件
- (void)optionButtonClicked:(UIButton *)sender{
//    RecommendOptionViewController * recommendOptionVC = [[RecommendOptionViewController alloc] init];
    if (sender.tag == 1000) {//判断筛选进入哪个界面
//        recommendOptionVC.optionSearchText = @"纱线";
        _searchBar.text = @"纱线";
        self.type = 1;
        [_rightButton setTitle:@"纱线" forState:UIControlStateNormal];
    }else if(sender.tag == 2000){
//        recommendOptionVC.optionSearchText = @"化纤";
        _searchBar.text = @"化纤";
        self.type = 2;
        [_rightButton setTitle:@"化纤" forState:UIControlStateNormal];
    }else if(sender.tag == 3000){
        self.type = 0;
        [_rightButton setTitle:@"全部" forState:UIControlStateNormal];
    }
    [self RefreshNewData];
//    recommendOptionVC.searchTitle = @"供应商";//由于要进入的是多个公用页面，要判断是产品还是供应商，不然netpath为空，所以给它这个属性
//    [self.navigationController pushViewController:recommendOptionVC animated:YES];
    _isHidden = !_isHidden;
    _rightMenuView.hidden = YES;//隐藏下拉菜单
    [_searchBar resignFirstResponder];//隐藏键盘
}
#pragma mark -- tableView的配置
- (UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStylePlain];
        self.automaticallyAdjustsScrollViewInsets = YES;
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        _baseTable.rowHeight = 112;
        _baseTable.tableFooterView = [[UIView alloc] init];
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"RecommendSupplierTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendSupplierCell"];
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
#pragma mark --UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        RecommendSupplierTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"RecommendSupplierCell" forIndexPath:indexPath];
        return cell;
    }
    RecommendSupplierTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"RecommendSupplierCell" forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    self.rightMenuView.hidden = YES;
    RecommendDetailViewController * recommendVC = [[RecommendDetailViewController alloc] init];
    recommendVC.qiyeId = [self.dataAry[indexPath.row] Id];
    [self.navigationController pushViewController:recommendVC animated:YES];
}
// 这个会在表格视图的其中一个单元变为可视前立刻被调用，它是你在表格视图单元显示在屏幕上之前的外观定制的最后机会
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置需要的偏移量,这个UIEdgeInsets左右偏移量不要太大，不然会titleLabel也会便宜的。
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 15, 0, 10);
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { // iOS8的方法
        // 设置边界为0，默认是{8,8,8,8}
        [cell setLayoutMargins:inset];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
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

#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"未搜索到相关信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
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
