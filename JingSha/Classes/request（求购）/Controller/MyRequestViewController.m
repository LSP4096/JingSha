
//  MyRequestViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/3.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "MyRequestViewController.h"
#import "WantBuyTableViewCell.h"
#import "RequestMessageViewController.h"
#import "IssueRequestViewController.h"
#import "RequestDetailViewController.h"
#import "RequestMsgModel.h"
#import "FirstPageSearchViewController.h"
//#import "UIScrollView+EmptyDataSet.h"
@interface MyRequestViewController ()<UITableViewDataSource, UITableViewDelegate>
//, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
@property (nonatomic, strong)UIView * topView;
@property (nonatomic, strong)NSMutableArray * buttonsAry;
@property (nonatomic, strong)UIButton * button;
@property (nonatomic, strong)UIButton * rightBut;
@property (nonatomic, strong)UIView * menuView;
@property (nonatomic, assign)BOOL isHidden;

@property (nonatomic, strong)UITableView *baseTable;
@property (nonatomic, copy)NSString * titleString;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger typeNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, strong)NSString * wanStr;
@end
#define kPageCount 15
#define KTabBarHeight 45

@implementation MyRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的求购";
    _menuView.hidden = YES;
    self.pageNum = 1;
    self.typeNum = 1;
    self.dataAry =  [NSMutableArray array];
    [self configerTopView];//首次调用下拉刷新的方法在这个方法里
    [self configerTableView];
    [self configerRightButtonAndMenu];
