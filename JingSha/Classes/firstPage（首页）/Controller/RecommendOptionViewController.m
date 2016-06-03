//
//  RecommendOptionViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/7.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RecommendOptionViewController.h"
#import "RecommendSupplierTableViewCell.h"
#import "RecommendProductTableViewCell.h"
#import "AllSearchTableViewController.h"
#import "SupplierSearchTableViewController.h"
#import "SupplyDetailViewController.h"
#import "RecommendDetailViewController.h"
#import "ProOptionModel.h"
#import "CompanyListModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SelectTypeViewController.h"

#import "WantBuyTableViewCell.h"
#import "RequestDetailViewController.h"//H5页面，这个用不着了
#import "RequestMsgModel.h"

#define kPageCount 10

@interface RecommendOptionViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UISearchBarDelegate>
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UITableView *baseTable;

@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@end

@implementation RecommendOptionViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.searchBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchBar.hidden = NO;
    //请求数据
    self.pageNum = 1;
    [self refreshNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configerNavgationBar];
    [self.view addSubview:self.baseTable];
    self.searchBar.text = self.optionSearchText;
}
/**
 *  请求数据
 */
- (void)refreshNewData{
    self.dataAry = [NSMutableArray array];
    self.pageNum = 1;
    [self configerData];
}

- (void)loadMoreData{
    self.pageNum++;
    [self configerData];
}

- (void)configerData{
    NSString * netPath = [NSString string];
    if ([self.searchTitle isEqualToString:@"产品"]) {
        netPath = @"pro/pro_list";
    }else if([self.searchTitle isEqualToString:@"供应商"]){
        netPath = @"pro/user_list";
    }else if([self.searchTitle isEqualToString:@"求购"]){
        netPath = @"pro/buy_list";
    }
    
//    MyLog(@"%@" ,self.optionSearchText);
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];

    [allParams setObject:@(kPageCount) forKey:@"pagecount"];

    [allParams setObject:@(self.pageNum) forKey:@"page"];
    [allParams setObject:self.optionSearchText forKey:@"keyword"];
    if ([SingleTon shareSingleTon].leibieStr) {//类别存在，说明是从筛选界面返回来的
        [allParams setObject:[SingleTon shareSingleTon].leibieStr forKey:@"leibie"];
        _searchBar.text = nil;
//        [SingleTon shareSingleTon].leibieStr = nil;
    }
    if ([SingleTon shareSingleTon].zhisuStr) {
        [allParams setObject:[SingleTon shareSingleTon].zhisuStr forKey:@"zhisu"];
        _searchBar.text = nil;
//        [SingleTon shareSingleTon].zhisuStr = nil;
    }
    if ([SingleTon shareSingleTon].zcdStr) {
        [allParams setObject:[SingleTon shareSingleTon].zcdStr forKey:@"zcd"];
        _searchBar.text = nil;
//        [SingleTon shareSingleTon].zcdStr = nil;
    }
    if ([SingleTon shareSingleTon].qiyefenleiStr) {
        [allParams setObject:[SingleTon shareSingleTon].qiyefenleiStr forKey:@"leibie"];
        _searchBar.text = nil;
//        [SingleTon shareSingleTon].qiyefenleiStr = nil;
    }
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromRespomseObjAboutSearch:responseObj];
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  解析数据
 */
