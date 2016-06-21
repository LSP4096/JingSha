//
//  NewsViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "JHTickerView.h"
#import "NewsModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SupplyDetailViewController.h"
#import "RequestDetailViewController.h"

#import "HttpClient+FirstPage.h"

#define kPageCount 10
@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.pageNum = 1;
    self.view.backgroundColor = RGBColor(246, 246, 246);
    [self.view addSubview:self.baseTable];
    [self RefreshNewData];//进来第一次刷新一次数据
}

- (NSMutableArray *)dataAry{
    if (_dataAry == nil) {
        self.dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (void)configerDataWithPage:(NSInteger)page{
    @WeakObj(self);
    [[HttpClient sharedClient] getNewsListWithPage:page PageCount:kPageCount Complection:^(id resoutObj, NSError *error) {
        @StrongObj(self);
        if (error) {
            MyLog(@"%@",error);
        }else {
            MyLog(@"XXXXXXXX%@", resoutObj);
            if (![resoutObj[@"data"] isKindOfClass:[NSNull class]]) {
                [Strongself getDataFromResponseObj:resoutObj];
            }
            [_baseTable.header endRefreshing];
            [_baseTable.footer endRefreshing];
        }
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    NSArray * dataAry = responseObj[@"data"];
    for (NSDictionary * dict in dataAry) {
        NewsModel * model = [NewsModel objectWithKeyValues:dict];
        [self.dataAry addObject:model];
    }
    [_baseTable reloadData];
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
#pragma mark -- Lazy Loading
-(UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight + 44) style:UITableViewStylePlain];
        _baseTable.backgroundColor = RGBColor(246, 246, 246);
        _baseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        //
        _baseTable.emptyDataSetDelegate = self;
        _baseTable.emptyDataSetSource = self;
        
        _baseTable.rowHeight = 180;
        _baseTable.separatorStyle = UITableViewCellSelectionStyleNone;
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
        //为了设置cell分割线的偏移
        if ([_baseTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_baseTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_baseTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [_baseTable setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _baseTable;
}
#pragma mark -- UITableVIew的代理方法
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
    NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    NewsModel * model = self.dataAry[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {//求购
        RequestDetailViewController * requestDetailVC = [[RequestDetailViewController alloc] init];
        requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.pro_buy_id, KUserImfor[@"userid"]];
//        requestDetailVC.fromNews = YES;
        requestDetailVC.Id = model.pro_buy_id;
        requestDetailVC.shareContent = model.procontent;
        requestDetailVC.shareTitle = model.protitle;
        [self.navigationController pushViewController:requestDetailVC animated:YES];
    }else if ([model.type isEqualToString:@"2"]){//供应
        SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];http:
        supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@",model.pro_buy_id, KUserImfor[@"userid"]];
        supplyVC.chanpinId = model.pro_buy_id;
//        supplyVC.fromNews = YES;
        [self.navigationController pushViewController:supplyVC animated:YES];
    }
}

//#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无消息记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}

@end
