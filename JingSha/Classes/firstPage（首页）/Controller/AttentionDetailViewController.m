//
//  AttentionDetailViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#define kPageCount 10
#define kEachPageCount 10
#define KCollectionBtnHeight 45
#define KsmallBGLabelHeight 3
#import "AttentionDetailViewController.h"
//#import "AttentionCollectionViewCell.h"
#import "SupplyDetailViewController.h"
#import "AttentionDetailTableViewCell.h"
#import "ProOptionModel.h"
//企业
#import "RecommendSupplierTableViewCell.h"
#import "RecommendDetailViewController.h"
#import "RecommendOptionViewController.h"
#import "CompanyListModel.h"
//资讯
#import "SearchModel.h"
#import "SearchTableViewCell.h"
#import "SearchResultTableViewCell.h"
#import "XWNewsDetailViewController.h"
//求购
#import "JingSha-Prefix.pch"
#import "MyQuotedViewController.h"
#import "WantBuyTableViewCell.h"
#import "RequestDetailViewController.h"//H5页面，这个用不着了
#import "RequestMsgModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "IssueRequestViewController.h"
//供应
#import "NewProductMoreTableViewCell.h"
#import "SupplyDetailViewController.h"
#import "ProOptionModel.h"

@interface AttentionDetailViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic,strong)UITableView * baseTable;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *currentSelectBtn;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UILabel *smallBGLabel;//btn上面的颜色条

@property (nonatomic, assign) NSInteger contentType; //上面四个按钮，按下的不同内容区分字符

@end

static NSString * indentifier = @"attentionCell";
@implementation AttentionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseTable];
    [self refreshNewData];

    self.type = 0;
    self.contentType = 1;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + KCollectionBtnHeight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - KCollectionBtnHeight) style:UITableViewStylePlain];
        
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        _baseTable.rowHeight = 112;
        _baseTable.tableFooterView = [[UIView alloc] init];
        //
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        //设置tabview头的四个btn;
        [self setTableViewHeaderView];
        //
        _baseTable.emptyDataSetDelegate = self;
        _baseTable.emptyDataSetSource = self;
       
        [self registCell];
        
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

