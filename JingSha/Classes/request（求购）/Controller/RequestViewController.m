//
//  RequestViewController.m
//  
//
//  Created by bocweb on 15/11/12.
//
//

#import "RequestViewController.h"
#import "JingSha-Prefix.pch"
#import "MyQuotedViewController.h"
#import "WantBuyTableViewCell.h"
#import "RequestDetailViewController.h"//H5页面，这个用不着了
#import "RequestMsgModel.h"
 #import "UIScrollView+EmptyDataSet.h"
#import "IssueRequestViewController.h"
#import "SingUpViewController.h"

#import "HttpClient+FirstPage.h"

#define kTopViewHeight 65
#define KSecViewHeight 120
#define kPageCount 15
#define ksearchViewHight 50

@interface RequestViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UITableView * baseTable;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray * dataAry;
@property (nonatomic, copy) NSString * wanStr;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *secView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *titleArr2;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) UIView *searchView;

@end

@implementation RequestViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBaoJiaBtn1:) name:@"BaoJia" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BaoJia" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kTopViewHeight)];
    view.backgroundColor = RGBColor(61, 101, 160);
    [self.view addSubview:view];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, kUIScreenWidth - 90, 50)];
    titleLable.text = @"求购信息";
    titleLable.font = [UIFont systemFontOfSize:18.0];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLable];
    
    self.index = 0;

    [self loadData];
    //返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(5, 20, 40, 40);
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn setImage:[UIImage imageNamed:@"tab-left"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_backBtn];
    
    //搜素框
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, ksearchViewHight)];
    self.searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    
    [self.searchView addSubview:self.searchBar];

    //UITableView
    [self.view addSubview:self.baseTable];
    
    self.pageNum = 1;
    self.dataAry = [NSMutableArray array];
    [self refreshNewData];
}

#pragma mark--Lazy Loading
- (NSMutableArray *)titleArr2 {
    if (!_titleArr2) {
        _titleArr2 = [NSMutableArray new];
    }
    return  _titleArr2;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray new];
    }
    return _titleArr;
}

-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, kUIScreenWidth - 20, 50)];
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder = @"请输入求购关键字";
        _searchBar.searchBarStyle = 2;
        _searchBar.delegate =self;
        _searchBar.showsCancelButton = NO;
    }
    return _searchBar;
}

- (UITableView *)baseTable{
    if (!_baseTable) {
        _baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + KSecViewHeight + ksearchViewHight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - kTopViewHeight - ksearchViewHight - 20) style:UITableViewStylePlain];
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        _baseTable.rowHeight = 110 * KProportionHeight;
        _baseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTable.tableFooterView = [[UIView alloc] init];
        _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_baseTable registerNib:[UINib nibWithNibName:@"WantBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"wantCell"];
        //为了设置cell分割线的偏移
        if ([_baseTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_baseTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_baseTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [_baseTable setLayoutMargins:UIEdgeInsetsZero];
        }
        //
        _baseTable.emptyDataSetDelegate = self;
        _baseTable.emptyDataSetSource = self;
    }
    return _baseTable;
}

- (void)configOptionBtn {
    
    if (self.secView) {
        [self.secView removeFromSuperview];
    }
    
    MyLog(@"titleArr.count--%ld",self.titleArr.count);
    
    _secView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + ksearchViewHight, kUIScreenWidth, KSecViewHeight)];
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
    
    //底部的灰线
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.secView.frame.size.height - 2, kUIScreenWidth, 1)];
    bottomLineView.backgroundColor = RGBColor(164, 164, 164);
    [self.secView addSubview:bottomLineView];
    
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

- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    
    if ([tab.subviews count] < 2) {
        return;
    }
    UIView *view;
    
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
    }
    self.view.frame = view.frame;
    self.tabBarController.tabBar.hidden = hidden;
}

- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  下拉刷新
 */
- (void)refreshNewData{
    [self moveBack];
    
    [self.dataAry removeAllObjects];
    self.pageNum = 1;
    [self configerData];
}
/**
 *  上拉加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerData];
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

/**
 *  获取原始数据
 */
