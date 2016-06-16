//
//  MoreRecommendViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/9.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MoreRecommendViewController.h"
#import "NewProductMoreTableViewCell.h"
#import "SupplyDetailViewController.h"
#import "ProOptionModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "LeaveMessageTableViewController.h"

#define kPageCount 15
#define KSecViewHeight 120
#define ksearchViewHight 50

@interface MoreRecommendViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UITableView *baseTable;
@property (nonatomic ,retain)UISearchBar * searchBar;

@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSString * keyword;

@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *titleArr2;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *secView;

@end

@implementation MoreRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供应信息";
    [self.view addSubview:self.baseTable];
    
    [self configSelectedView];
    
    self.type = @"";
    
    [self refreshNewData];
    [self getKeywordFromNet];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveMessage:) name:@"message" object:nil];
}


/**
 *  下拉
 */
- (void)refreshNewData{
    [self moveBack];
    self.dataAry = [NSMutableArray array];
    self.pageNum = 1;
    [self configerData];
}
/**
 *  上啦
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerData];
}
/**
 *  获得Keyword关键字
 */
- (void)getKeywordFromNet {
    NSString * netPath = @"news/keyword_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@(23) forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self getKeywordFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getKeywordFromResponseObj:(id)responseObj {
    NSDictionary * dict = responseObj[@"data"];
    [self.titleArr removeAllObjects];
    for (NSDictionary * smallDic in dict) {
        [self.titleArr2 addObject:smallDic[@"title"]];
    }
    if (self.titleArr2.count > 24) {
        NSRange rang = {0, 23};
        self.titleArr2 = [[self.titleArr2 subarrayWithRange:rang] mutableCopy];
    }
    [self selectBtnClick];
}
/**
 *  获得列表内容
 */
- (void)configerData{
    NSString * netPath = @"pro/pro_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    if (self.keyword) {
        [allParams setObject:self.keyword forKey:@"keyword"];
    }
    if (self.type) {//不等于空就是1或2
        [allParams setObject:self.type forKey:@"type"];
    }
    MyLog(@"----------%@", allParams);
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromRespomseObjAboutSearch:responseObj];
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  解析数据
 */
- (void)getDataFromRespomseObjAboutSearch:(id)responseObj{
//    MyLog(@"%@", responseObj);
    if ([responseObj[@"data"]isKindOfClass:[NSNull class]]) {
    }else{
        if (self.pageNum == 1) {
            self.dataAry = [NSMutableArray array];
        }
        NSArray * listAry = responseObj[@"data"];
        MyLog(@"%@",responseObj[@"data"]);
        for (NSDictionary * dict in listAry) {
            ProOptionModel * model = [ProOptionModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTable reloadData];
}

#pragma mark ---UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [searchBar resignFirstResponder];
        self.keyword = searchText;
        [self refreshNewData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.keyword = searchBar.text;
    [self refreshNewData];
}

/**
 *  配置UI
 */
- (void)configSelectedView {
    
    if (self.secView) {
        [self.secView removeFromSuperview];
    }
    
    MyLog(@"titleArr.count--%ld",self.titleArr.count);
    
    //搜素框
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, ksearchViewHight)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    [searchView addSubview:self.searchBar];
    
    self.secView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame), kUIScreenWidth, KSecViewHeight)];
    _secView.backgroundColor = RGBColor(240, 240, 240);
    [self.view addSubview:_secView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kUIScreenWidth / 2, 21)];
    label.text = @"大家都在搜";
    label.font = [UIFont systemFontOfSize:16.0];
    [_secView addSubview:label];
    
    //换一批按钮
    UIButton *selecteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selecteBtn.frame = CGRectMake( kUIScreenWidth - 80, 10, 70, 21);
    [selecteBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [selecteBtn setImage:img(@"searchNext") forState:UIControlStateNormal];
    selecteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [selecteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    selecteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    selecteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [selecteBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_secView addSubview:selecteBtn];
    
    CGFloat Width = (kUIScreenWidth - 60) / 3;
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        optionBtn.frame = CGRectMake(20 +  (Width + 10) * (i%3), 38 + (21 + 20) * (i/3), Width, 31);
        [optionBtn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        optionBtn.layer.cornerRadius = 10.0f;
        optionBtn.layer.borderWidth = 0.001f;
        optionBtn.layer.masksToBounds = YES;
        [optionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        optionBtn.backgroundColor = [UIColor whiteColor];
        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_secView addSubview:optionBtn];
    }
    
    //底部的灰线
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.secView.frame.size.height - 2, kUIScreenWidth, 1)];
    bottomLineView.backgroundColor = RGBColor(164, 164, 164);
    [self.secView addSubview:bottomLineView];
}

