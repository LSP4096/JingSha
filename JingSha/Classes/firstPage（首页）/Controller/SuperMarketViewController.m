//
//  SuperMarketViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SuperMarketViewController.h"
#import "JingSha-Prefix.pch"
#import "SuperMarketCollectionViewCell.h"
#import "SupplyDetailViewController.h"
#import "SuppleMsgModel.h"
#import "UIScrollView+EmptyDataSet.h"
#define kPageCount 15

@interface SuperMarketViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UICollectionView * baseCollectView;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)UISearchBar * searchBar;
@property (nonatomic, copy)NSString * keyword;
@end

@implementation SuperMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"原料超市";
    self.dataAry = [NSMutableArray array];
    [self RefreshNewData];
    [self.view addSubview:self.baseCollectView];
    [self configerTopView];
}

- (void)configerDataWithPage:(NSInteger)page{
    NSString * netPath = @"pro/pro_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(page) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(2) forKey:@"type"];
    if (self.keyword.length > 0) {
        [allParams setObject:self.keyword forKey:@"keyword"];
    }
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
            [self getDataFromResponseObj:responseObj];
        [_baseCollectView.header endRefreshing];
        [_baseCollectView.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    NSArray * ary = responseObj[@"data"];
    if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        for (NSDictionary * dict in ary) {
            SuppleMsgModel * model = [SuppleMsgModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseCollectView reloadData];
}

/**
 *  刷新新数据
 */
- (void)RefreshNewData{
    [self.dataAry removeAllObjects];
    [self configerDataWithPage:1];
    self.pageNum = 1;
}
/**
 *  加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerDataWithPage:self.pageNum];
}
//
#pragma mark-- UISearchBar代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [_searchBar resignFirstResponder];
        MyLog(@"______________%@", searchText);
        MyLog(@"++++++++++%@", searchBar.text);
        self.keyword = searchText;
        [self RefreshNewData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    MyLog(@"______________%@", searchBar.text);
    MyLog(@"++++++++++%@", searchBar.text);
    self.keyword = searchBar.text;
    [self RefreshNewData];
}
- (void)configerTopView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, 65)];
    view.backgroundColor = RGBAColor(255, 255, 255, 1);
    [self.view addSubview:view];
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 1)];
    bottomView.backgroundColor = RGBColor(230, 230, 230);
    [view addSubview:bottomView];
    //搜素框
    [view addSubview:self.searchBar];
}

#pragma mark -Lazy Loading
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

-(UICollectionView *)baseCollectView{
    if (!_baseCollectView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kUIScreenWidth - 45)/2, 190);
        self.baseCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 65, kUIScreenWidth, kUIScreenHeight - 65) collectionViewLayout:layout];
        _baseCollectView.backgroundColor = [UIColor whiteColor];
        _baseCollectView.delegate = self;
        _baseCollectView.dataSource = self;
        //
        _baseCollectView.emptyDataSetDelegate = self;
        _baseCollectView.emptyDataSetSource = self;
        _baseCollectView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewData)];
        _baseCollectView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_baseCollectView registerNib:[UINib nibWithNibName:@"SuperMarketCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"superMarketCell"];
    }
    return _baseCollectView;
}
#pragma mark --UICollectionView 的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SuperMarketCollectionViewCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"superMarketCell" forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
    supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
    [self.navigationController pushViewController:supplyVC animated:YES];
}
#pragma mark --UICollectionViewDelegateFlowLayout代理
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

#pragma mark ----
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
    NSString *text = @"暂无相关信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}
@end
