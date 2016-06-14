//
//  FirstPageSearchViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/4.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "FirstPageSearchViewController.h"
#import "RecommendOptionViewController.h"
#define kPageCount 10

@interface FirstPageSearchViewController ()<UISearchBarDelegate>
@property (nonatomic, assign)BOOL isChange;
@property (nonatomic, strong)UIView * selctedView;
@property (nonatomic, strong)UIButton * selectButton;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, copy)NSString * selectedTitle;

@property (nonatomic, strong)UILabel * bottomLable;
@property (nonatomic, strong)UILabel * NoRecordLable;
@property (nonatomic, strong)UIImageView * imageView;
//
//@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)NSMutableArray * titleAry;
@property (nonatomic, strong)UIView * bodyView;

//请求搜索数据
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, copy)NSString * keyword;
//
@property (nonatomic, strong)NSMutableArray * titleAry2;
@property (nonatomic, assign)NSInteger changeButPage;

@property (nonatomic, assign)BOOL change;
@property (nonatomic, assign)NSInteger  cid;
@end

static NSString * indentifier = @"searchResultCell";
@implementation FirstPageSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索";
    
    self.selectedTitle = @"产品";
    self.view.backgroundColor = RGBColor(236, 236, 236);
    
    self.isChange = NO;
    [self configerSearchBar];
    [self configerTapToHidden];//点击页面，隐藏掉出现的下拉视图

    self.pageNum = 1;
    self.changeButPage = 0;
    
    [self.selectButton setTitle:@"产品" forState:UIControlStateNormal];
    self.selectedTitle = @"产品";
//    [self productButtonClicked];//先主动调用一次
    
    self.cid = 23;  //2 新闻  22 供应商  23 产品
    self.change = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataWithCid:self.cid];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.selctedView.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SingleTon shareSingleTon].leibieStr = nil;
    [SingleTon shareSingleTon].zhisuStr = nil;
    [SingleTon shareSingleTon].zcdStr = nil;
    [SingleTon shareSingleTon].qiyefenleiStr = nil;
}
- (void)loadDataWithCid:(NSInteger)cid{
    NSString * netPath = @"news/keyword_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@(cid) forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  解析原始数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    self.titleAry = [NSMutableArray array];
    self.titleAry2 = [NSMutableArray array];
    NSDictionary * dict = responseObj[@"data"];
    [self.titleAry removeAllObjects];
    for (NSDictionary * smallDic in dict) {
        [self.titleAry2 addObject:smallDic[@"title"]];
    }
    
    if (self.titleAry2.count > 36) {
        NSRange range = {0, 35};
       self.titleAry2 = [[self.titleAry2 subarrayWithRange:range] mutableCopy];
    }
    if (self.change) {
        [self changeButtonClicked];
        self.change = NO;
    }
}


- (void)configerTapToHidden{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [self.view addGestureRecognizer:tapGesture];//给视图加上一个手势，点击页面空白处隐藏下拉视图
}
//点击视图隐藏下拉菜单  同时隐藏键盘
- (void)tapClicked{
    self.selctedView.hidden = YES;
    [_searchBar resignFirstResponder];
}

#pragma mark --
- (void)configerSearchBar{
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height + 20, kUIScreenWidth, 65)]; //导航条部分
    topView.backgroundColor = RGBColor(250, 250, 250);
    [self.view addSubview:topView];

    //下拉菜单和搜索框的父视图
    UIView * topBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kUIScreenWidth - 70, 45)];
    topBackView.layer.borderWidth = 1;
    topBackView.layer.borderColor = RGBColor(230, 230, 230).CGColor;
