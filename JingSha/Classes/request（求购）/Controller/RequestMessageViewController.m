
//
//  RequestMessageViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RequestMessageViewController.h"
#import "RequestMessageTableViewCell.h"
#import "CheckQuoteViewController.h"
#import "MyRequestModel.h"
#import "UIScrollView+EmptyDataSet.h"
#define kPageCount 15
@interface RequestMessageViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@end

@implementation RequestMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报价信息";
    self.view.backgroundColor = RGBColor(218, 218, 218);
    self.pageNum = 1;
    self.dataAry = [NSMutableArray array];
    [self configerTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshNewData];
}
- (void)refreshNewData{
    self.pageNum = 1;
    [self.dataAry removeAllObjects];
    [self configerData];
}
- (void)loadMoreData{
    self.pageNum++;
    [self configerData];
}

- (void)configerData{
    NSString * netPath = @"userinfo/my_buy_list";//我的求购的  求购中的接口
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    [allParams setObject:@(1) forKey:@"type"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
        if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
            [self getDataFromResponseObj:responseObj];
        }
    } failure:^(NSError *error) {
        MyLog(@"我的求购错误信息:%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    MyLog(@"求购消息%@", responseObj);
    for (NSDictionary * dict in responseObj[@"data"]) {
        MyRequestModel * model = [MyRequestModel objectWithKeyValues:dict];
        [self.dataAry addObject:model];
    }
    [self.baseTable reloadData];
}
/**
 *  配置UITableView
 */
- (void)configerTableView{
    self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStyleGrouped];
    _baseTable.delegate = self;
    _baseTable.dataSource = self;
    _baseTable.rowHeight  = 140;
    [self.view addSubview:_baseTable];
    _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //注册cell
    [_baseTable registerNib:[UINib nibWithNibName:@"RequestMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"requestMessageCell"];
    //
    _baseTable.emptyDataSetDelegate = self;
    _baseTable.emptyDataSetSource = self;
}
#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无报价信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}


#pragma mark --UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return .0001;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        RequestMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"requestMessageCell"];
        return cell;
    }
    RequestMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"requestMessageCell"];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CheckQuoteViewController * checkQuoteVC = [[CheckQuoteViewController alloc] init];
    MyRequestModel * model = self.dataAry[indexPath.row];
    checkQuoteVC.bid = model.Id;//信息id  求购的id
    [self.navigationController pushViewController:checkQuoteVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