//    [self rightBarButtonClicked];//第一次进入主动调用，隐藏
//    self.tabBarController.tabBar.hidden = YES;
    [self configerBottomView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    if (!self.fromMe) {
//        [self configerLeftBarBtn];
    }
//    [self refreshNewData];
}
//- (void)configerLeftBarBtn{
//    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 15, 15);
//    self.navigationItem.leftBarButtonItem  =[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    [leftBtn setImage:[UIImage imageNamed:@"tab-left"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//}
//- (void)leftBarBtnClicked:(UIButton *)sender{
//    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.selectedIndex = 0;
//}
- (void)configerBottomView{
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.fromMe) {
        bottomBtn.frame = CGRectMake(0, kUIScreenHeight - 45, kUIScreenWidth, 45);
    }else {
        bottomBtn.frame = CGRectMake(0, kUIScreenHeight - 45 - KTabBarHeight, kUIScreenWidth, 45);
    }
    [bottomBtn setTitle:@"发布求购" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bottomBtn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTintColor:[UIColor whiteColor]];
    [bottomBtn setBackgroundColor:RGBColor(45,78,147) forState:UIControlStateNormal];
    [self.view addSubview:bottomBtn];
}
- (void)bottomClicked:(UIButton *)sender{
    
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getWanStr:responseObj];
    } failure:^(NSError *error) {
        
    }];
}
- (void)getWanStr:(id)response{
    _wanStr = response[@"data"][@"wan"];
    MyLog(@"*****%@", _wanStr);
    if ([_wanStr isEqualToString:@"0"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"企业信息未完善,不能发布" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        IssueRequestViewController * issueVC = [[IssueRequestViewController alloc] init];
        [self.navigationController pushViewController:issueVC animated:YES];
    }
}
//首次调用下拉刷新的方法在上边的方法里
- (void)configerDataFromPage:(NSInteger)page type:(NSInteger)type{
    NSString * netPath = @"userinfo/my_buy_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(page) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(type) forKey:@"type"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}
- (void)getDataFromResponseObj:(id)responseObj{
    if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        for (NSDictionary * dict in responseObj[@"data"]) {
            RequestMsgModel * model = [RequestMsgModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [self.baseTable reloadData];
}
#pragma mark --
- (void)configerTopView{
    NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"求购中", @"审核/其他", nil];
    self.buttonsAry = [@[]mutableCopy];
    for (int i = 0; i < 2; i++) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0 + (kUIScreenWidth/2)*i, kNavigationBarHeight, kUIScreenWidth/2, 45);
        _button.backgroundColor = RGBColor(250, 250, 250);
        [_button setTitleColor:RGBColor(104, 104, 104) forState:UIControlStateNormal];
        [_button setTitle:titleAry[i] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = RGBColor(231, 231, 231).CGColor;
        _button.tag = 1000 + i;
        [self.buttonsAry addObject:_button];
        [_button addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
        if (_button.tag == 1000) {
            [self selectButtonClicked:_button];////首次调用下拉刷新的方法
        }
    }
}
- (void)selectButtonClicked:(UIButton *)sender{//1求购中  3审核/其他  （2已达成 不要了）
    if (sender.tag == 1001) {
        self.titleString = @"审核中";
        self.typeNum = 3;
    }else{
        self.titleString = sender.titleLabel.text;
        self.typeNum = 1;
    }

    if (self.topView) {
        [self.topView removeFromSuperview];
    }
    sender.backgroundColor = RGBColor(236, 236, 236);//选中的颜色
    for (UIButton * button in self.buttonsAry) {
        if (button.tag != sender.tag) {
            [button setBackgroundColor:RGBColor(250, 250, 250)];//未选中的颜色
        }
    }
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0 + (kUIScreenWidth/2) * (sender.tag - 1000), kNavigationBarHeight, kUIScreenWidth/2, 2)];
    _topView.backgroundColor = RGBColor(249, 153, 56);
    [self.view addSubview:_topView];
    //是哪种状态的信息
//    self.typeNum = sender.tag - 999;
    [self refreshNewData];
    [_baseTable reloadData];
}
/**
 *  配置UITableView
 */
- (void)configerTableView{
    self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 45, kUIScreenWidth, kUIScreenHeight - 45 - kNavigationBarHeight - 45) style:UITableViewStylePlain];
    _baseTable.delegate = self;
    _baseTable.dataSource  =self;
    _baseTable.rowHeight = 93;
    [self.view addSubview:_baseTable];
    _baseTable.tableFooterView = [[UIView alloc] init];
    _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //注册cell
    [_baseTable registerNib:[UINib nibWithNibName:@"WantBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"wantCell"];
    //
//    _baseTable.emptyDataSetDelegate = self;
//    _baseTable.emptyDataSetSource = self;
}
/**
 *  下拉刷新
 */
- (void)refreshNewData{
    [self.dataAry removeAllObjects];
    self.pageNum = 1;
    [self configerDataFromPage:self.pageNum type:self.typeNum];
}

- (void)loadMoreData{
    self.pageNum++;
    [self configerDataFromPage:self.pageNum type:self.typeNum];
}

/**
 *  右上角“全部”按钮及下拉菜单
 */
- (void)configerRightButtonAndMenu{
    self.rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBut.frame = CGRectMake(0, 0, 60, 20);
//    [_rightBut addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  =[[UIBarButtonItem alloc] initWithCustomView:_rightBut];
//    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth - (kUIScreenWidth/3 - 10), kNavigationBarHeight, kUIScreenWidth/3 - 10, 90)];
//    _menuView.backgroundColor = RGBColor(254, 254, 254);
    [_rightBut setTitle:@"报价信息" forState:UIControlStateNormal];
    _rightBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [_rightBut addTarget:self action:@selector(rightBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:_menuView];
    /*
    //配置下拉菜单上的两个按钮
    for (int i = 0; i < 2; i++) {
        NSArray * array = @[@"发布求购",@"求购信息"];
        UIButton * but1 = [UIButton buttonWithType:UIButtonTypeCustom];
        but1.frame = CGRectMake(0, 0 + 45 * i, _menuView.width, 45);
        but1.titleLabel.font = [UIFont systemFontOfSize:14];
        [but1 setTitleColor:RGBColor(106, 106, 106) forState:UIControlStateNormal];
        [but1 setTitle:array[i] forState:UIControlStateNormal];
        but1.layer.borderWidth = .5;
        but1.layer.borderColor = RGBColor(223, 223, 224).CGColor;
        [_menuView addSubview:but1];
        [but1 addTarget:self action:@selector(menuBuuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
     */
}
- (void)rightBarBtnClicked:(UIButton *)sender{
    RequestMessageViewController * requestMassageVC = [[RequestMessageViewController alloc] init];
    [self.navigationController pushViewController:requestMassageVC animated:YES];
}


/**
 *  右上角按钮响应事件
 */
/*
- (void)rightBarButtonClicked{
    if (_isHidden) {
        _menuView.hidden = YES;
        [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    }else{
        _menuView.hidden = NO;
        [_rightBut setImage:[UIImage imageNamed:@"Request_open"] forState:UIControlStateNormal];
    }
    _isHidden = !_isHidden;
}
 */
/**
 *  下拉菜单的按钮点击响应事件
 */
/*
- (void)menuBuuttonClicked:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"求购信息"]) {
        //求购信息界面
        RequestMessageViewController * requestMassageVC = [[RequestMessageViewController alloc] init];
        [self.navigationController pushViewController:requestMassageVC animated:YES];
    }else{
        //发布求购界面
        IssueRequestViewController * issueVC = [[IssueRequestViewController alloc] init];
        [self.navigationController pushViewController:issueVC animated:YES];
    }
    _menuView.hidden = YES;
    _isHidden = !_isHidden;
    [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
}
 */
/*
 //在这里用这个会使内容切换时，闪一下背景图片
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
*/
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        WantBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wantCell"];
        return cell;
    }
    WantBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wantCell"];
    cell.model = self.dataAry[indexPath.row];
    cell.myBaojia = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestDetailViewController * requestDetailVC = [[RequestDetailViewController alloc] init];
    RequestMsgModel * model = self.dataAry[indexPath.row];
    requestDetailVC.HTMLUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/buyinfo/%@/%@", model.Id, KUserImfor[@"userid"]];
    requestDetailVC.Id = model.Id;
    requestDetailVC.isCanAlter = YES;
    [self.navigationController pushViewController:requestDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