//        topBackView.backgroundColor = [UIColor yellowColor];
    [topView addSubview:topBackView];
    //左侧下拉选择按钮
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(5, 10, 70, 25);
    [self.selectButton setTitleColor:RGBColor(104, 104, 104) forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"search_01"] forState:UIControlStateNormal];
    
    [self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [self.selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 25)];
    
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectButton addTarget:self action:@selector(selectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:self.selectButton];
    
    
    //取消按钮
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(kUIScreenWidth - 50, 18, 40, 30);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:RGBColor(142, 142, 142) forState:UIControlStateNormal];
//    cancleButton.backgroundColor = [UIColor redColor];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancleButton];
    //分割线
//    UIView * middleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectButton.frame)+5, 10, 2, 25)];
//    middleView.backgroundColor = RGBColor(232, 233, 232);
//    [topBackView addSubview:middleView];
    
    //搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectButton.frame) + 5, 8, kUIScreenWidth - 160, 30)];
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.backgroundImage = [self imageWithColor:RGBColor(250, 250, 250) size:_searchBar.bounds.size];
    _searchBar.delegate = self;
    [topBackView addSubview:_searchBar];
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
//取消按钮响应事件
- (void)cancleButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
//选择按钮响应事件
- (void)selectButtonClicked{
    _isChange = !_isChange;
    if (self.isChange) {
        _selctedView.hidden = NO;
    }else{
        _selctedView.hidden = YES;
    }
}

#pragma mark -- 点击下拉菜单内的按钮时的触发事件
- (void)productButtonClicked{
    //这两个方法对应下拉菜单里的两个按钮，点击哪一个本来显示的按钮就会显示那一个标题，顺便切换下边显示的 大家都在搜。
    //在开始的时候主动触发任意一个方法
    [self.selectButton setTitle:@"产品" forState:UIControlStateNormal];
    self.selctedView.hidden = YES;
    _isChange = !_isChange;
    self.selectedTitle = @"产品";
    [self loadDataWithCid:23];
    self.cid = 23;
    self.change = YES;
    self.changeButPage = 0;
    MyLog(@"产品");
}
- (void)supplyButtonClicked{
    [self.selectButton setTitle:@"供应商" forState:UIControlStateNormal];
    self.selctedView.hidden = YES;
    _isChange = !_isChange;
    self.selectedTitle = @"供应商";
    [self loadDataWithCid:22];
    self.cid = 22;
    self.change = YES;
    self.changeButPage = 0;
    MyLog(@"供应商");
}
- (void)requestBtnClicked {
    [self.selectButton setTitle:@"求购" forState:UIControlStateNormal];
    self.selctedView.height = YES;
    _isChange = !_isChange;
    self.selectedTitle = @"求购";
    [self loadDataWithCid:23];
    self.cid = 23;
    self.change = YES;
    self.changeButPage = 0;
    MyLog(@"求购");
}

