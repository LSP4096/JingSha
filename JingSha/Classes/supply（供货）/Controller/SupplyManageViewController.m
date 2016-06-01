//
//  SupplyManageViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SupplyManageViewController.h"
#import "SupplyManageTableViewCell.h"
#import "ProductMessageTableViewController.h"
#import "RKNotificationHub.h"
#import "AddSupplyViewController.h"
#import "selectFooterView.h"
#import "MySupplyModel.h"
#import "SupplyDetailViewController.h"
@interface SupplyManageViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate,selectFooterViewDelegate>

@property (nonatomic, assign)BOOL isHidden;
@property (nonatomic, strong)UIView *menuView;
@property (nonatomic, strong)UIButton * rightBut;
@property (nonatomic, strong)UIButton * button;
@property (nonatomic, strong)NSMutableArray * butAry;
@property (nonatomic, strong)NSMutableArray * changeButtonAry;
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, copy)NSString * titleString;
@property (nonatomic, strong)NSMutableArray * dataSourceAry;//数据源数组
@property (nonatomic, strong)selectFooterView * selectView;
@property (nonatomic, strong)NSMutableArray * updateDataAry;
@property (nonatomic, assign)BOOL isChoseAll;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString * zhuangtai;

@property (nonatomic, copy)NSString * totalShowing;
@property (nonatomic, copy)NSString * totalChecking;
@property (nonatomic, copy)NSString * newsCount;
@property (nonatomic, strong)UIButton * newsButton;
@property (nonatomic, strong)RKNotificationHub * hub;
@end
#define kPageCount 15
#define KTabBarHeight 45
static NSString * indentifier = @"cell1";
@implementation SupplyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供应管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNum = 1;
    self.type = 1;
    self.zhuangtai = @"2";
    self.dataSourceAry = [NSMutableArray array];
    [self congigerTopChangeButton];
    [self configerTableView];
    [self configerAddButton];
    
    [self configerRightTopBut];
    
    [self configerBottomView];
    _menuView.hidden = YES;
    self.updateDataAry = [@[]mutableCopy];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_baseTable reloadData];
}
- (void)configerRightTopBut{
    self.rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isChoseAll = NO;
    _rightBut.frame = CGRectMake(0, 0, 40, 30);
    [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    _rightBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBut addTarget:self action:@selector(rightTopButClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBut];
    //点击展开的菜单
    if (self.menuView) {
        [self.menuView removeFromSuperview];
    }
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth - 120, kNavigationBarHeight, 120, 120)];
    _menuView.backgroundColor  =[UIColor whiteColor];
    [self.view addSubview:_menuView];
    NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"展示中的产品",@"待审核的产品",@"产品消息",@"刷新产品", nil];
    self.butAry = [@[]mutableCopy];
    for (int i = 0; i< 4; i++) {
        UIButton * but =[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 30 * i, 120, 30);
        but.tag = 1000 + i;
        but.layer.borderWidth = 1;
        but.layer.borderColor = RGBColor(246, 246, 246).CGColor;
        [but setTitleColor:RGBColor(83, 83, 83) forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        but.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        if (i == 2){

        }else{
            [but setTitle:titleAry[i] forState:UIControlStateNormal];
        }
        [but addTarget:self action:@selector(butClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:but];
    }
}
/**
 * 右上角按钮 响应事件
 */
- (void)rightTopButClicked:(UIButton *)sender{
    if (self.isChoseAll) {//全选
        //找到所有的indexPath
        NSArray *arr = [self.baseTable indexPathsForRowsInRect:CGRectMake(0, 0, self.view.frame.size.width, self.baseTable.contentSize.height)];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.baseTable selectRowAtIndexPath:obj animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];
        self.updateDataAry = [NSMutableArray arrayWithArray:self.dataSourceAry];
        _selectView.string = [NSString stringWithFormat:@"%@%zd%@", @"已选择",self.updateDataAry.count, @"个供应产品"];
    }else{//展开，收起菜单
        if (_isHidden) {
            _menuView.hidden = YES;
            [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
        }else{
            _menuView.hidden = NO;
            [_rightBut setImage:[UIImage imageNamed:@"Request_open"] forState:UIControlStateNormal];
            [self refreshNewData];
        }
        _isHidden = !_isHidden;
    }
    [self findTotalCount];//请求数据，得出各自的显示数量
    [self configerNewsCount];
}
/**
 *  菜单按钮响应事件
 */
- (void)butClicked:(UIButton *)sender{
    _menuView.hidden = YES;
    [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    _isHidden = !_isHidden;
    
    if (sender.tag == 1000) {//展示中的产品
        MyLog(@"展示中的产品");
        self.zhuangtai = @"2";
        [self refreshNewData];
    }else if (sender.tag == 1001){//待审核的产品
         MyLog(@"待审核的产品");
        self.zhuangtai = @"1";
        [self refreshNewData];
    }else if (sender.tag == 1002){
        ProductMessageTableViewController * productVC = [[ProductMessageTableViewController alloc] init];
        [self.navigationController pushViewController:productVC animated:YES];
    }else{//产品刷新
        [self.baseTable setEditing:YES animated:YES];
        [_rightBut setTitle:@"全选" forState:UIControlStateNormal];
        [_rightBut setImage:nil forState:UIControlStateNormal];
        self.isChoseAll = YES;
        _selectView.hidden = NO;
        _baseTable.frame = CGRectMake(0, 120, kUIScreenWidth, kUIScreenHeight - 165);
        [self.baseTable reloadData];
    }
}

- (void)congigerTopChangeButton{
    self.changeButtonAry = [@[]mutableCopy];
    for (int i  = 0; i < 2; i++) {
        NSArray * titleAry = @[@"纱线",@"原料"];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(20 + (kUIScreenWidth - 40)/2 * i, 74, (kUIScreenWidth - 40)/2, 40);
        _button.layer.borderColor = RGBColor(30, 78, 145).CGColor;
        _button.layer.borderWidth = 1;
        [_button setTitle:titleAry[i] forState:UIControlStateNormal];
        _button.tag = 1001 + i;
        [_button setBackgroundColor:RGBColor(247, 247, 247) forState:UIControlStateNormal];
        [_button setTitleColor:RGBColor(30, 78, 145) forState:UIControlStateNormal];
        [self.changeButtonAry addObject:_button];
        [self.view addSubview:_button];
        if (_button.tag == 1001) {
            [self changeButtonClicked:_button];
        }
        [_button addTarget:self action:@selector(changeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)configerBottomView{
    self.selectView = [[selectFooterView alloc] initWithFrame:CGRectMake(0, kUIScreenHeight - 45, kUIScreenWidth, 45)];
    _selectView.delegate = self;
    _selectView.hidden = YES;
    [self.view addSubview:_selectView];
}
/**
 *  原料和纱线按钮点击切换显示内容
 */
- (void)changeButtonClicked:(UIButton *)sender{
    [sender setBackgroundColor:RGBColor(30, 78, 145) forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for (UIButton * button in self.changeButtonAry) {
        if (button.tag != sender.tag) {
            [button setBackgroundColor:RGBColor(247, 247, 247) forState:UIControlStateNormal];
            [button setTitleColor:RGBColor(30, 78, 145) forState:UIControlStateNormal];
        }
    }
    self.titleString = sender.titleLabel.text;
//    [self confirmRefresh];//调用确定刷新。。在这用主要是为了取消多选状态
    
    _selectView.hidden = YES;
    _baseTable.frame = CGRectMake(0, 120, kUIScreenWidth, kUIScreenHeight - 120);
    _baseTable.editing = NO;
    self.isChoseAll = NO;
    [_rightBut setTitle:@"" forState:UIControlStateNormal];
    [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    
    
    self.type = sender.tag - 1000;//每次点击按钮，保存是哪个类的。
    self.pageNum = 1;
    [self refreshNewData];

    if (_isHidden) {
        _menuView.hidden = YES;
        [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
        _isHidden = !_isHidden;
    }
}
/**
 *  上拉加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerDataWithPage:self.pageNum];
}
/**
 *  下拉刷新
 */
- (void)refreshNewData{
    [self.dataSourceAry removeAllObjects];
    [self configerDataWithPage:1];
    self.pageNum = 1;
}
- (void)configerDataWithPage:(NSInteger)page{
//    MyLog(@"***%d,%d",self.type, self.pageNum);
    NSString * netPath = @"userinfo/my_pro_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(page) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:@(self.type) forKey:@"type"];
    [allParams setObject:self.zhuangtai forKey:@"zhuangtai"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}
- (void)getDataFromResponseObj:(id)responseObj{
//    MyLog(@"JJJJ%@", responseObj);
    if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        for (NSDictionary * dict in responseObj[@"data"]) {
            MySupplyModel * model = [MySupplyModel objectWithKeyValues:dict];
            [self.dataSourceAry addObject:model];
        }
    }
    [_baseTable reloadData];
}


#pragma mark ---
- (void)configerAddButton{
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, kUIScreenHeight - 45 - KTabBarHeight, kUIScreenWidth, 45);
    [addButton setTitle:@"添加产品" forState:UIControlStateNormal];
    [addButton setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
    [addButton setBackgroundColor:RGBColor(45, 78, 147) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}
/**
 *  下边的添加产品按钮
 */
- (void)addButClicked:(UIButton *)sender{
    AddSupplyViewController * addSupplyVC = [[AddSupplyViewController alloc] init];
    if (self.type == 1) {//纱线
        addSupplyVC.typeString = @"纱线";
    }else{
        addSupplyVC.typeString = @"原料";
    }
    [self.navigationController pushViewController:addSupplyVC animated:YES];
}

- (void)configerTableView{
    self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kUIScreenWidth, kUIScreenHeight - 76 - 45) style:UITableViewStyleGrouped];
    _baseTable.delegate = self;
    _baseTable.dataSource =self;
    _baseTable.rowHeight = 90;
    [self.view addSubview:_baseTable];
    _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //注册cell
    [_baseTable registerClass:[SupplyManageTableViewCell class] forCellReuseIdentifier:indentifier];
    //
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_baseTable addGestureRecognizer:tableViewGesture];
}
- (void)commentTableViewTouchInSide{
    _menuView.hidden = YES;
    [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    _isHidden = !_isHidden;
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataSourceAry.count) {
        return 45;
    }else{
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceAry.count == 0) {
        SupplyManageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
        return cell;
    }
    SupplyManageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    MySupplyModel * model = self.dataSourceAry[indexPath.row];
    if ([self.zhuangtai isEqualToString:@"2"]) {//1待审核 2展示
        model.isHidden = YES;
        cell.model = model;
    }else{
        model.isHidden = NO;
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];//这句话不能加了，用了就不能多选中了
    if (self.baseTable.editing) {
        [self.updateDataAry addObject:self.dataSourceAry[indexPath.row]];
        _selectView.string = [NSString stringWithFormat:@"%@%zd%@", @"已选择",self.updateDataAry.count, @"个供应产品"];
    }else{
        //跳转到详细页面（H5页面）
        MyLog(@"跳转");
        SupplyDetailViewController * detailVC = [[SupplyDetailViewController alloc] init];
        detailVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", [self.dataSourceAry[indexPath.row] Id], KUserImfor[@"userid"]];
        detailVC.chanpinId = [self.dataSourceAry[indexPath.row] Id];
        detailVC.FromMe = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [self commentTableViewTouchInSide];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.updateDataAry removeObject:self.dataSourceAry[indexPath.row]];
    _selectView.string = [NSString stringWithFormat:@"%@%zd%@", @"已选择",self.updateDataAry.count, @"个供应产品"];
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/**
 *  向左滑动cell时右侧显示的按钮
 */
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:RGBColor(27, 75, 146) icon:[UIImage imageNamed:@"Me_alter"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:RGBColor(194, 28, 34) icon:[UIImage imageNamed:@"Me_delete"]];
    return rightUtilityButtons;
}

#pragma mark --SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        MyLog(@"修改");
        AddSupplyViewController * addVC = [[AddSupplyViewController alloc] init];
        addVC.typeString = self.titleString;
        addVC.isAlter = YES;
        NSIndexPath * indexpath = [_baseTable indexPathForCell:cell];
        MySupplyModel * model = self.dataSourceAry[indexpath.row];
        addVC.proid = model.Id;
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        MyLog(@"删除");
        
        //从服务器删除
        NSIndexPath * indexPath = [_baseTable indexPathForCell:cell];
        MySupplyModel * model = self.dataSourceAry[indexPath.row];
        NSString * netPath = @"userinfo/my_pro_del";
        NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
        [allParams setObject:model.Id forKey:@"proid"];//这里有问题 为空
        [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
            //            MyLog(@"&&%@", responseObj);
            NSIndexPath *cellIndexPath = [self.baseTable indexPathForCell:cell];
            [_dataSourceAry removeObjectAtIndex:cellIndexPath.row];//从数据源删除
            [self.baseTable deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];//删除之后刷新UI
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
    }
}

#pragma mark --- selectFooterViewDelegate
- (void)confirmRefresh{
    //确定刷新所选中的供应产品
    NSArray *arr = self.baseTable.indexPathsForSelectedRows;//所有被选中的行
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSInteger  rowNum = [arr[i] row];
        MySupplyModel * model = self.dataSourceAry[rowNum];
        [array addObject:model.Id];
    }
    NSString * proid = [array componentsJoinedByString:@"-"];
    NSString * netPath = @"pro/pro_shuaxin";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:proid forKey:@"proid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"刷新成功%@", responseObj);
        [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
    } failure:^(NSError *error) {
        
    }];
    
    
    _selectView.hidden = YES;
    _baseTable.frame = CGRectMake(0, 120, kUIScreenWidth, kUIScreenHeight - 120);
    _baseTable.editing = NO;
    self.isChoseAll = NO;
    [_rightBut setTitle:@"" forState:UIControlStateNormal];
    [_rightBut setImage:[UIImage imageNamed:@"Request_close"] forState:UIControlStateNormal];
    [self.updateDataAry removeAllObjects];
    _selectView.string = [NSString stringWithFormat:@"已选择0个供应产品"];
//    [self.baseTable reloadData];
}
#pragma  mark -- normalFooterViewDelegate
- (void)addNewSupply{
    AddSupplyViewController * addSupplyVC = [[AddSupplyViewController alloc] init];
    addSupplyVC.typeString = self.titleString;
    [self.navigationController pushViewController:addSupplyVC animated:YES];
}

/**
 *  找到各自对应的数量
 */
- (void)findTotalCount{
    for (int i = 1; i < 3; i++) {
        NSString * netPath = @"userinfo/my_pro_list";
        NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
        [allParams setObject:@(1) forKey:@"page"];
        [allParams setObject:@(kPageCount) forKey:@"pagecount"];
        [allParams setObject:@(self.type) forKey:@"type"];//1纱线 2原料
        [allParams setObject:@(i) forKey:@"zhuangtai"];//1待审核 2展示
        [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
            MyLog(@"%d", i);
                if (i == 1) {
                    self.totalChecking = responseObj[@"total"];
                
                }else{
                    self.totalShowing = responseObj[@"total"];
                }
            [self getCount];
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
    }
}
- (void)getCount{
    for (UIButton * but in _menuView.subviews) {
        if (but.tag == 1000) {
            [but setTitle:[NSString stringWithFormat:@"展示中的产品(%@)", self.totalShowing] forState:UIControlStateNormal];
        }else if (but.tag == 1001){
            [but setTitle:[NSString stringWithFormat:@"审核中的产品(%@)", self.totalChecking] forState:UIControlStateNormal];
        }
    }
}

/**
 *  得出意向留言的数量
 */

- (void)configerNewsCount{
    NSString * netPath = @"userinfo/pro_feedback_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        self.newsCount = responseObj[@"total"];
        [self getNewsCount:self.newsCount];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getNewsCount:(NSString *)count{
    if (self.newsButton == nil) {
        self.newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _newsButton.frame = CGRectMake(0, 5, 70, 20);
        [_newsButton setTitle:@"产品消息" forState:UIControlStateNormal];
        [_newsButton setTitleColor:RGBColor(83, 83, 83) forState:UIControlStateNormal];
        _newsButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _newsButton.tag = 1002;
        [_newsButton addTarget:self action:@selector(butClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.hub = [[RKNotificationHub alloc] initWithView:_newsButton];
        [_hub increment];
        
        [_hub scaleCircleSizeBy:.5];
    }
    _hub.count = [count integerValue];
    for (UIButton * but in _menuView.subviews){
        if (but.tag == 1002) {
            [but addSubview:_newsButton];
        }
    }
}

@end