- (void)configerData{
    @WeakObj(self);
    [[HttpClient sharedClient] getLasterRequestWithPage:self.pageNum
                                                  Count:kPageCount
                                                KeyWord:_keyword
                                            Complection:^(id resoutObj, NSError *error) {
                                                
                                                @StrongObj(self);
                                                if (!error) {
                                                    
                                                    [_baseTable.header endRefreshing];
                                                    [_baseTable.footer endRefreshing];
                                                    [Strongself getDataFromResponseObj:resoutObj];
                                                }else {
                                                    MyLog(@"首页求购信息错误:%@",error);
                                                }
    }];
}

- (void)getDataFromResponseObj:(id)responseObj {
    if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {//数据为空
        //
    }else{
        if (_pageNum == 1) {
            self.dataAry = [NSMutableArray array];
        }
        
        MyLog(@"respons %@",responseObj);
        
        for (NSDictionary * dict in responseObj[@"data"]) {
            RequestMsgModel * model = [RequestMsgModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseTable reloadData];
}

#pragma mark-- UISearchBar代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [_searchBar resignFirstResponder];
        [self.dataAry removeAllObjects];
        self.keyword = searchText;
        [self refreshNewData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.dataAry removeAllObjects];
    self.keyword = searchBar.text;
    [self refreshNewData];
}


/**
 *  导航栏右侧按钮
 */
//- (void)configerRigTopButton{
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 60, 30);
//    [button setTitle:@"我的报价" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//}

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

#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无求购信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}

#pragma mark ---UITableView的代理方法

// 这个会在表格视图的其中一个单元变为可视前立刻被调用，它是你在表格视图单元显示在屏幕上之前的外观定制的最后机会
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
        return cell;
    }
    WantBuyTableViewCell * cell = [_baseTable dequeueReusableCellWithIdentifier:@"wantCell"];
    cell.model = self.dataAry[indexPath.row];
    cell.myBaojia = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    [self.baseTable deselectRowAtIndexPath:indexPath animated:YES];
    
    RequestDetailViewController * requestDetailVC = [[RequestDetailViewController alloc] init];
    RequestMsgModel * model = self.dataAry[indexPath.row];
    requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.Id, KUserImfor[@"userid"]];
    requestDetailVC.Id = model.Id;
    requestDetailVC.shareContent = model.jianjie;
    requestDetailVC.shareTitle = model.title;
    [self.navigationController pushViewController:requestDetailVC animated:YES];
}

#pragma mark - UIScrollerDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:1 animations:^{
        //        self.secView.transform = CGAffineTransformMakeTranslation(0, -200);
        self.secView.alpha = 0;
        [UIView animateWithDuration:5 animations:^{
            self.baseTable.frame = CGRectMake(0, kNavigationBarHeight + ksearchViewHight, kUIScreenWidth, kUIScreenHeight- (kNavigationBarHeight + ksearchViewHight));
        }];
    }];
    
}

- (void)moveBack {
    [UIView animateWithDuration:1 animations:^{
        //        self.secView.transform = CGAffineTransformIdentity;
        self.secView.alpha = 1;
        
        self.baseTable.frame = CGRectMake(0, kNavigationBarHeight + ksearchViewHight + KSecViewHeight, kUIScreenWidth, kUIScreenHeight- (kNavigationBarHeight + ksearchViewHight + KSecViewHeight));
        self.baseTable.mj_offsetY = 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)optionBtnClick:(UIButton *)sender {
    self.keyword = sender.titleLabel.text;
    self.searchBar.text = sender.titleLabel.text;
    [self refreshNewData];
}

- (void)clickBaoJiaBtn1:(NSNotification *)no {
    NSString *id = no.userInfo[@"id"];
    SingUpViewController * singUpVC = [[SingUpViewController alloc] init];
    singUpVC.Id = id;
    [self.navigationController pushViewController:singUpVC animated:YES];
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
