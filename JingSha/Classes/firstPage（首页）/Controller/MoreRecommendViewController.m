//
//  MoreRecommendViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/9.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MoreRecommendViewController.h"
#import "NewProductMoreTableViewCell.h"
#import "SupplyDetailViewController.h"
#import "ProOptionModel.h"
 #import "UIScrollView+EmptyDataSet.h"
#define kPageCount 15
#define KNavgationBarHight self.navigationController.navigationBar.height

@interface MoreRecommendViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UITableView *baseTable;
@property (nonatomic ,retain)UISearchBar * searchBar;

@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSString * keyword;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *titleArr2;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MoreRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor blackColor];
    [self.view addSubview:self.baseTable];
    [self configerNavgationbar];
    [self configSelectedView];
    self.type = @"";
    
    [self refreshNewData];
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
    NSString * netPath = @"pro/pro_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    if (self.keyword) {
        [allParams setObject:self.keyword forKey:@"keyword"];
    }
    if (self.type) {//不等于空就是1或2
        [allParams setObject:self.type forKey:@"type"];
    }
    MyLog(@"----------%@", allParams);
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
//    MyLog(@"%@", responseObj);
    if ([responseObj[@"data"]isKindOfClass:[NSNull class]]) {
    }else{
        if (self.pageNum == 1) {
            self.dataAry = [NSMutableArray array];
        }
        NSArray * listAry = responseObj[@"data"];
        for (NSDictionary * dict in listAry) {
            ProOptionModel * model = [ProOptionModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTable reloadData];
}

#pragma mark ---UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [searchBar resignFirstResponder];
        self.keyword = searchText;
        [self refreshNewData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.keyword = searchBar.text;
    [self refreshNewData];
}

/**
 *  配置搜索栏
 */
- (void)configSelectedView {
    
    if (self.headerView) {
        [self.headerView removeFromSuperview];
    }
    
    MyLog(@"titleArr.count--%ld",self.titleArr.count);
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, KNavgationBarHight, kUIScreenWidth, 110)];
    [self.view addSubview:self.headerView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kUIScreenWidth / 2, 21)];
    label.text = @"热门搜索";
    label.font = [UIFont systemFontOfSize:16.0];
    [_headerView addSubview:label];
    
    //换一批按钮
    UIButton *selecteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selecteBtn.frame = CGRectMake( kUIScreenWidth - 80, 10, 70, 21);
    [selecteBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [selecteBtn setImage:img(@"searchNext") forState:UIControlStateNormal];
    selecteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [selecteBtn setTitleColor:RGBColor(115, 112, 276) forState:UIControlStateNormal];
    selecteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    selecteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [selecteBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:selecteBtn];
    
    CGFloat Width = (kUIScreenWidth - 60) / 3;
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        optionBtn.frame = CGRectMake(20 +  (Width + 10) * (i%3), 38 + (21 + 10) * (i/3), Width, 21);
        [optionBtn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        optionBtn.layer.cornerRadius = 10.0f;
        optionBtn.layer.borderWidth = 0.001f;
        optionBtn.layer.masksToBounds = YES;
        [optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        optionBtn.backgroundColor = RGBColor(31, 111, 251);
        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:optionBtn];
    }
}

/**
 *  配置导航条
 */
- (void)configerNavgationbar{
    //搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 17, kUIScreenWidth - 120, 30)];
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.searchBar.bounds.size];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
}

//取消搜索框背景色
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
/**
 *  左侧按钮点击事件
 */
- (void)leftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Lazy Loading
-(UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStylePlain];
        _baseTable.rowHeight = 105;
        _baseTable.delegate =self;
        _baseTable.dataSource = self;
        _baseTable.tableFooterView = [[UIView alloc] init];
        //集成下拉刷新和上拉加载
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"NewProductMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"newProductMoreCell"];
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

#pragma mark --UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        NewProductMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newProductMoreCell"];
        return cell;
    }
    NewProductMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newProductMoreCell"];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
    supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
    [self.navigationController pushViewController:supplyVC animated:YES];
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
