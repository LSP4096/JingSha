//
//  SupportViewController.m
//  JingSha
//
//  Created by 苹果电脑 on 5/19/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SupportViewController.h"

#define KTopViewHeight 65
@interface SupportViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic,strong) UITableView *baseTabView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SupportViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i++) {
            [_dataSource addObject:str(@"%d",i)];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureSearchBar];
    [self.view addSubview:self.baseTabView];
    
}

/**
 *  下拉刷新数据
 */
- (void)refreshData {
    MyLog(@"down");
}

/**
 *  上拉加载更多
 */
- (void)loadMoreData {
    MyLog(@"up");
}

- (void)configureSearchBar {
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, KTopViewHeight)];
    [self.view addSubview:topView];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KTopViewHeight - 1, kUIScreenWidth, 1)];
    bottomView.backgroundColor = RGBColor(230, 230, 230);
    [topView addSubview:bottomView];
    [topView addSubview:self.searchBar];
}

#pragma mark--Lazy Loading
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 10, kUIScreenWidth - 40, 40)];
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.frame.size];
        _searchBar.placeholder = @"请输入关键字";
        _searchBar.searchBarStyle = 2;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)baseTabView {
    if (!_baseTabView) {
        _baseTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight + KTopViewHeight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - KTopViewHeight- 45) style:UITableViewStylePlain];
        _baseTabView.delegate = self;
        _baseTabView.dataSource = self;
        _baseTabView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _baseTabView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _baseTabView;
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

#pragma mark --tabViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark --tabViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.baseTabView deselectRowAtIndexPath:indexPath animated:YES];
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
