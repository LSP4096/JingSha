//
//  CompanyJudgeTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CompanyJudgeTableViewController.h"
#import "companyJudgeTableViewCell.h"
#import "JudgeModel.h"
 #import "UIScrollView+EmptyDataSet.h"
#define kPageCount 15
@interface CompanyJudgeTableViewController ()<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@end
static NSString * indentifier = @"companyJudgeCell";
static NSString * indentifier2 = @"cell";
@implementation CompanyJudgeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业评价";
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//这句话并没有卵用
    [self registerCellForTableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.pageNum = 1;
    self.dataAry = [NSMutableArray array];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    [self refreshNewData];
}

- (void)registerCellForTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"companyJudgeTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
}
#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无评价记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}
/**
 *  下拉加载数据
 */
- (void)refreshNewData{
    [self.dataAry removeAllObjects];
    self.pageNum = 1;
    [self loadData];
}
/**
 *  上拉加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self loadData];
}
/**
 *  请求数据
 */
- (void)loadData{
    NSString * netPath = @"userinfo/my_pingjia_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    MyLog(@"%@", allParams);
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"企业评价%@", responseObj);
        [self getDataFromResponseObj:responseObj];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  解析请求的数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    NSArray * ary = responseObj[@"data"];
    for (NSDictionary  *dict in ary) {
        JudgeModel * model = [JudgeModel objectWithKeyValues:dict];
        [self.dataAry addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [companyJudgeTableViewCell callHeight:self.dataAry[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    companyJudgeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
