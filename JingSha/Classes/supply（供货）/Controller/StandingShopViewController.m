//
//  StandingShopViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "StandingShopViewController.h"
#import "convertHistoryTableViewController.h"
#import "ScoreShopCollectionViewCell.h"
#import "ScoreShopDetailViewController.h"
#import "SDCycleScrollView.h"
#import "ShopCenterModel.h"
#import "BannerDetailViewController.h"
#define pageCount 10
@interface StandingShopViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *convertBut;
@property (weak, nonatomic) IBOutlet UIButton *scoreBut;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *topBannerView;

@property (nonatomic, strong)UICollectionView * baseCollectionView;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, strong)NSArray * bannerAry;
@property (nonatomic, strong)NSMutableArray * bannerLinkAry;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, copy)NSString * jifen;
@end

static NSString * indentifier = @"shopCell";
@implementation StandingShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分商城";
    [self.view addSubview:self.baseCollectionView];
    self.dataAry = [NSMutableArray array];
    self.bannerAry = [NSArray array];
    self.bannerLinkAry = [NSMutableArray array];
    self.page = 1;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshNewData];
}

- (void)configerBanner:(NSArray *)ary{
//    MyLog(@"+_+%@", ary);
    NSMutableArray * imageAry = [NSMutableArray array];
    NSMutableArray * titleAry = [NSMutableArray array];
    for (NSDictionary * dict in ary) {
        [imageAry addObject:dict[@"photo"]];
        [titleAry addObject:dict[@"title"]];
        [self.bannerLinkAry addObject:dict[@"link"]];
    }
    self.topBannerView.isButtomTitleLabel = YES;
    self.topBannerView.titleLabelBackgroundColor = [UIColor grayColor];
    self.topBannerView.dotColor = [UIColor whiteColor];
    self.topBannerView.titleLabelTextColor = [UIColor whiteColor];
    self.topBannerView.placeholderImage = [UIImage imageNamed:@"NetBusy"];
    self.topBannerView.imageURLStringsGroup = imageAry;
    self.topBannerView.titlesGroup = titleAry;
    self.topBannerView.delegate = self;
}

- (void)loadData{
    NSString * netPath = @"userinfo/shop_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(self.page) forKey:@"page"];
    [allParams setObject:@(pageCount) forKey:@"pagecount"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self configerDataFromResponse:responseObj];
        [_baseCollectionView.footer endRefreshing];
        [_baseCollectionView.header endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

- (void)configerDataFromResponse:(id)responseObj{
    self.jifen = responseObj[@"jifen"];
    [self.scoreBut setTitle:[NSString stringWithFormat:@"积分%@",responseObj[@"jifen"]] forState:UIControlStateNormal];
    if (![responseObj[@"banlist"] isKindOfClass:[NSNull class]] && self.bannerAry.count == 0) {//不会重复刷新显示
        self.bannerAry = [NSArray arrayWithArray:responseObj[@"banlist"]];
        [self configerBanner:self.bannerAry];
    }
    if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        NSArray * ary = responseObj[@"data"];
        for (NSDictionary * dict in ary) {
            ShopCenterModel * model = [ShopCenterModel objectWithKeyValues:dict];
            [self.dataAry addObject:model];
        }
    }
    [_baseCollectionView reloadData];
}


- (UICollectionView *)baseCollectionView{
    if (_baseCollectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kUIScreenWidth - 50)/2, (kUIScreenWidth - 50)/2);
        self.baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 214, kUIScreenWidth, kUIScreenHeight - 214) collectionViewLayout:layout];
        _baseCollectionView.backgroundColor = RGBColor(236, 236, 236);
        _baseCollectionView.delegate = self;
        _baseCollectionView.dataSource = self;
        //
        [_baseCollectionView registerNib:[UINib nibWithNibName:@"ScoreShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:indentifier];
        //
        _baseCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _baseCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    }
    return _baseCollectionView;
}

- (void)refreshNewData{
    self.page = 1;
    [self.dataAry removeAllObjects];
    [self loadData];
}

- (void)reloadMoreData{
    self.page++;
    [self loadData];
}

#pragma mark --UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 15, 0, 15);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        ScoreShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
        return cell;
    }
    ScoreShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ScoreShopDetailViewController * scoreDetailVC = [[ScoreShopDetailViewController alloc ] init];
    scoreDetailVC.sid = [self.dataAry[indexPath.row] ID];
    if ([[self.dataAry[indexPath.row] jifen] integerValue] > [self.jifen integerValue]) {
//        UIAlertView * alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"积分不足" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
    }
    [self.navigationController pushViewController:scoreDetailVC animated:YES];
}

#pragma mark --- 兑换记录和banner图点击事件
- (IBAction)converthistoryButClicked:(UIButton *)sender {
    //兑换记录
    convertHistoryTableViewController * convertVC = [[convertHistoryTableViewController alloc] init];
    [self.navigationController pushViewController:convertVC animated:YES];
}
/**
 *  banner图
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerDetailViewController * bannerDetailVC = [[BannerDetailViewController alloc] init];
    bannerDetailVC.HTMLStr = self.bannerLinkAry[index];
    [self.navigationController pushViewController:bannerDetailVC animated:YES];
}

@end
