//
//  CollectionViewController.m
//
//
//  Created by bocweb on 15/11/13.
//
//

#import "CollectionViewController.h"
#import "XWNewsKitModel.h"
#import "XWNewsModel.h"
#import "OnePhotoTableViewCell.h"
#import "NoPhotoTableViewCell.h"
#import "ThreePhotoTableViewCell.h"
#import "BigPhotoTableViewCell.h"
#import "XWNewsDetailViewController.h"
#import "SingleTon.h"

#import "XWNewsModel.h"
#import "NoPhotoTableViewCell.h"
#import "OnePhotoTableViewCell.h"
#import "ThreePhotoTableViewCell.h"
#import "BigPhotoTableViewCell.h"

#import "CompanyCollectTableViewCell.h"

#import "CompamyCollectModel.h"
#import "RecommendDetailViewController.h"
#import "ProOptionModel.h"
#import "NewProductMoreTableViewCell.h"
#define kPage 1
#define kEachPageCount 10
#define KCollectionBtnHeight 45
#define KsmallBGLabelHeight 3
@interface CollectionViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
    NSInteger _currentPage;
}
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, strong) NSMutableArray *arrList;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *smallBGLabel;
@property (nonatomic, assign)NSInteger type;
@end

@implementation CollectionViewController
- (NSMutableArray *)arrList {
    if (!_arrList) {
        self.arrList = [NSMutableArray array];
    }
    return _arrList;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    self.type = 1;
//    [self configureData];
    [self setupCollectionBtn];
    
    [self setupTableView];
    [self registeCell];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureData];
}
#pragma mark - 注册cell
- (void)registeCell {
    self.contentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.contentTableView registerNib:[UINib nibWithNibName:@"NoPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"NO"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"OnePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ONE"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"ThreePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"THREE"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"BigPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BIG"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CompanyCollectTableViewCell" bundle:nil] forCellReuseIdentifier:@"companyCollectCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"NewProductMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"newProductMoreCell"];//产品收藏
}

///请求数据
- (void)configureData {
    [self refreshDataList];
    [self downRefresh];
}

#pragma mark - 下拉刷新 ，上拉加载
- (void)refreshDataList
{
    [self loadNewDataList];
}

- (void)loadNewDataList
{
    [self loadDataListWithPage:1];
}

- (void)loadMoreDataListWithPage:(NSInteger)page
{
    [self loadDataListWithPage:_currentPage + 1];
}
- (void)loadDataListWithPage:(NSInteger)page {
    NSString *netPath = @"userinfo/shoucan_list";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:[SingleTon shareSingleTon].userInformation[@"userid"] forKey:@"userid"];
    [allParameters setObject:@(page) forKey:@"page"];
    [allParameters setObject:@(kEachPageCount) forKey:@"pagecount"];
    [allParameters setObject:@(self.type) forKey:@"type"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        
        [self.contentTableView.header endRefreshing];
        [self.contentTableView.footer endRefreshing];
        [self reloadDataWithPage:page responseObj:responseObj];
    
    } failure:^(NSError *error) {
        [self.contentTableView.header endRefreshing];
        [self.contentTableView.footer endRefreshing];
        MyLog(@"__+_+_+_%@",error);
    }];
    
}
- (void)reloadDataWithPage:(NSInteger)page responseObj:(NSDictionary *)responseObj {
    _currentPage = page;
    NSInteger totalCount = [responseObj[@"total"] integerValue];
    if (page == 1) { //下拉刷新
        self.arrList = [NSMutableArray array];
    }
    
    NSArray *arrList = responseObj[@"data"];
    if ([arrList isKindOfClass:[NSString class]]) {
        return;
    }
    if (self.type == 1) {
        if (![arrList.firstObject[@"newsid"] isKindOfClass:[NSString class]]) {
            return;
        }
        for (NSDictionary *dict in arrList) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                //            NSLog(@"%@", dict[@"title"]);
                XWNewsModel *model = [XWNewsModel xwnewModelWithDictionary:dict];
                [self.arrList addObject:model];
            }
        }
    }else if (self.type == 2){//企业
//        MyLog(@"%@", responseObj);
        for (NSDictionary * dict in arrList) {
            CompamyCollectModel * model = [CompamyCollectModel objectWithKeyValues:dict];
            [self.arrList addObject:model];
        }
    }else if (self.type == 3){//产品
        for (NSDictionary * dict in arrList) {
            ProOptionModel * model = [ProOptionModel objectWithKeyValues:dict];
            [self.arrList addObject:model];
        }
    }
    
    [self.contentTableView reloadData];
    
    //判断是否要添加上拉加载
    NSInteger loadCount = kEachPageCount * (page - 1) + _arrList.count;
    MyLog(@"%zd", loadCount);
    if (totalCount > loadCount && !self.contentTableView.footer) {
        self.contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataListWithPage:)];
    }else if(totalCount == loadCount){
        self.contentTableView.footer = nil;
    }
}
- (void)downRefresh {
//    self.contentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataList)];
}

///创建三个收藏按钮
- (void)setupCollectionBtn {
    NSArray *titleArray = @[@"企业收藏", @"产品收藏", @"资讯收藏"];
    CGFloat btnY = kNavigationBarHeight;
    CGFloat btnW = kUIScreenWidth / 3;
    CGFloat btnH = KCollectionBtnHeight;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        btn.backgroundColor = RGBColor(247, 247, 247);
        [btn addTarget:self action:@selector(handleChange:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.adjustsImageWhenHighlighted = NO;
        btn.adjustsImageWhenDisabled = NO;
        btn.tag = 1000+i;
        [self.view addSubview:btn];

        //默认显示资讯收藏
        if (i == 2) {
            self.selectBtn = btn;
            btn.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btnW * i, kNavigationBarHeight, btnW, KsmallBGLabelHeight)];
            label.backgroundColor = RGBColor(255, 145, 0);
            [self.view addSubview:label];
            self.smallBGLabel = label;
        }
    }
}

