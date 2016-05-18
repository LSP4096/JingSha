//
//  TotalProviderTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "TotalProviderTableViewCell.h"
#import "ProviderTableViewCell.h"
#import "RecommendSupplyModel.h"
@interface TotalProviderTableViewCell ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger tableCount;

@property (nonatomic, strong) NSMutableArray *tableList;

@end
@implementation TotalProviderTableViewCell

- (void)awakeFromNib {
    [self loadHomePageData];
//    [self configerMiddleView];
}

- (NSMutableArray *)tableList
{
    if (!_tableList) {
        _tableList = [NSMutableArray array];
    }
    return _tableList;
}

/**
 *  加载首页数据
 */
- (void)loadHomePageData{
    NSString * netPath = @"pro/home_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"++%@", responseObj);
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"首页数据加载错误信息%@", error);
    }];
}

/**
 *  分解取得的数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    NSDictionary * dict  = responseObj[@"data"];
    self.dataAry = [NSMutableArray array];
    for (NSDictionary * smallDict in dict[@"userlist"]) {
        RecommendSupplyModel * model = [RecommendSupplyModel objectWithKeyValues:smallDict];
        [self.dataAry addObject:model];
    }
    [self configerMiddleView];
}

#pragma mark ---
- (void)configerMiddleView{
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 300 * KProportionHeight)];
//    _baseScrollView.contentSize = CGSizeMake(3 * kUIScreenWidth, 300 * KProportionHeight);
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.delegate = self;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.bounces = NO;
    [self addSubview:_baseScrollView];
    
    if (self.dataAry.count <= 3) {
        self.tableCount = 1;
    }else if (self.dataAry.count > 3 && self.dataAry.count <= 6){
        self.tableCount = 2;
    }else if (self.dataAry.count > 6 && self.dataAry.count <= 9){
        self.tableCount = 3;
    }else if (self.dataAry.count > 9 && self.dataAry.count <= 12){
        self.tableCount = 4;
    }
    
    _baseScrollView.contentSize = CGSizeMake(self.tableCount * kUIScreenWidth, 300 * KProportionHeight);
    
    for (int i = 0; i < self.tableCount; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * kUIScreenWidth, 0, kUIScreenWidth , 300 *KProportionHeight ) style:UITableViewStylePlain];
        tableView.rowHeight = 100 * KProportionHeight;
        tableView.scrollEnabled = NO;
        tableView.delegate  = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        //注册cell
        [tableView registerNib:[UINib nibWithNibName:@"ProviderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProviderTableViewCell"];
        [self.baseScrollView addSubview:tableView];
        [self.tableList addObject:tableView];
    }
}
#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = _baseScrollView.contentOffset.x / kUIScreenWidth;
    if (self.tableCount == 1) {
        return self.dataAry.count;
    }else if (self.tableCount == 2){
        if (num == 0) {
            return 3;
        }else{
            return self.dataAry.count - 3;
        }
    }else if (self.tableCount == 3){
        if (num == 0 || num == 1) {
            return 3;
        }else{
            return self.dataAry.count - 6;
        }
    }else{
        if (num == 0 || num == 1 || num == 2) {
            return 3;
        }else{
            return self.dataAry.count - 12;//最多不能超过4页
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        ProviderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProviderTableViewCell"];
        return cell;
    }
    ProviderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProviderTableViewCell"];
    NSInteger num = _baseScrollView.contentOffset.x / kUIScreenWidth;
    NSInteger index = num * 3 + indexPath.row;
    RecommendSupplyModel *model =  self.dataAry[index];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger num = _baseScrollView.contentOffset.x / kUIScreenWidth;
    NSInteger index = num * 3 + indexPath.row;
    RecommendSupplyModel *model =  self.dataAry[index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePageNumber:)]) {
        [self.delegate pushToDetailPageVC:model.Id];//跳转用的企业id
    }
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pageNumber = (_baseScrollView.contentOffset.x + kUIScreenWidth / 2) / kUIScreenWidth;
    UITableView *currentTable = self.tableList[pageNumber];
    [currentTable reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePageNumber:)]) {
        [self.delegate changePageNumber:pageNumber];
    }
}
//
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
