//
//  NewSearchTableViewController.m
//  JingSha
//
//  Created by BOC on 15/11/7.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "NewSearchTableViewController.h"
#define KKeyWithHistorySearch @"history"
#import "SearchModel.h"
#import "HotSearchTableViewCell.h"
#import "SearchTableViewCell.h"
#import "SearchResultTableViewCell.h"
#import "XWNewsDetailViewController.h"
#define kSpacing             15   //间距
@interface NewSearchTableViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, copy) NSString *enterStr;//输入的内容
@property (nonatomic, strong) NSMutableArray *filterArray;//搜索出来的数据数组
@property (nonatomic, strong) NSArray *historySearchResult;
@property (nonatomic, strong) NSArray *hotSearchList;

@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation NewSearchTableViewController

- (NSMutableArray *)filterArray {
    if (!_filterArray) {
        self.filterArray = [NSMutableArray array];
    }
    return _filterArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //近期热点
    [self configureHotSearch];
    [self configureStatueBar];
    //配置历史搜索数组
    [self configureHistirySearch];
    
    //配置搜索框
    [self layoutSearchBar];
}

- (void)configureStatueBar {
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 20)];
    
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:statusBarView];
    
    //    self.tableView.scrollEnabled = NO;
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kUIScreenWidth, kUIScreenHeight-20) style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self.view addSubview:self.contentTableView];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.contentTableView registerNib:[UINib nibWithNibName:@"HotSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchXIB"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchBtn"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"filter"];
    [self.contentTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    self.contentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
}
#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无搜索记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//历史搜索
- (void)configureHistirySearch {
    NSUserDefaults *defelt = [NSUserDefaults standardUserDefaults];
    self.historySearchResult = [defelt objectForKey:KKeyWithHistorySearch];
    MyLog(@"%@", self.historySearchResult);
    [defelt synchronize];
}
//近期热点
- (void)configureHotSearch {
    //    self.hotSearchList = @[@"粗针棉", @"尼龙氨纶", @"毛呢", @"棉涤"];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *tempDic in self.keyWordArray) {
        [mArr addObject:tempDic[@"title"]];
    }
    self.hotSearchList = mArr;
    MyLog(@"%@", self.hotSearchList);
}
//配置搜索框
- (void)layoutSearchBar {
    UIView *searchBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kUIScreenWidth, 44)];
    searchBGView.backgroundColor = [UIColor lightTextColor];
    
    //创建搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(kSpacing, 0, kUIScreenWidth * 7.5 / 9, 44 )];
    //提示文字
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    _searchBar.barTintColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(_searchBar.frame), 0, 30, CGRectGetHeight(_searchBar.frame));
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handlePop:) forControlEvents:UIControlEventTouchUpInside];
    [searchBGView addSubview:button];
    //设置代理
    _searchBar.delegate = self;
    //添加到小背景视图上
    [searchBGView addSubview:_searchBar];
    self.contentTableView.tableHeaderView = searchBGView;
    
}
- (void)handlePop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//取消searchbar背景色 搜索框
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchBar.text.length != 0 && self.filterArray.count == 0) {
        return 1;
    }
    
    if (self.filterArray.count) {
        return 1;
    } else {
        if (self.historySearchResult == nil) {
            return 1;
        } else {
            return !self.historySearchResult.count ? 1 : 2 ;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchBar.text.length != 0 && self.filterArray.count == 0) {
        return 1;
    }
    
    if (self.filterArray.count) {
        return self.filterArray.count;
    } else if (self.historySearchResult.count) {
        NSInteger history = [self returnNumberOfRowsWithCount:self.historySearchResult.count];
        NSInteger hotSearch = [self returnNumberOfRowsWithCount:self.hotSearchList.count];
        return !section ? history: hotSearch;
    } else {
        MyLog(@"aaa%zd",self.hotSearchList.count ) ;
        return [self returnNumberOfRowsWithCount:self.hotSearchList.count];
    }
}
- (NSInteger)returnNumberOfRowsWithCount:(NSInteger)integer {
    if (integer < 3 || integer % 3 == 1 || integer % 3 == 2) {
        return (integer / 3 + 1);
    } else {
        return integer / 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.filterArray.count ? 80 : 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpacing, 0, kUIScreenWidth - 2 * kSpacing, bgView.height)];
    titleLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:titleLabel];
    if (self.searchBar.text.length != 0 && self.filterArray.count == 0) {
        titleLabel.text = @"搜索结果";
        return bgView;
    }
    if (self.searchBar.text.length != 0 && self.filterArray.count) {
        titleLabel.text = @"搜索结果";
        return bgView;
    }
    
    if (self.historySearchResult.count == 0) {
        titleLabel.text = @"近期热点";
        return bgView;
    } else if (self.filterArray.count == 0){
        titleLabel.text = section?@"近期热点":@"历史搜索";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(kUIScreenWidth - 50, 0, 50, 30);
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleClear:) forControlEvents:UIControlEventTouchUpInside];
        if (section) {
            return bgView;
        } else{
            [bgView addSubview:button];
            return bgView;
        }
    } else {
        titleLabel.text = @"搜索结果";
        return bgView;
    }
}
- (void)handleClear:(UIButton *)sender {
    NSUserDefaults *defelt = [NSUserDefaults standardUserDefaults];
    [defelt removeObjectForKey:KKeyWithHistorySearch];
    [defelt synchronize];
    self.historySearchResult = nil;
    [self.contentTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchBar.text.length != 0 && self.filterArray.count == 0) {
        static NSString *indntifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indntifier ];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indntifier];
        }
        cell.textLabel.text = @"暂无此类新闻";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
    
    if (self.filterArray.count) {
        SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filter" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //当前输入框有内容,显示搜索内容
        SearchModel *model = self.filterArray[indexPath.row];
        [cell configureDataWithModel:model inputString:self.searchBar.text];
        return cell;
    }
    else {
        //输入框无内容，显示搜索历史和近期热搜
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchBtn" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.firstBrn addTarget:self action:@selector(handleBeginSearch:) forControlEvents:UIControlEventTouchUpInside];
        [cell.secondBtn addTarget:self action:@selector(handleBeginSearch:) forControlEvents:UIControlEventTouchUpInside];
        [cell.thirdBtn addTarget:self action:@selector(handleBeginSearch:) forControlEvents:UIControlEventTouchUpInside];
        if (self.historySearchResult != nil) {
            if (indexPath.section == 0) {
                NSArray *array = [self getArrayWith:indexPath.row array:self.historySearchResult];
                [cell configureDataWithArray:array];
            } else if (indexPath.section == 1) {
                NSArray *array = [self getArrayWith:indexPath.row array:self.hotSearchList];
                [cell configureDataWithArray:array];
            }
            
        } else {
            NSArray *array = [self getArrayWith:indexPath.row array:self.hotSearchList];
            MyLog(@"%@", array);
            [cell configureDataWithArray:array];
        }
        return cell;
    }
}

