//
//  XWNewsShowController.m
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "XWNewsShowController.h"
#import "XWNewsKitModel.h"
#import "XWNewsModel.h"
#import "SingleTon.h"
#import "SDCycleScrollView.h"
#import "NoPhotoTableViewCell.h"
#import "OnePhotoTableViewCell.h"
#import "ThreePhotoTableViewCell.h"
#import "BigPhotoTableViewCell.h"
#import "XWNewsDetailViewController.h"
#import "SearchViewController.h"
#import "NewSearchTableViewController.h"


#define kPage 1
#define kEachPageCount 10
#define HeaderViewH  kUIScreenHeight / 2.7
#define KSearchBarHeight 40
#define smallScrollMenuH 40

#define kMargin 0
#define kMarginTop ([UIScreen mainScreen].bounds.size.height - kInterSpacing * 9)
#define kInterSpacing 20
@interface XWNewsShowController () <SDCycleScrollViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
   NSInteger _currentPage;
   
}
@property (nonatomic, strong) NSMutableDictionary *dataSource;
@property (nonatomic, strong) NSMutableArray *arrList;
@property (nonatomic, strong) UISearchBar *searchBar;

//头视图
@property (nonatomic, strong) UIView *headerV;
//banner图链接数组
@property (nonatomic, strong) NSArray *ImageArray;

/**存储当前展示的框架模型*/
@property (nonatomic, strong) XWNewsKitModel *kitModel;
@end
@implementation XWNewsShowController

- (NSMutableArray *)arrList {
   if (_arrList == nil) {
      _arrList = [NSMutableArray array];
   }
   return _arrList;
}

//配置数据
- (void)configureData {
   [self refreshDataList];
   [self downRefresh];
}
- (void)loadDataListWithPage:(NSInteger)page {
   //判断有没有网络
   if([XWBaseMethod connectionInternet]==NO){
      return;
   }
   NSString *netPath = @"news/newslist";
   NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
   [allParams setObject:self.cid forKey:@"cid"];
   [allParams setObject:@(page) forKey:@"page"];
   [allParams setObject:@(kEachPageCount) forKey:@"pagecount"];
   
   [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
      [self.tableView.header endRefreshing];
      [self.tableView.footer endRefreshing];
      [self reloadDataWithPage:page responseObj:responseObj];
   } failure:^(NSError *error) {
      [self.tableView.header endRefreshing];
      [self.tableView.footer endRefreshing];
   }];
   
}
- (void)reloadDataWithPage:(NSInteger)page responseObj:(NSDictionary *)responseObj {
   //    NSLog(@"%@", responseObj);
   _currentPage = page;
   NSInteger totalCount = [responseObj[@"total"] integerValue];
   if (page == 1) { //下拉刷新
      self.arrList = [NSMutableArray array];
   }
   //添加头部视图
   [self addHeaderView:responseObj[@"data"]];
   self.kitModel = [XWNewsKitModel xwNewsKitModelWithDictionary:responseObj[@"data"]];
   
   NSArray *arrList = self.kitModel.newslistArr;
   for (NSDictionary *dict in arrList) {
      XWNewsModel *model = [XWNewsModel xwnewModelWithDictionary:dict];
      [self.arrList addObject:model];
   }
   //    self.arrList = [XWNewsModel objectArrayWithKeyValuesArray:arrList];
   [self.tableView reloadData];
   
   //判断是否要添加上拉加载
   NSInteger loadCount = kEachPageCount * (page - 1) + arrList.count;
   MyLog(@"%zd", loadCount);
   if (totalCount > loadCount && !self.tableView.footer) {
      self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataList)];
   }else if(totalCount == loadCount){
      self.tableView.footer = nil;
   }
}
- (NSMutableDictionary *)dataSource {
   if (_dataSource == nil) {
      self.dataSource = [NSMutableDictionary dictionary];
   }
   return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   [self loadDataListWithPage:1];
}
- (void)viewDidLoad {
   [super viewDidLoad];
   _currentPage = 1;
   [self configureData];
   [self registeCell];
   //    [self setupFloatingWindow];
   self.tableView.contentInset = UIEdgeInsetsMake(-KSearchBarHeight, 0, 0, 0);
}