- (void)congigerOptionButton{
    if (self.bodyView) {
        [self.bodyView removeFromSuperview];
    }
    self.bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height + 85, kUIScreenWidth, kUIScreenHeight - 85)];
    _bodyView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_bodyView];
    //下拉菜单
    self.selctedView = [[UIView alloc] initWithFrame:CGRectMake(10, 75, 85, 105)];
    self.selctedView.backgroundColor = RGBColor(234, 234, 235);
    self.selctedView.layer.cornerRadius = 8;
    self.selctedView.layer.borderWidth = 0.001;
    self.selctedView.layer.masksToBounds = YES;
    [self.view addSubview:self.selctedView];
    self.selctedView.hidden = YES;
    
    UIButton * productButton = [UIButton buttonWithType:UIButtonTypeCustom];
    productButton.frame = CGRectMake(0, 0, 85, 35);
    [productButton setTitle:@"产品" forState:UIControlStateNormal];
    [productButton setTitleColor:RGBColor(106, 106, 106) forState:UIControlStateNormal];
    productButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [productButton addTarget:self action:@selector(productButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.selctedView addSubview:productButton];
    
    UIButton * supplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    supplyButton.frame = CGRectMake(0, 35, 85, 35);
    [supplyButton setTitle:@"供应商" forState:UIControlStateNormal];
    supplyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [supplyButton setTitleColor:RGBColor(106, 106, 106) forState:UIControlStateNormal];
    [supplyButton addTarget:self action:@selector(supplyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.selctedView addSubview:supplyButton];
    
    UIButton *requestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    requestBtn.frame = CGRectMake(0, CGRectGetMaxY(supplyButton.frame), 85, 35);
    [requestBtn setTitle:@"求购" forState:UIControlStateNormal];
    requestBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [requestBtn setTitleColor:RGBColor(106, 106, 106) forState:UIControlStateNormal];
    [requestBtn addTarget:self action:@selector(requestBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.selctedView addSubview:requestBtn];
    
    //大家都在搜
    UILabel * EveryOneSearchLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80,20)];
    EveryOneSearchLable.text = @"大家都在搜";
    EveryOneSearchLable.textColor = RGBColor(122, 122, 122);
//    EveryOneSearchLable.backgroundColor = [UIColor redColor];
    EveryOneSearchLable.font = [UIFont systemFontOfSize:14];
    [_bodyView addSubview:EveryOneSearchLable];
    //换一批
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(kUIScreenWidth - 70, 15, 60, 20);
//    changeButton.backgroundColor = [UIColor redColor];
    [changeButton setTitle:@"换一批" forState:UIControlStateNormal];
    changeButton.titleLabel.font =[UIFont systemFontOfSize:13];
    [changeButton setTitleColor:RGBColor(122, 122, 122) forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"searchNext"] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bodyView addSubview:changeButton];

    
    //可选选项
//    self.titleAry = [NSMutableArray arrayWithObjects:@"粘棉纱", nil];
    CGFloat Height = 0;
    CGFloat Width = (kUIScreenWidth - 70) / 3;
    for (int i = 0; i < _titleAry.count; i++) {
        UIButton * optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        optionButton.backgroundColor = RGBColor(31, 111, 251);
        optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [optionButton setTitle:_titleAry[i] forState:UIControlStateNormal];
        optionButton.frame = CGRectMake(20 +  (Width + 15) * (i%3), 50 + 50 * (i/3), Width, 40);
        optionButton.layer.cornerRadius = 8.0f;
        optionButton.layer.borderWidth = 0.001f;
        optionButton.layer.masksToBounds = YES;
        Height = 25 + (25 + 15) * (i/3 + 1);//下面历史搜索项的高度
        [optionButton addTarget:self action:@selector(optionButtonClieked:) forControlEvents:UIControlEventTouchUpInside];
        [_bodyView addSubview:optionButton];
    }
    //搜索历史
    UILabel * SearchHistoryLable = [[UILabel alloc] initWithFrame:CGRectMake(20, Height + 55, 80, 20)];
    SearchHistoryLable.text = @"搜索历史";
    SearchHistoryLable.textColor = RGBColor(122, 122, 122);
    SearchHistoryLable.font = [UIFont systemFontOfSize:14];
    [_bodyView addSubview:SearchHistoryLable];
    //清空历史
    UIButton * cleanHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanHistoryButton.frame = CGRectMake(kUIScreenWidth - 80, Height + 55, 60, 20);
    [cleanHistoryButton setTitle:@"清空历史" forState:UIControlStateNormal];
    [cleanHistoryButton setTitleColor:RGBColor(122, 122, 122) forState:UIControlStateNormal];
    cleanHistoryButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cleanHistoryButton addTarget:self action:@selector(cleanHistoryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bodyView addSubview:cleanHistoryButton];
    //搜索历史下边的 线条
    self.bottomLable = [[UILabel alloc] initWithFrame:CGRectMake(20, SearchHistoryLable.y + 20 + 10, kUIScreenWidth - 40, 1)];
    _bottomLable.backgroundColor = RGBColor(225, 225, 225);
    [_bodyView addSubview:_bottomLable];
    //暂无搜索记录
    self.NoRecordLable = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 100)/2 + 20, _bottomLable.y + 50, 100, 20)];
    _NoRecordLable.text = @"暂无搜索记录";
    _NoRecordLable.textColor = RGBColor(162, 162, 162);
    _NoRecordLable.font = [UIFont systemFontOfSize:14];
    [_bodyView addSubview:_NoRecordLable];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kUIScreenWidth - 100)/2 -10, _bottomLable.y + 50, 20, 20)];
    _imageView.image = [UIImage imageNamed:@"searchHistory"];
    [_bodyView addSubview:_imageView];
}
/**
 *  搜索历史界面布局及显示
 */
