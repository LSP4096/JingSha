//
//  MyQuotedViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/2.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MyQuotedViewController.h"
#import "JHTickerView.h"
#import "WantBuyTableViewCell.h"
#import "RequestDetailViewController.h"
#import "RequestMsgModel.h"
#import "UIScrollView+EmptyDataSet.h"
#define kPageCount 15
@interface MyQuotedViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@end

@implementation MyQuotedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的报价";
    self.dataAry = [NSMutableArray array];
    self.pageNum = 1;
    [self refreshNewData];
    [self.view addSubview:self.baseTable];
}
/**
 *  下拉刷新
 */
- (void)refreshNewData{
    self.pageNum = 1;
    [self.dataAry removeAllObjects];
    [self configerData];
}
/**
 *  上拉加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerData];
}

- (void)configerData{
    NSString * netPath = @"userinfo/my_baojia_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
            [self getDataFromResponseObj:responseObj];
        }
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"我的报价错误信息:%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    MyLog(@"%@", responseObj);
    for (NSDictionary * dict in responseObj[@"data"]) {
        RequestMsgModel * model = [RequestMsgModel objectWithKeyValues:dict];
        [self.dataAry addObject:model];
    }
    [_baseTable reloadData];
}

#pragma mark-- Lazy Loading
- (UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStylePlain];
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
#pragma mark -- UITableView代理
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
    WantBuyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"wantCell"];
    cell.model = self.dataAry[indexPath.row];
    cell.myBaojia = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestDetailViewController * requestDetailVC= [[RequestDetailViewController alloc] init];
    RequestMsgModel * model = self.dataAry[indexPath.row];
    requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.bid, KUserImfor[@"userid"]];     
    requestDetailVC.Id = model.bid;
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
