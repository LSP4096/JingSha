//
//  convertHistoryTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "convertHistoryTableViewController.h"
#import "convertHistoryCell.h"
#import "convertDetailTableViewController.h"
#import "DuiHUanHistoryModel.h"
#define pageCount 10
@interface convertHistoryTableViewController ()
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger page;
@end

static NSString * indentifier = @"convertCell";
@implementation convertHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.tableView.rowHeight = 70;
    self.tableView.tableFooterView=[[UIView alloc]init];//去除多余的分割线
    [self.tableView registerNib:[UINib nibWithNibName:@"convertHistoryCell" bundle:nil] forCellReuseIdentifier:indentifier];
    //
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    
    self.page = 1;
    self.dataAry = [NSMutableArray array];
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
    NSString * netPath = @"userinfo/my_duihuan_list";
    NSMutableDictionary * allparams = [NSMutableDictionary dictionary];
    [allparams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allparams setObject:@(pageCount) forKey:@"pagecount"];
    [allparams setObject:@(self.page) forKey:@"page"];
    [HttpTool postWithPath:netPath params:allparams success:^(id responseObj) {
        [self getDataFromResponse:responseObj];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDataFromResponse:(id)responseObj{
    if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        NSArray * ary = responseObj[@"data"];
        for (NSDictionary * dict in ary) {
            DuiHUanHistoryModel * model = [DuiHUanHistoryModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataAry.count == 0) {
        convertHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
        return cell;
    }
    convertHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    convertDetailTableViewController * convertVC = [[convertDetailTableViewController alloc] init];
    convertVC.did = [self.dataAry[indexPath.section] did];
    [self.navigationController pushViewController:convertVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
