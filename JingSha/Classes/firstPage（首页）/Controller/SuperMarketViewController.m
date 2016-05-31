//
//  SuperMarketViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SuperMarketViewController.h"
#import "JingSha-Prefix.pch"
#import "SupplyDetailViewController.h"
#import "SuppleMsgModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SuperMarketTabViewCell.h"

#define kPageCount 15

@interface SuperMarketViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
//@property (nonatomic, strong)UICollectionView * baseCollectView;
@property (nonatomic, strong) UITableView *baseTabView;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, copy)NSString * keyword;
@end

@implementation SuperMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"交易中心";
    [self RefreshNewData];
    [self.view addSubview:self.baseTabView];
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
        [_baseTabView.header endRefreshing];
        [_baseTabView.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    NSArray * ary = responseObj[@"data"];
    MyLog(@"%@",responseObj[@"data"]);
    if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        [self.dataAry removeAllObjects];
        for (NSDictionary * dict in ary) {
            SuppleMsgModel * model = [SuppleMsgModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTabView reloadData];
}

/**
 *  刷新新数据
 */
- (void)RefreshNewData{
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


#pragma mark -Lazy Loading
- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [[NSMutableArray alloc] init];
    }
    return _dataAry;
}

-(UITableView *)baseTabView{
    if (!_baseTabView) {
        
        _baseTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight ) style:UITableViewStylePlain];
        _baseTabView.backgroundColor = [UIColor whiteColor];
        _baseTabView.delegate = self;
        _baseTabView.dataSource = self;
        //
        _baseTabView.rowHeight = 118 * KProportionHeight;
        
        _baseTabView.emptyDataSetDelegate = self;
        _baseTabView.emptyDataSetSource = self;
        
        _baseTabView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewData)];
        _baseTabView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [_baseTabView registerNib:[UINib nibWithNibName:@"SuperMarketTabViewCell" bundle:nil] forCellReuseIdentifier:@"marketCell"];
    }
    return _baseTabView;
}

#pragma mark --UITableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuperMarketTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell"];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
    supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
    [self.navigationController pushViewController:supplyVC animated:YES];
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