//注册cell
- (void)registCell {
    // 企业
    [_baseTable registerNib:[UINib nibWithNibName:@"RecommendSupplierTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendSupplierCell"];
    // 资讯
    [_baseTable registerNib:[UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"filter"];
    // 求购
    [_baseTable registerNib:[UINib nibWithNibName:@"WantBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"wantCell"];
    // 供应
    [_baseTable registerNib:[UINib nibWithNibName:@"NewProductMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"newProductMoreCell"];
}
/***
    创建四个按钮
 ***/
- (void)setTableViewHeaderView {
    NSArray *names = @[@"企业", @"资讯", @"求购", @"供应"];
    CGFloat btnY = kNavigationBarHeight;
    CGFloat btnW = kUIScreenWidth / 4;
    CGFloat btnH = KCollectionBtnHeight;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        [btn setTitle:names[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        btn.backgroundColor = RGBColor(247, 247, 247);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.adjustsImageWhenHighlighted = NO;
        btn.adjustsImageWhenDisabled = NO;
        btn.tag = 1000+i;
        [self.view addSubview:btn];
        
        //默认显示资讯收藏
        if (i == 0) {
            self.currentSelectBtn = btn;
            btn.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btnW * i, kNavigationBarHeight, btnW, KsmallBGLabelHeight)];
            label.backgroundColor = RGBColor(255, 145, 0);
            [self.view addSubview:label];
            self.smallBGLabel = label;
        }
    }
}

///按钮响应事件
- (void)btnClick:(UIButton *)sender {
    
    _smallBGLabel.frame = CGRectMake(sender.x, sender.y, _smallBGLabel.width, _smallBGLabel.height);
    [self.view addSubview:_smallBGLabel];
    
    sender.selected = !sender.selected;
    if (sender != self.currentSelectBtn) {
        sender.backgroundColor = [UIColor whiteColor];
        self.currentSelectBtn.backgroundColor = RGBColor(249, 249, 249);
        self.currentSelectBtn = sender;
    }
    
    if (sender.tag == 1000) {
        self.contentType = 1;
        
    }else if (sender.tag == 1001){
        self.contentType = 2;
        
    }else if(sender.tag == 1002){
        self.contentType = 3;
        
    }
    else {
        self.contentType = 4;
        
    }
    [self refreshNewData];
}


//刷新数据
- (void)refreshNewData {
    self.pageNum = 1;
    [self.dataAry removeAllObjects];
    [self configerDataWithPage:1 keyword:self.titleName];
}
//加载更多
- (void)loadMoreData{
    if (self.dataAry.count * self.baseTable.rowHeight > self.view.frame.size.height) {
       self.pageNum++;
    [self configerDataWithPage:self.pageNum keyword:self.titleName]; 
    }
    else{
        MyLog(@"内容不足");
        [_baseTable.footer endRefreshing];
    }
}

/**
 *  获取企业原始数据
 */
- (void)configerDataWithPage:(NSInteger)page keyword:(NSString *)keyword{
    NSString *netPath = nil;
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(page) forKey:@"page"];
    [allParams setObject:keyword forKey:@"keyword"];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(self.type) forKey:@"type"];
    
    if (self.contentType == 4) {//供应
        netPath = @"pro/pro_list";
    }
    else if (self.contentType == 3) {//求购
        netPath = @"pro/buy_list";
    }
    else if (self.contentType == 2) {//资讯
        netPath = @"news/searchlist";
    }
    else {//企业
         netPath = @"pro/user_list";
    }
    
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
            if (((NSArray *)responseObj[@"data"]) == nil) {
                self.dataAry = nil;
                [self.baseTable reloadData];
                return ;
            }
            [self getDataFromResponseObj:responseObj];
            [_baseTable.header endRefreshing];
            [_baseTable.footer endRefreshing];
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
}

//数据解析
- (void)getDataFromResponseObj:(id)responseObj {
    if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {//没有数据
        self.dataAry = nil;
        [self.baseTable reloadData];
        return;
    }else{//有数据
        NSArray * dataAry = responseObj[@"data"];
        for (NSDictionary * dict in dataAry) {//企业 数据解析
            if (_contentType == 1) {
                CompanyListModel * model = [CompanyListModel objectWithKeyValues:dict];
                [self.dataAry addObject:model];
            }
            else if (_contentType == 2) {//资讯
                SearchModel *item = [SearchModel objectWithKeyValues:dict];
                [self.dataAry addObject:item];
            }
            else if (_contentType == 3) {//求购
                RequestMsgModel * model = [RequestMsgModel objectWithKeyValues:dict];
                [self.dataAry addObject:model];
            }
            else {//供应
                ProOptionModel * model = [ProOptionModel objectWithKeyValues:dict];
                [self.dataAry addObject:model];
            }
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

// 这个会在表格视图的其中一个单元变为可视前立刻被调用，它是你在表格视图单元显示在屏幕上之前的外观定制的最后机会
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contentType == 3) {
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_contentType == 1) {//企业
        RecommendSupplierTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"RecommendSupplierCell" forIndexPath:indexPath];
        cell.model = self.dataAry[indexPath.row];
        return cell;
    }
    else if (_contentType == 2) {//资讯
        SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filter" forIndexPath:indexPath];
        //当前输入框有内容,显示搜索内容
        SearchModel *model = self.dataAry[indexPath.row];
        [cell configureDataWithModel:model inputString:self.titleName];
        return cell;
    }
    else if (_contentType == 3) {//求购
        if (self.dataAry.count == 0) {
            WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
            return cell;
        }
        WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
        cell.model = self.dataAry[indexPath.row];
        cell.myBaojia = NO;
        return cell;
    }
    else {//供应
        if (self.dataAry.count == 0) {
            NewProductMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newProductMoreCell"];
            return cell;
        }
        NewProductMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newProductMoreCell"];
        cell.model = self.dataAry[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_contentType == 1) {//企业
        RecommendDetailViewController *detailVC  =[RecommendDetailViewController new];
        detailVC.qiyeId = [self.dataAry[indexPath.row] Id];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (_contentType == 2) {//资讯
        XWNewsDetailViewController *detailVC = [[XWNewsDetailViewController alloc] init];
        NSString *str = ((SearchModel *)self.dataAry[indexPath.row]).newsid;
        detailVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/newsinfo/%@", str];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (_contentType == 3) {//求购
        RequestDetailViewController * requestDetailVC = [[RequestDetailViewController alloc] init];
        RequestMsgModel * model = self.dataAry[indexPath.row];
        requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.Id, KUserImfor[@"userid"]];
        requestDetailVC.Id = model.Id;
        requestDetailVC.shareContent = model.jianjie;
        requestDetailVC.shareTitle = model.title;
        [self.navigationController pushViewController:requestDetailVC animated:YES];
    }
    else {//供应
        SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
        supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
        supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
        [self.navigationController pushViewController:supplyVC animated:YES];
    }
}

@end
