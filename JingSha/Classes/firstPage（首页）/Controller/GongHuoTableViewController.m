//
//  GongHuoTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/3/1.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "GongHuoTableViewController.h"
#import "RecommendProductTableViewCell.h"
#import "ProOptionModel.h"
#import "SupplyDetailViewController.h"
#define kPageCount 10
@interface GongHuoTableViewController ()
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@end

@implementation GongHuoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"供货详细";
    self.view.backgroundColor = [UIColor whiteColor];
    

    self.pageNum = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"recommendProductCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
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

    //    MyLog(@"%@" ,self.optionSearchText);
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    [allParams setObject:self.keyWord forKey:@"keyword"];
        [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromRespomseObjAboutSearch:responseObj];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
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
                ProOptionModel * model = [ProOptionModel objectWithKeyValues:dict];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendProductCell" forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
        supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
        supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
        [self.navigationController pushViewController:supplyVC animated:YES];
}




@end