- (void)selectBtnClick {
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    if (self.titleArr2.count > 6) {
        NSInteger count = (self.titleArr2.count - 1) / 6;
        switch (count) {
            case 1: {
                NSArray *subArr1 = [self.titleArr2 subarrayWithRange:NSMakeRange(0, 6)];
                NSArray *subArr2 = [self.titleArr2 subarrayWithRange:NSMakeRange(6, self.titleArr2.count - 6)];
                [muArr addObject:subArr1];
                [muArr addObject:subArr2];
            }
                break;
            case 2: {
                NSArray *subArr1 = [self.titleArr2 subarrayWithRange:NSMakeRange(0, 6)];
                NSArray *subArr2 = [self.titleArr2 subarrayWithRange:NSMakeRange(6, 6)];
                NSArray *subArr3 = [self.titleArr2 subarrayWithRange:NSMakeRange(12, self.titleArr2.count - 12)];
                [muArr addObject:subArr1];
                [muArr addObject:subArr2];
                [muArr addObject:subArr3];
            }
                break;
            case 3: {
                NSArray *subArr1 = [self.titleArr2 subarrayWithRange:NSMakeRange(0, 6)];
                NSArray *subArr2 = [self.titleArr2 subarrayWithRange:NSMakeRange(6, 6)];
                NSArray *subArr3 = [self.titleArr2 subarrayWithRange:NSMakeRange(12, 6)];
                NSArray *subArr4 = [self.titleArr2 subarrayWithRange:NSMakeRange(18, self.titleArr2.count - 18)];
                [muArr addObject:subArr1];
                [muArr addObject:subArr2];
                [muArr addObject:subArr3];
                [muArr addObject:subArr4];
            }
                break;
            default:
                break;
        }
        
        if (count == 1) {
            if (self.index == 2) {
                self.index = 0;
            }
            self.titleArr = muArr[self.index];
        }else if (count == 2){
            if (self.index == 3) {
                self.index = 0;
            }
            self.titleArr = muArr[self.index];
            
        }else if (count == 3){
            if (self.index == 4) {
                self.index = 0;
            }
            self.titleArr = muArr[self.index];
        }else {
            
        }
        self.index++;
    } else {
        //不用操作,直接赋值
        self.titleArr = self.titleArr2;
    }
    
    [self configSelectedView];
}

- (void)optionBtnClick:(UIButton *)sender {
    self.keyword = sender.titleLabel.text;
    self.searchBar.text = sender.titleLabel.text;
    [self refreshNewData];
}

//取消搜索框背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  左侧按钮点击事件
 */
- (void)leftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Lazy Loading
- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc] init];
    }
    return _titleArr;
}

- (NSMutableArray *)titleArr2 {
    if (!_titleArr2) {
        _titleArr2 = [[NSMutableArray alloc] init];
    }
    return _titleArr2;
    
}

-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, kUIScreenWidth - 20, 50)];
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder = @"关键字";
        _searchBar.searchBarStyle = 2;
        _searchBar.delegate =self;
        _searchBar.showsCancelButton = NO;
    }
    return _searchBar;
}

-(UITableView *)baseTable{
    if (!_baseTable) {
        _baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, ksearchViewHight + KSecViewHeight, kUIScreenWidth, kUIScreenHeight- (ksearchViewHight + KSecViewHeight)) style:UITableViewStylePlain];
        _baseTable.rowHeight = 105 * KProportionHeight;
        _baseTable.delegate =self;
        _baseTable.dataSource = self;
        _baseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTable.tableFooterView = [[UIView alloc] init];
        //集成下拉刷新和上拉加载
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"NewProductMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"newProductMoreCell"];
        //
        _baseTable.emptyDataSetDelegate = self;
        _baseTable.emptyDataSetSource = self;
    }
    return _baseTable;
}
#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"未搜索到相关信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}

#pragma mark - UIScrollerDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:1 animations:^{
        self.secView.alpha = 0;
        [UIView animateWithDuration:5 animations:^{
            self.baseTable.frame = CGRectMake(0, ksearchViewHight, kUIScreenWidth, kUIScreenHeight- ksearchViewHight);
        }];
    }];
    
}

- (void)moveBack {
    [UIView animateWithDuration:1 animations:^{
        self.secView.alpha = 1;
        self.baseTable.mj_offsetY = 0;
        self.baseTable.frame = CGRectMake(0, ksearchViewHight + KSecViewHeight, kUIScreenWidth, kUIScreenHeight-( ksearchViewHight + KSecViewHeight));
    }];
}

#pragma mark --UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        NewProductMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newProductMoreCell"];
        return cell;
    }
    NewProductMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newProductMoreCell"];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
    supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
    [self.navigationController pushViewController:supplyVC animated:YES];
}

- (void)leaveMessage:(NSNotification *)no {
    NSString *id = no.userInfo[@"id"];
    LeaveMessageTableViewController *leavemessage = [[LeaveMessageTableViewController alloc] init];
    leavemessage.chanpinID = id;
    [self.navigationController pushViewController:leavemessage animated:YES];
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