- (void)getDataFromRespomseObjAboutSearch:(id)responseObj{
    MyLog(@"%@", responseObj);
    if ([responseObj[@"data"]isKindOfClass:[NSNull class]]) {
        
    }else{
    NSArray * listAry = responseObj[@"data"];
    for (NSDictionary * dict in listAry) {
        if ([self.searchTitle isEqualToString:@"供应商"]) {
            CompanyListModel * model = [CompanyListModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }else if ([self.searchTitle isEqualToString:@"产品"]){
            ProOptionModel * model = [ProOptionModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }else if ([self.searchTitle isEqualToString:@"求购"]){
            RequestMsgModel * model = [RequestMsgModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
        
        
        else{
            
        }
    }
 }
    [_baseTable reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.optionSearchText = searchText;
    if (searchText.length == 0) {
        [searchBar resignFirstResponder];
    }
    
    [self refreshNewData];
}


#pragma mark -- 配置导航栏
- (void)configerNavgationBar{
    CGRect mainViewBounds = self.navigationController.view.bounds;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainViewBounds) + 60 ,CGRectGetMinY(mainViewBounds) + 7,mainViewBounds.size.width - 140,30)];
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];//取消搜索框背景色
    _searchBar.delegate =self;
    _searchBar.placeholder = @"请输入搜索关键字";
    self.navigationItem.titleView = _searchBar;
//    [self.navigationController.navigationBar addSubview: _searchBar];
    //右侧按钮
    UIButton * rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton2.backgroundColor = [UIColor redColor];
    rightButton2.frame  =CGRectMake(mainViewBounds.size.width - 50, 0, 35, 35);
    [rightButton2 setImage:img(@"sift") forState:UIControlStateNormal];
    rightButton2.imageEdgeInsets = UIEdgeInsetsMake(3, -5, 0, 0);//上左下右 原则
    [rightButton2 setTitle:@"筛选" forState:UIControlStateNormal];
    rightButton2.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -20);
    
    rightButton2.titleLabel.font =[UIFont systemFontOfSize:13];
    UIBarButtonItem * but2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    [rightButton2 addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = but2;
}

/**
 *  筛选按钮响应事件
 */
- (void)rightBarButtonClicked{
    if ([self.searchTitle isEqualToString:@"供应商"]) {//是从首页搜索框点进去的，对应筛选只有地区、类目
        SupplierSearchTableViewController * supplierVC = [[SupplierSearchTableViewController alloc] init];
        [self.navigationController pushViewController:supplierVC animated:YES];
    }else if ([self.searchTitle isEqualToString:@"产品"]){//是从首页搜索框点进去的，对应筛选只有地区、类目、属性
        AllSearchTableViewController * allSearchVC = [[AllSearchTableViewController alloc] init];
        [self.navigationController pushViewController:allSearchVC animated:YES];
    }else if ([self.optionSearchText isEqualToString:@"化纤"]) {//从推荐供应商里面的全部点进去的（地区、类目）
        SupplierSearchTableViewController * supplierVC = [[SupplierSearchTableViewController alloc] init];
        [self.navigationController pushViewController:supplierVC animated:YES];
    }else{//纱线 //从推荐供应商里面的全部点进去的（地区、类目）
        SupplierSearchTableViewController * supplierVC = [[SupplierSearchTableViewController alloc] init];
        [self.navigationController pushViewController:supplierVC animated:YES];
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

#pragma mark -- Lazy Loading
- (UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStylePlain];
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        _baseTable.rowHeight = 112;
        _baseTable.tableFooterView = [[UIView alloc] init];
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"RecommendSupplierTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendSupplierCell"];
        [_baseTable registerNib:[UINib nibWithNibName:@"RecommendProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"recommendProductCell"];
        [_baseTable registerNib:[UINib nibWithNibName:@"WantBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"wantCell"];
        //
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        //
        _baseTable.emptyDataSetDelegate = self;
        _baseTable.emptyDataSetSource = self;
    }
    return _baseTable;
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

#pragma mark -- UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.searchTitle isEqualToString:@"产品"]) {
        if (self.dataAry.count == 0) {
            RecommendProductTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"recommendProductCell"];
            return cell;
        }
        RecommendProductTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"recommendProductCell"];
        cell.model = self.dataAry[indexPath.row];
        return cell;
    }else if([self.searchTitle isEqualToString:@"供应商"]){
        if (self.dataAry.count == 0) {
            RecommendSupplierTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendSupplierCell"];
            return cell;
        }
        RecommendSupplierTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendSupplierCell"];
        cell.model = self.dataAry[indexPath.row];
        return cell;
    }else if([self.searchTitle isEqualToString:@"求购"]){
        if (self.dataAry.count == 0) {
            WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
            return cell;
        }
        WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
        cell.model = self.dataAry[indexPath.row];
        cell.myBaojia = NO;
        return cell;
    }
    else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    if ([self.searchTitle isEqualToString:@"产品"]) {
        SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
        supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
        supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
        [self.navigationController pushViewController:supplyVC animated:YES];
    }else if ([self.searchTitle isEqualToString:@"供应商"]){
        RecommendDetailViewController * recommDeVC = [[RecommendDetailViewController alloc] init];
        recommDeVC.qiyeId = [self.dataAry[indexPath.row] Id];
        [self.navigationController pushViewController:recommDeVC animated:YES];
    }else if ([self.searchTitle isEqualToString:@"求购"]){
        RequestDetailViewController * requestDetailVC = [[RequestDetailViewController alloc] init];
        RequestMsgModel * model = self.dataAry[indexPath.row];
        requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.Id, KUserImfor[@"userid"]];
        requestDetailVC.Id = model.Id;
        requestDetailVC.shareContent = model.jianjie;
        requestDetailVC.shareTitle = model.title;
        [self.navigationController pushViewController:requestDetailVC animated:YES];
    }
}


@end
