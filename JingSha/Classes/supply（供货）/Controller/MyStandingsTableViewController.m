//
//  MyStandingsTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MyStandingsTableViewController.h"
#import "TopHeaderView.h"
#import "convertHistoryTableViewCell.h"
#import "StandingShopViewController.h"
#import "ScoreIntroduceViewController.h"
#import "JifenModel.h"
#define kPageCount 10
@interface MyStandingsTableViewController ()<TopHeaderViewDelegate>
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray * dataAry;

@property (nonatomic, strong)TopHeaderView * topView;
@end

static NSString * indentifier = @"convertHistoryCell";

@implementation MyStandingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"我的积分";
    self.view.backgroundColor = RGBColor(236, 236, 236);
    self.topView = [[TopHeaderView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, 120)];
    _topView.delegate =self;
    self.tableView.tableHeaderView = _topView;
    self.tableView.tableFooterView=[[UIView alloc]init];//去除多余的分割线
    //
    self.page = 1;
    self.dataAry = [NSMutableArray array];
    //
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"convertHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //第一次刷新数据
    [self refreshNewData];
}

- (void)refreshNewData{
    self.page = 1;
    [self.dataAry removeAllObjects];
    [self configerData];
}

- (void)reloadMoreData{
    self.page++;
    [self configerData];
}

- (void)configerData{
    NSString * netPath = @"userinfo/my_jifen_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(self.page) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponse:responseObj];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
    }];
}

- (void)getDataFromResponse:(id)responseObj{
    self.topView.jifen = responseObj[@"jifen"];
    if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        NSArray * ary = responseObj[@"data"];
        for (NSDictionary * dict in ary) {
            JifenModel * model = [JifenModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kUIScreenWidth, 35)];
    view.backgroundColor = RGBColor(251, 251, 251);
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 100, 20)];
    label.textColor = RGBColor(83, 83, 83);
    label.text = @"积分记录";
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataAry.count == 0) {
        convertHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
        return cell;
    }
    convertHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark --TopHeaderViewDelegate
- (void)pushToStandingsShop{//积分商城
    StandingShopViewController * standingShopVC = [[StandingShopViewController alloc] init];
    [self.navigationController pushViewController:standingShopVC animated:YES];
}
- (void)pushToStandingsIntroduce{//积分说明
    ScoreIntroduceViewController * scoreVC =  [[ScoreIntroduceViewController alloc] init];
    [self.navigationController pushViewController:scoreVC animated:YES];
}

@end
