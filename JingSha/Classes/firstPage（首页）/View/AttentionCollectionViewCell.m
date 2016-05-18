//
//  AttentionCollectionViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/15.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AttentionCollectionViewCell.h"
//#import "NewProductMoreTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#define kPageCount 10
#import "ProOptionModel.h"
#import "AttentionDetailTableViewCell.h"
@interface AttentionCollectionViewCell ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, copy)NSString * kkword;
@end

static NSString * indentifier = @"attentionCell";
@implementation AttentionCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.baseTable];
    }
    return self;
}
- (void)setAry:(NSMutableArray *)ary{
    _ary = ary;
}
- (void)setRowCount:(NSInteger)rowCount{
    _rowCount = rowCount;
    UIButton * button = _ary[_rowCount];
    self.kkword = button.titleLabel.text;
    self.pageNum = 1;
    self.dataAry = [NSMutableArray array];
    [self refreshNewData];
}

- (UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kUIScreenWidth, self.size.height - kNavigationBarHeight - 10) style:UITableViewStylePlain];
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        _baseTable.rowHeight = 105;
        _baseTable.tableFooterView = [[UIView alloc] init];
        //
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //
        _baseTable.emptyDataSetDelegate = self;
        _baseTable.emptyDataSetSource = self;
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"AttentionDetailTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    }
    return _baseTable;
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
    NSString * netPath = @"pro/pro_list";
    NSMutableDictionary * allParmas = [NSMutableDictionary dictionary];
    [allParmas setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParmas setObject:@(kPageCount) forKey:@"pagecount"];
    [allParmas setObject:@(self.pageNum) forKey:@"page"];
    [allParmas setObject:self.searchText forKey:@"leibie"];
    MyLog(@"_+_+_+%@", self.kkword);
    [HttpTool getWithPath:netPath params:allParmas success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
        MyLog(@"====%@", responseObj);
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDataFromResponseObj:(id)response{
    if (![response[@"data"] isKindOfClass:[NSNull class]]) {
        NSArray * ary = response[@"data"];
        for (NSDictionary * dict in ary) {
            ProOptionModel * model = [ProOptionModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTable reloadData];
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

#pragma mark --UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        AttentionDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        return cell;
    }
    AttentionDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToDetailVC:)]) {
        ProOptionModel * model = self.dataAry[indexPath.row];
        [self.delegate pushToDetailVC:model.Id];
    }
}
@end
