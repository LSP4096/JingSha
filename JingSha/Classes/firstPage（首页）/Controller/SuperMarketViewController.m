//
//  SuperMarketViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SuperMarketViewController.h"
#import "JingSha-Prefix.pch"
#import "SupplyDetailViewController.h"
#import "SuppleMsgModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SuperMarketTabViewCell.h"
#import "LeaveMessageTableViewController.h"
#import "HttpClient+FirstPage.h"

#define kPageCount 15
#define ksearchViewHight 50
#define KSecViewHeight 120

@interface SuperMarketViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource,
UISearchBarDelegate
>

@property (nonatomic, strong) UITableView *baseTabView;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, copy)NSString * keyword;

@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *titleArr2;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *secView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SuperMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"交易中心";
    [self loadData];
    [self configOptionBtn];
    [self RefreshNewData];
    [self.view addSubview:self.baseTabView];
    self.pageNum = 1;
    self.index = 0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveMessage:) name:@"ExchangeSign" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ExchangeSign" object:nil];
}

- (void)liveMessage:(NSNotification *)info {
    LeaveMessageTableViewController *leaveMess = [LeaveMessageTableViewController new];
    leaveMess.chanpinID = [info.userInfo objectForKey:@"id"];
    [self.navigationController pushViewController:leaveMess animated:YES];
}

- (void)configOptionBtn {
    
    if (_secView) {
        [_secView removeFromSuperview];
    }
    
    //searchBar底部的View
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, ksearchViewHight)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    [searchView addSubview:self.searchBar];
    
    //选择按钮底部的view
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
        optionBtn.frame = CGRectMake(20 +  (Width + 10) * (i%3), 40 + (21 + 20) * (i/3), Width, 31);
        [optionBtn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        optionBtn.layer.cornerRadius = 10.0f;
        optionBtn.layer.borderWidth = 0.001f;
        optionBtn.layer.masksToBounds = YES;
        [optionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        optionBtn.backgroundColor = [UIColor whiteColor];
        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_secView addSubview:optionBtn];
    }
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _secView.frame.size.height - 2, kUIScreenWidth, 1)];
    bottomLineView.backgroundColor = RGBColor(164, 164, 164);
    [_secView addSubview:bottomLineView];
    
}

- (void)selectBtnClick {
    
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    
    if (self.titleArr2.count > 6) {
        NSInteger count = self.titleArr2.count / 6;
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
    
    [self configOptionBtn];
}

- (void)optionBtnClick:(UIButton *)sender {
    self.keyword = sender.titleLabel.text;
    self.searchBar.text = sender.titleLabel.text;
    [self RefreshNewData];
}

- (void)configerDataWithPage:(NSInteger)page{

    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    @WeakObj(self)
    [[HttpClient sharedClient] getExchangesCenterWithPage:page
                                                PageCount:kPageCount
                                                     Type:2
                                                  KeyWord:self.keyword
                                              Complection:^(id resoutObj, NSError *error) {
                                                  
                                                  [MBProgressHUD hideHUDForView:self.view];
                                                  @StrongObj(self)
                                                  if (error) {
                                                      
                                                      MyLog(@"%@",error);
                                                  }else {
                                                      
                                                      [Strongself getDataFromResponseObj:resoutObj];
                                                      [_baseTabView.header endRefreshing];
                                                      [_baseTabView.footer endRefreshing];
                                                  }
                                              }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    
    if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {//数据为空
        //
    }else{
        if (_pageNum == 1) {
            self.dataAry = [NSMutableArray array];
        }
        
        MyLog(@"respons %@",responseObj);
        
        for (NSDictionary * dict in responseObj[@"data"]) {
            SuppleMsgModel * model = [SuppleMsgModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTabView reloadData];
}

/**
 *  刷新新数据
 */
- (void)RefreshNewData{
    
    [self moveBack];

    [self.dataAry removeAllObjects];
    [self configerDataWithPage:1];
    self.pageNum = 1;
}
/**
 *  加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerDataWithPage:self.pageNum];
}
/**
 *  获得关键字
 *
 */
- (void)loadData{
    @WeakObj(self);
    [[HttpClient sharedClient] getKeywordWithCid:23
                                     Complection:^(id resoutObj, NSError *error) {
                                         
                                         @StrongObj(self);
                                         if (!error) {
                                             Strongself.titleArr = [NSMutableArray array];
                                             Strongself.titleArr2 = [NSMutableArray array];
                                             NSDictionary * dict = resoutObj[@"data"];
                                             [Strongself.titleArr removeAllObjects];
                                             for (NSDictionary * smallDic in dict) {
                                                 [Strongself.titleArr2 addObject:smallDic[@"title"]];
                                             }
                                             
                                             if (Strongself.titleArr2.count > 24) {
                                                 NSRange range = {0, 23};
                                                 Strongself.titleArr2 = [[Strongself.titleArr2 subarrayWithRange:range] mutableCopy];
                                             }
                                             [Strongself selectBtnClick];
                                         }else {
                                             
                                         }
    }];
}


#pragma mark -Lazy Loading
- (NSMutableArray *)titleArr2 {
    if (!_titleArr2) {
        _titleArr2 = [NSMutableArray new];
    }
    return  _titleArr2;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [[NSMutableArray array] init];
    }
    return _titleArr;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [[NSMutableArray alloc] init];
    }
    return _dataAry;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, kUIScreenWidth - 20, ksearchViewHight - 10)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入产品关键字";
        _searchBar.searchBarStyle = 2;
        _searchBar.showsCancelButton = NO;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    }
    return _searchBar;
}