#pragma mark - 注册cell
- (void)registeCell {
   self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
   //注册cell
   [self.tableView registerNib:[UINib nibWithNibName:@"NoPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"NO"];
   [self.tableView registerNib:[UINib nibWithNibName:@"OnePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ONE"];
   [self.tableView registerNib:[UINib nibWithNibName:@"ThreePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"THREE"];
   [self.tableView registerNib:[UINib nibWithNibName:@"BigPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BIG"];
   //无信息时显示的界面
   self.tableView.emptyDataSetDelegate = self;
   self.tableView.emptyDataSetSource = self;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
   NSString *text = @"暂无资讯";
   NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                NSForegroundColorAttributeName: [UIColor darkGrayColor]};
   
   return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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

- (void)loadMoreDataList
{
   [self loadDataListWithPage:_currentPage + 1];
}
- (void)downRefresh {
   self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataList)];
}
#pragma mark 添加头部视图

-(void)addHeaderView:(NSDictionary *)dic
{
   //判断是否有版图
   if ([dic[@"bantype"] isEqualToString:@"true"]) {
      NSInteger count = ((NSArray*)dic[@"banlist"]).count;
      NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:count];
      NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:count];
      NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:count];
      for (NSDictionary *tempDic in dic[@"banlist"]) {
         [imageArray addObject:tempDic[@"photo"]];
         [titleArray addObject:tempDic[@"title"]];
         [urlArray addObject:tempDic[@"url"]];
      }
      self.ImageArray = urlArray;
      UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HeaderViewH + KSearchBarHeight)];
      
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, KSearchBarHeight)];
      view.backgroundColor = [UIColor groupTableViewBackgroundColor];
      
      //添加搜索框
      self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(kUIScreenWidth / 16, 5, kUIScreenWidth / 9 * 8, KSearchBarHeight - 10)];
      
      _searchBar.backgroundColor = [UIColor clearColor];
      _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
      _searchBar.placeholder = @"请输入搜索内容";
      [view addSubview:_searchBar];
      [bgView addSubview:view];
      
      //添加按钮，，点击事件进入下个界面
      UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeSystem];
      inputBtn.frame = CGRectMake(0, 0, kUIScreenWidth, KSearchBarHeight);
      inputBtn.backgroundColor = [UIColor clearColor];
      [inputBtn addTarget:self action:@selector(handlePuth) forControlEvents:UIControlEventTouchUpInside];
      [bgView addSubview:inputBtn];
      NSMutableArray *imageHoderArray = [NSMutableArray array];
      
      SDCycleScrollView *sdcycleScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, KSearchBarHeight, kUIScreenWidth, HeaderViewH) imagesGroup:imageHoderArray];
      sdcycleScroll.placeholderImage = [UIImage imageNamed:@"网络暂忙-193-133"];
      sdcycleScroll.imageURLStringsGroup = imageArray;
      sdcycleScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
      sdcycleScroll.delegate = self;
      sdcycleScroll.isButtomTitleLabel = YES;
      sdcycleScroll.dotColor = RGBColor(38, 38, 38);
      sdcycleScroll.titleLabelTextColor = RGBColor(35, 35, 35);
      sdcycleScroll.pageControlDotSize = CGSizeMake(2, 2);
      sdcycleScroll.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];
      sdcycleScroll.titlesGroup = titleArray;
      sdcycleScroll.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
      [bgView addSubview:sdcycleScroll];
      self.headerV = bgView;
      self.tableView.tableHeaderView = _headerV;
     } else {
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, KSearchBarHeight)];
      view.backgroundColor = [UIColor groupTableViewBackgroundColor];
      //添加搜索框
      self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(kUIScreenWidth / 16, 5, kUIScreenWidth / 9 * 8, KSearchBarHeight - 10)];
      
      _searchBar.backgroundColor = [UIColor clearColor];
      _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
      _searchBar.placeholder = @"请输入搜索内容";
      [view addSubview:_searchBar];
      self.tableView.tableHeaderView = view;
      //添加按钮，，点击事件进入下个界面
      UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeSystem];
      inputBtn.frame = CGRectMake(0, 0, kUIScreenWidth, KSearchBarHeight);
      inputBtn.backgroundColor = [UIColor clearColor];
      [inputBtn addTarget:self action:@selector(handlePuth) forControlEvents:UIControlEventTouchUpInside];
      [view addSubview:inputBtn];
   }
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