#pragma mark - 点击搜索历史或者热搜进行搜索
- (void)handleBeginSearch:(UIButton *)sender {
    self.searchBar.text = sender.currentTitle;
    [self searchBar:self.searchBar textDidChange:sender.currentTitle];
    [self.searchBar becomeFirstResponder];
}
//得到赋值的数组
- (NSArray *)getArrayWith:(NSInteger )integer
                    array:(NSArray *)array{
    NSInteger count = array.count;
    NSInteger shangCount = count / 3;
    NSInteger resCount = count - integer * 3;
    if (integer < shangCount) {
        return @[array[integer * 3], array[integer * 3 + 1], array[integer * 3 + 2]];
    } else  {
        switch (resCount) {
            case 0:
            {
                return nil;
            }
                break;
            case 1:
            {
                return @[array[integer * 3]];
            }
                break;
            default:
            {
                return @[array[integer * 3], array[integer * 3 + 1]];
            }
                break;
        }
    }
}
//单元格选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //刚选中又马上取消选中状态，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.filterArray.count) {
        //存为搜索历史
        NSUserDefaults *defelt = [NSUserDefaults standardUserDefaults];
        NSArray *array = [defelt objectForKey:KKeyWithHistorySearch];
        if (!array.count) {
            [defelt setObject:@[self.searchBar.text] forKey:KKeyWithHistorySearch];
            [defelt synchronize];
        } else {
            BOOL isCollection = NO;
            for (NSString *str in array) {
                if ([self.searchBar.text isEqualToString:str]) {
                    [defelt synchronize];
                    isCollection = YES;
                }
            }
            if (isCollection == NO) {
                NSMutableArray *mArr = [array mutableCopy];
                [mArr addObject:self.searchBar.text];
                MyLog(@"AAA%@", mArr);
                [defelt setObject:mArr forKey:KKeyWithHistorySearch];
                [defelt synchronize];
            }
        }
        XWNewsDetailViewController *detailVC = [[XWNewsDetailViewController alloc] init];
        NSString *str = ((SearchModel *)self.filterArray[indexPath.row]).newsid;
        detailVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/newsinfo/%@", str];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else {
        
    }
}
//网络请求,数据处理

- (void)requestData {
    NSString *netPath = @"news/searchlist";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:@"1" forKey:@"page"];
    [allParameters setObject:@"10" forKey:@"pagecount"];
    [allParameters setObject:self.enterStr forKey:@"keyword"];
    [HttpTool getWithPath:netPath params:allParameters success:^(id responseObj) {
        MyLog(@"%@", responseObj);
        if (((NSArray *)responseObj[@"data"]).count == 0) {
            self.filterArray = nil;
            return ;
        }
        [self configureData:responseObj];
    } failure:^(NSError *error) {
        
    }];
}
//解析数据
- (void)configureData:(NSDictionary *)dic {
    //搜索到的新闻总数
    NSArray *datas = dic[@"data"];
    if (!datas.count) {
        //        if (self.searchBar.text != nil) {
        self.filterArray = nil;
        [self.contentTableView reloadData];
        return;
        //            [SVProgressHUD showErrorWithStatus:@"无搜索结果"];
        //        }
    }
    
    for (NSDictionary *dict in datas) {
        SearchModel *item = [SearchModel objectWithKeyValues:dict];
        [self.filterArray addObject:item];
    }
    [self.contentTableView reloadData];
    
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    
}
//输入内容 一个字符一个字符拼接起来输出
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (self.filterArray.count) {
        [self.filterArray removeAllObjects];
    }
    if (searchText != nil && searchText.length > 0) {
        self.enterStr = searchText;
    } else {
        [self.filterArray removeAllObjects];
        [self configureHistirySearch];
        [self.contentTableView reloadData];
        return;
    }
    [self.contentTableView reloadData];
    //数据请求
    [self requestData];
}
//输入内容一个字符一个字符输出
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //返回上一界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