//取消searchbar背景色
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

-(UITableView *)baseTabView{
    if (!_baseTabView) {
        
        _baseTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + ksearchViewHight + KSecViewHeight, kUIScreenWidth, kUIScreenHeight- (kNavigationBarHeight + ksearchViewHight + KSecViewHeight)) style:UITableViewStylePlain];
        _baseTabView.backgroundColor = [UIColor whiteColor];
        _baseTabView.delegate = self;
        _baseTabView.dataSource = self;
        //
        
        _baseTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _baseTabView.rowHeight = 118 * KProportionHeight;
        
        _baseTabView.emptyDataSetDelegate = self;
        _baseTabView.emptyDataSetSource = self;
        
        _baseTabView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewData)];
        _baseTabView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [_baseTabView registerNib:[UINib nibWithNibName:@"SuperMarketTabViewCell" bundle:nil] forCellReuseIdentifier:@"marketCell"];
    }
    return _baseTabView;
}

#pragma mark --UITableView 的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyLog(@"%ld",self.dataAry.count);
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataAry.count == 0) {
        SuperMarketTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell"];
        return cell;
    }
    SuperMarketTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell"];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataAry[indexPath.row] Id], KUserImfor[@"userid"]];
    supplyVC.chanpinId = [self.dataAry[indexPath.row] Id];
    [self.navigationController pushViewController:supplyVC animated:YES];
}
#pragma mark - UIScrollerDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:1 animations:^{
//        self.secView.transform = CGAffineTransformMakeTranslation(0, -200);
        self.secView.alpha = 0;
        [UIView animateWithDuration:5 animations:^{
            self.baseTabView.frame = CGRectMake(0, kNavigationBarHeight + ksearchViewHight, kUIScreenWidth, kUIScreenHeight- (kNavigationBarHeight + ksearchViewHight));
        }];
    }];
    
}

- (void)moveBack {
    [UIView animateWithDuration:1 animations:^{
//        self.secView.transform = CGAffineTransformIdentity;
        self.secView.alpha = 1;
        self.baseTabView.frame = CGRectMake(0, kNavigationBarHeight + ksearchViewHight + KSecViewHeight, kUIScreenWidth, kUIScreenHeight- (kNavigationBarHeight + ksearchViewHight + KSecViewHeight));
        self.baseTabView.mj_offsetY = 0;
    }];
}

#pragma mark-- UISearchBar代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [_searchBar resignFirstResponder];
        self.keyword = searchText;
        [self RefreshNewData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.keyword = searchBar.text;
    [self RefreshNewData];
}

#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无相关信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}
@end