///收藏按钮响应事件
- (void)handleChange:(UIButton *)sender {
//    sender.userInteractionEnabled = NO;
//    [self rotate:sender];
//    _smallBGLabel.transform = CGAffineTransformIdentity;
    _smallBGLabel.frame = CGRectMake(sender.x, sender.y, _smallBGLabel.width, _smallBGLabel.height);
    sender.selected = !sender.selected;
    if (sender != self.selectBtn) {
        sender.backgroundColor = [UIColor whiteColor];
        self.selectBtn.backgroundColor = RGBColor(249, 249, 249);
        self.selectBtn = sender;
    }
    if (sender.tag == 1000) {
        self.type = 2;
    }else if (sender.tag == 1001){
        self.type = 3;
    }else{
        self.type = 1;
    }
    [self loadNewDataList];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        sender.userInteractionEnabled = YES;
//    });
}
#pragma mark - 旋转动画
//- (void)rotate:(UIButton *)sender {
//    CGPoint point = sender.center;
//    self.smallBGLabel.frame = CGRectMake(sender.frame.origin.x, kNavigationBarHeight, sender.frame.size.width, KsmallBGLabelHeight);
//    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
//    spring.velocity = [NSValue valueWithCGPoint:point];
//    [_smallBGLabel.layer pop_addAnimation:spring forKey:@"rotationAnimation"];
//}

///创建tableView
- (void)setupTableView {
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + KCollectionBtnHeight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - KCollectionBtnHeight) style:UITableViewStyleGrouped];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    //内容为空的时候tableView显示
    _contentTableView.emptyDataSetDelegate = self;
    _contentTableView.emptyDataSetSource = self;
    
//    self.contentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataList)];
    
    [self.view addSubview:_contentTableView];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无收藏记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.type == 2 ? 1 : self.arrList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrList.count) {
        return self.type == 2 ? self.arrList.count : 1;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        XWNewsModel *model = self.arrList[indexPath.section];
        if ([model.type integerValue] == 3) {
            return 130;
        }
        return 100;
    }else if (self.type == 2){
        return 80;
    }else{//3 产品
        return 100;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        //判断cell类型
        XWNewsModel *model = self.arrList[indexPath.section];
        NSInteger type = [model.type integerValue];
        switch (type) {
            case 1:
            {
                NoPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NO" forIndexPath:indexPath];
                [cell configureDataWithModel:model];
                return cell;
            }
                break;
            case 2:
            {
                OnePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ONE" forIndexPath:indexPath];
                [cell configureDataWithModel:model];
                return cell;
            }
                break;
            default:
            {
                ThreePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"THREE" forIndexPath:indexPath];
                [cell configureDataWithModel:model];
                return cell;
            }
                break;
        }
        
    }else if (self.type == 2){
        CompanyCollectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"companyCollectCell" forIndexPath:indexPath];
        cell.model = self.arrList[indexPath.row];
        return cell;
    }else{
        NewProductMoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newProductMoreCell" forIndexPath:indexPath];
        cell.model = self.arrList[indexPath.section];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ///点击后取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == 1) {
        XWNewsModel *model = self.arrList[indexPath.section];
        XWNewsDetailViewController *detailVC = [[XWNewsDetailViewController alloc] init];
        NSString *urlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/newsinfo/%@", model.newsid];
        detailVC.sendUrlStr = urlStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (self.type == 2){//企业
        CompamyCollectModel * model = self.arrList[indexPath.row];
        RecommendDetailViewController * recommendDetail = [[RecommendDetailViewController alloc] init];
        recommendDetail.qiyeId = model.uid;
        [self.navigationController pushViewController:recommendDetail animated:YES];
    }else if (self.type == 3){
        ProOptionModel * model = self.arrList[indexPath.row];
        RecommendDetailViewController * recommendDetailVC = [[RecommendDetailViewController alloc] init];
        recommendDetailVC.qiyeId = model.Id;
        [self.navigationController pushViewController:recommendDetailVC animated:YES];
    }   
}
//收藏编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //提交
    NSString *netPath = @"userinfo/shoucan_del";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:[SingleTon shareSingleTon].userInformation[@"userid"] forKey:@"userid"];
    
    if (self.type == 1) {
        [allParameters setObject:((XWNewsModel *)self.arrList[indexPath.section]).sid forKey:@"sidstr"];
    }else if (self.type == 2){//企业
        [allParameters setObject:[self.arrList[indexPath.row] sid] forKey:@"sidstr"];
    }else{//3 产品
        [allParameters setObject:[self.arrList[indexPath.section] sid] forKey:@"sidstr"];
    }
    
    
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        
    } failure:^(NSError *error) {
        
    }];
    //修改数据
    if (self.type == 1) {
        [self.arrList removeObjectAtIndex:indexPath.section];
        //修改界面
        NSIndexSet *index = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView deleteSections:index withRowAnimation:UITableViewRowAnimationMiddle];
    }else if (self.type == 2){
        [self.arrList removeObjectAtIndex:indexPath.row];
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
        [tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationMiddle];
    }else{//产品收藏删除
        [self.arrList removeObjectAtIndex:indexPath.section];
        NSIndexSet *index = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView deleteSections:index withRowAnimation:UITableViewRowAnimationMiddle];
    }
    if (self.arrList.count == 0) {
        [self.contentTableView reloadData];
    }
}

@end