- (void)configerSearchHistory{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"titleAry"];
    MyLog(@"titleArr-----%@",array);
    if (array.count > 9) {
        NSRange range = {array.count - 9 ,9};
        array = [array subarrayWithRange:range];
    }
    NSMutableArray * titleAry = [NSMutableArray new];
    NSSet *set = [NSSet setWithArray:array];
    for (NSString * title in set) {
        [titleAry addObject:title];
    }
    if (array.count > 0) {//如果有东西，就说明有搜索历史，隐藏本来的控件
        self.NoRecordLable.hidden = YES;
        self.imageView.hidden = YES;
    }
    for (int i = 0; i < titleAry.count; i++) {
        CGFloat Width = (kUIScreenWidth - 70) / 3;
        UIButton * optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        optionButton.backgroundColor = [UIColor whiteColor];
        optionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [optionButton setTitleColor:RGBColor(123, 123, 123) forState:UIControlStateNormal];
        [optionButton setTitle:titleAry[i] forState:UIControlStateNormal];
        optionButton.frame = CGRectMake(20 +  (Width + 15) * (i%3), _bottomLable.y + 10 + (25 + 20) * (i/3), Width, 35);
        optionButton.tag = 1000;
        optionButton.layer.masksToBounds = YES;
        optionButton.layer.cornerRadius = 10;
        [optionButton addTarget:self action:@selector(optionButtonClieked:) forControlEvents:UIControlEventTouchUpInside];
        [_bodyView addSubview:optionButton];
    }
}
#pragma mark -- 换一批
/**
 *  换一批按钮点击事件
 */
