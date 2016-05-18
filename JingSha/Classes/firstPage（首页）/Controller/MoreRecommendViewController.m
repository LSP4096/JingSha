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
@interface MoreRecommendViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UITableView *baseTable;
@property (nonatomic ,retain)UISearchBar * searchBar;
@property (nonatomic, strong)UIView * menuView;
@property (nonatomic, assign)BOOL isHidden;
@property (nonatomic ,strong)UIButton *rightButton;

@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, copy)NSString * type;//右上角全部、化纤、纱线
@property (nonatomic, copy)NSString * keyword;
@end

@implementation MoreRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor blackColor];
    [self.view addSubview:self.baseTable];
    [self configerNavgationbar];
    [self rightButtonClicked];
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
 *  配置导航条
 */
- (void)configerNavgationbar{
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(kUIScreenWidth - 40, 17, 40, 30);
    [_rightButton setTitle:@"全部" forState:UIControlStateNormal];
//    [_rightButton setTitleColor:RGBColor(131, 131, 131) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    //中间的搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 17, kUIScreenWidth - 120, 30)];
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.searchBar.bounds.size];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    //右侧全部按钮的下拉菜单
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth - 100, kNavigationBarHeight, 100, 105)];
    _menuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_menuView];
    //
    for (int i = 0; i < 3; i++) {
        NSArray * titlrAry = @[@"全部",@"纱线",@"化纤"];
        UIButton * but1 = [UIButton buttonWithType:UIButtonTypeCustom];
        but1.frame = CGRectMake(0, 35 * i, 100, 35);
        [but1 setTitle:titlrAry[i] forState:UIControlStateNormal];
        [but1 setTitleColor:RGBColor(123, 123, 123) forState:UIControlStateNormal];
        but1.titleLabel.font = [UIFont systemFontOfSize:12];
        but1.layer.borderWidth = 1;
        but1.layer.borderColor = RGBColor(240, 240, 240).CGColor;
        but1.tag = 1000 + i;
        [but1 addTarget:self action:@selector(optionButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:but1];
    }
}
/**
 * 下拉菜单的按钮响应事件
 */
- (void)optionButClicked:(UIButton *)sender{
    [_rightButton setTitle:@"全部" forState:UIControlStateNormal];
    if (sender.tag == 1000) {
        self.type = nil;
    }else if(sender.tag == 1001){
        [_rightButton setTitle:@"纱线" forState:UIControlStateNormal];
        self.type = @"1";
    }else if (sender.tag == 1002){
        [_rightButton setTitle:@"化纤" forState:UIControlStateNormal];
        self.type = @"2";
    }
    [self rightButtonClicked];
    [self refreshNewData];
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
 *  右侧按钮点击事件
 */
- (void)leftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  右侧按钮响应事件
 */
- (void)rightButtonClicked{
    if (self.isHidden) {
        self.menuView.hidden = NO;
    }else{
        self.menuView.hidden = YES;
    }
    self.isHidden = !self.isHidden;
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