- (void)handlePuth {
   NSString *netPath = @"news/keyword_list";
   NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
   [HttpTool getWithPath:netPath params:allParameters success:^(id responseObj) {
      MyLog(@"%@", responseObj);
      NewSearchTableViewController *searchVC = [[NewSearchTableViewController alloc] init];
      NSArray *keyList = [NSArray arrayWithArray:(NSArray *)responseObj[@"data"]];
      searchVC.keyWordArray = keyList;
      [self.navigationController pushViewController:searchVC animated:YES];
   } failure:^(NSError *error) {
      MyLog(@"eeeeee %@", error);
   }];
   
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
   if (!self.ImageArray.count) {
      [MBProgressHUD showError:@"亲，没有链接" toView:self.view];
      return;
   }
   XWNewsDetailViewController *detailVC = [[XWNewsDetailViewController alloc] init];
   NSString *urlStr = self.ImageArray[index];
   detailVC.sendUrlStr = urlStr;
   [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   NSInteger kitType = [self.kitModel.kitType integerValue];
   NSInteger count = self.arrList.count;
   return (kitType == 1 || kitType == 2) ? 1 : count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSInteger kitType = [self.kitModel.kitType integerValue];
   NSInteger count = self.arrList.count;
   return (kitType == 1 || kitType == 2) ? count : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSInteger kitType = [self.kitModel.kitType integerValue];
   //    return ((kitType == 1 || kitType == 2) ? 102 : (((XWNewsModel *)self.arrList[indexPath.section])).photo.count ? 220 : 102);
   if (kitType == 1 || kitType == 2) {
      if ([((XWNewsModel *)self.arrList[indexPath.row]).type integerValue]== 3) {
         return 120;
      } else if ([((XWNewsModel *)self.arrList[indexPath.row]).type integerValue]== 2) {
         return 95;
      } else {
         return 90;
      }
   } else {
      if (((XWNewsModel *)self.arrList[indexPath.section]).photo.count) {
         return 220;
      } else {
         return 102;
      }
   }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   return 0.001;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return self.kitModel.kitType.integerValue == 1 ? 0.001 : 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   //1.判断框架的类型
   NSInteger kitType = [self.kitModel.kitType integerValue];
   switch (kitType) {
      case 1:
      {
         return [self returnCellWithTableView:tableView IndexPath:indexPath];
      }
         break;
      case 2:
      {
         return [self returnCellWithTableView:tableView IndexPath:indexPath];
      }
         break;
      default:
      {
         XWNewsModel *model = self.arrList[indexPath.section];
         if (!model.photo.count) {
            NoPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NO" forIndexPath:indexPath];
            [cell configureDataWithModel:model];
            return cell;
         } else {
            BigPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIG" forIndexPath:indexPath];
            [cell configureDataWithModel:model];
            return cell;
         }
      }
         break;
   }
}
/**返回cell的类型*/
- (UITableViewCell *)returnCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
   //判断cell类型
   XWNewsModel *model = self.arrList[indexPath.row];
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
}
/**单元格选中事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //刚选中又马上取消选中状态，格子不变色
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   XWNewsModel *model = nil;
   if ([self.kitModel.kitType integerValue] == 3) {
      model = self.arrList[indexPath.section];
   } else {
      
      model = self.arrList[indexPath.row];
   }
   XWNewsDetailViewController *detailVC = [[XWNewsDetailViewController alloc] init];
   NSString *urlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/newsinfo/%@", model.newsid];
   detailVC.sendUrlStr = urlStr;
   NSDictionary *sendDic = @{@"title": model.title, @"content": model.content, @"photo": model.photo};
   detailVC.newsInfoDic = sendDic;
   [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - tableView上滑隐藏searchBar
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   CGFloat top = 0;
   if (scrollView.contentOffset.y > 5) {
      top = -KSearchBarHeight;
   }else{
      if (self.kitModel.kitType.integerValue == 1 ) {
         top = 0;
      } else{
         top = 6;
      }
   }
   [UIView animateWithDuration:0.2 animations:^{
      self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
   }];
}
@end