- (void)changeButtonClicked{
    
    self.selctedView.hidden = YES;
    
    NSMutableArray * ary = [NSMutableArray array];
    
    if (self.titleAry2.count > 9) {//大于9个
        NSInteger count = self.titleAry2.count/9;
        if (count == 1) {
            NSArray * subAry1 = [self.titleAry2 subarrayWithRange:NSMakeRange(0, 9)];
            NSArray * subAry2 = [self.titleAry2 subarrayWithRange:NSMakeRange(9, self.titleAry2.count - 9)];
            [ary addObject:subAry1];
            [ary addObject:subAry2];
        }else if (count == 2){
            NSArray * subAry1 = [self.titleAry2 subarrayWithRange:NSMakeRange(0, 9)];
            NSArray * subAry2 = [self.titleAry2 subarrayWithRange:NSMakeRange(9, 9)];
            NSArray * subAry3 = [self.titleAry2 subarrayWithRange:NSMakeRange(18, self.titleAry2.count - 18)];
            [ary addObject:subAry1];
            [ary addObject:subAry2];
            [ary addObject:subAry3];
        }else if (count == 3){
            NSArray * subAry1 = [self.titleAry2 subarrayWithRange:NSMakeRange(0, 9)];
            NSArray * subAry2 = [self.titleAry2 subarrayWithRange:NSMakeRange(9, 9)];
            NSArray * subAry3 = [self.titleAry2 subarrayWithRange:NSMakeRange(18, 9)];
            NSArray * subAry4 = [self.titleAry2 subarrayWithRange:NSMakeRange(27, self.titleAry2.count - 27)];
            [ary addObject:subAry1];
            [ary addObject:subAry2];
            [ary addObject:subAry3];
            [ary addObject:subAry4];
        }else if (count == 4){
            NSArray * subAry1 = [self.titleAry2 subarrayWithRange:NSMakeRange(0, 9)];
            NSArray * subAry2 = [self.titleAry2 subarrayWithRange:NSMakeRange(9, 9)];
            NSArray * subAry3 = [self.titleAry2 subarrayWithRange:NSMakeRange(18,9)];
            NSArray * subAry4 = [self.titleAry2 subarrayWithRange:NSMakeRange(27, 9)];
            NSArray * subAry5 = [self.titleAry2 subarrayWithRange:NSMakeRange(36, self.titleAry2.count - 36)];
            [ary addObject:subAry1];
            [ary addObject:subAry2];
            [ary addObject:subAry3];
            [ary addObject:subAry4];
            [ary addObject:subAry5];
        }

        if (count == 1) {
            if (self.changeButPage == 2) {
                self.changeButPage = 0;
            }
            if (count == self.changeButPage%2) {
                self.titleAry = ary[0];
            }else{
            self.titleAry = ary[self.changeButPage%2];
            }
        }else if (count == 2){
            if (self.changeButPage == 3) {
                self.changeButPage = 0;
            }
            if (count == self.changeButPage%3) {
                self.titleAry = ary[0];
            }else{
            self.titleAry = ary[self.changeButPage%3];
            }
        }else if (count == 3){
            if (self.changeButPage == 4) {
                self.changeButPage = 0;
            }
            if (count == self.changeButPage%3) {
                self.titleAry = ary[0];
            }else{
            self.titleAry = ary[self.changeButPage%4];
            }
        }else if (count == 4){
            if (self.changeButPage == 5) {
                self.changeButPage = 0;
            }
            if (count == self.changeButPage %3) {
                self.titleAry = ary[0];
            }else{
            self.titleAry = ary[self.changeButPage%5];
            }
        }else{
            
        }
        self.changeButPage++;
    }else{//小于9个
        //什么也不干
        self.titleAry = self.titleAry2;
    }
    
    [self congigerOptionButton];
    [self configerSearchHistory];
}
/**
 * 可选择的按钮点击事件
 */
- (void)optionButtonClieked:(UIButton *)sender{
    self.selctedView.hidden = YES;
    RecommendOptionViewController * recommendOptionVC = [[RecommendOptionViewController alloc] init];
    recommendOptionVC.searchTitle = self.selectedTitle;
    recommendOptionVC.optionSearchText = sender.titleLabel.text;
    [self.navigationController pushViewController:recommendOptionVC animated:YES];
    
    [self saveSearchhistory:sender.titleLabel.text];
}
/**
 *  清空搜索历史纪录
 */
- (void)cleanHistoryButtonClicked{
    MyLog(@"清空搜索历史按钮点击");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"titleAry"];
    for (UIView * view in _bodyView.subviews) {
        if (view.tag == 1000) {
            [view removeFromSuperview];
        }
    }
    self.NoRecordLable.hidden = NO;
    self.imageView.hidden = NO;
}
/**
 *  保存搜索记录的方法
 */
- (void)saveSearchhistory:(NSString *)title{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray * ary = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"titleAry"]];//原来搜索的字符先添加
    [ary addObject:title];
    [userDefault setObject:ary forKey:@"titleAry"];
}

#pragma mark -- UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    RecommendOptionViewController * recommendOptionVC  = [[RecommendOptionViewController alloc] init];
    recommendOptionVC.optionSearchText = searchBar.text;
    recommendOptionVC.searchTitle = self.selectedTitle;
    
    [self.navigationController pushViewController:recommendOptionVC animated:YES];
    //
    if (searchBar.text.length > 0) {
        [self saveSearchhistory:searchBar.text];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [searchBar resignFirstResponder];
    }
}


@end
