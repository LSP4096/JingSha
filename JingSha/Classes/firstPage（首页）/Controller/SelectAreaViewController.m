//
//  SelectAreaViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SelectAreaViewController.h"
#import "locationTableViewCell.h"
#import "CitiesTableViewCell.h"
#define kFileName  @"city"
#define kFileType  @"plist"
#define kCellIdentifier @"City"
#import "ProvinceModel.h"
#import "HeaderView.h"
#import "CityModel.h"
#import "AlwaysCityTableViewCell.h"
#import "AlwayModel.h"
#import "AllSearchTableViewController.h"
@interface SelectAreaViewController ()<UITableViewDataSource, UITableViewDelegate,HeaderViewDelegate, AlwaysCityTableViewCellDelegate>
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UITableView * baseTableView;
@property (nonatomic, strong)NSMutableArray * cityAry;//根据返回的数据得到产品集中地数组
@property (nonatomic, strong)NSMutableArray * productCity;
@property (nonatomic, strong)NSIndexPath * indexPath;
//
@property (nonatomic, retain) NSMutableArray *provinceArr; //存储省对象
//
@property (nonatomic, strong) NSMutableArray *cityList;

@property (nonatomic, strong) CityModel *selectedCity;
@property (nonatomic, strong)AlwayModel * alwayModel;

@property (nonatomic, assign)BOOL first;
@end

static NSString *const cityReuseIdentifier = @"CitiesTableViewCell";
static NSString * const alwayIndentifier = @"alwayCell";
@implementation SelectAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选地区";
    self.view.backgroundColor = RGBAColor(236, 236, 236, 1);
    
    self.first = YES;
    [self configerData];
    [self loadData];
//    [self configerTopSearchBar];
    [self configerUITableView];
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.baseTableView didSelectRowAtIndexPath:self.indexPath];//默认  所有地区  被选中
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)configerData{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    NSArray * ary = @[@"26",@"27"];
    self.productCity = [NSMutableArray array];
    self.cityAry = [NSMutableArray array];
//    [allParams setObject:@"26" forKey:@"cid"];
    for (NSString * str in ary) {
        [allParams setObject:str forKey:@"cid"];
        [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
            [self getDataWithResponse:responseObj cid:str];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)getDataWithResponse:(id)response cid:(NSString *)cid{
    NSArray * ary = response[@"data"];
    if ([cid isEqualToString:@"26"]) {//产品集中地
        for (NSDictionary * dict in ary) {
            AlwayModel * model = [AlwayModel objectWithKeyValues:dict];
            [self.cityAry addObject:model];
        }
    }else if ([cid isEqualToString:@"27"]){//27常用城市
        for (NSDictionary * dict in ary) {
            AlwayModel * model = [AlwayModel objectWithKeyValues:dict];
            [self.productCity addObject:model];
        }
    }
    [_baseTableView reloadData];
}


/**
 * 从本地文件夹在数据
 */
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kFileName ofType:kFileType];
    NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];
    self.provinceArr = [NSMutableArray array];
    self.cityList = [NSMutableArray array];
    for (NSDictionary *tempDic in dataSource) {
        ProvinceModel * model = [ProvinceModel objectWithKeyValues:tempDic];
        [self.provinceArr addObject:model];
        
        NSMutableArray *proviceCities = [NSMutableArray array];
        for (NSString *cityName in model.cities) {
            CityModel *city = [[CityModel alloc]init];
            city.cityName = cityName;
            [proviceCities addObject:city];
        }
        [self.cityList addObject:proviceCities];
    }
}

/**
 *  配置搜索栏
 */
- (void)configerTopSearchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, kNavigationBarHeight, kUIScreenWidth - 40, 60)];
    _searchBar.placeholder = @"输入城市名字";
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    [self.view addSubview:_searchBar];
}
//取消searchBar背景色
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
/**
 *  配置UITableView
 */
- (void)configerUITableView{
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStyleGrouped];
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    [self.view addSubview:_baseTableView];
    //分割线缩进
    if ([_baseTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_baseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_baseTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_baseTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //注册cell
    [_baseTableView registerNib:[UINib nibWithNibName:@"locationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [_baseTableView registerNib:[UINib nibWithNibName:@"CitiesTableViewCell" bundle:nil] forCellReuseIdentifier:cityReuseIdentifier];
    [_baseTableView registerNib:[UINib nibWithNibName:@"AlwaysCityTableViewCell" bundle:nil] forCellReuseIdentifier:alwayIndentifier];
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:inset];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = 4 + self.provinceArr.count - 1;
    return count;//返回区数。下边的省，一个省一个区
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 0;
    }else{
        ProvinceModel *model = self.provinceArr[section - 4];
        return model.isOpen ? model.cities.count : 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section >= 4){
        return 45;
    }else{
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 || indexPath.section == 2) {
        return 72;
    }else{
        return 44;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"   常用城市";
    }else if (section == 2){
        return @"   产品集中地";
    }else if (section == 3){
        return @"   省市";
    }else if (section == 0){
        return @"";
    }else{
        return nil;
    }
}
/**
 *  返回区头视图。
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderView * aView = [[HeaderView alloc] init];
    aView.tag = (NSInteger)2000 + section;
    if (section >= 4) {
        ProvinceModel *model = self.provinceArr[section - 4];
        aView.model = model;
        aView.delegate = self;
    }else{
        return nil;
    }
    return aView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityReuseIdentifier forIndexPath:indexPath];
            CityModel *city = self.cityList[34][0];
            cell.cityName = city.cityName;
            cell.checked = city.checked;
            return cell;
        }else{
            locationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
            cell.myBlock = ^(NSString * string){
                AlwayModel * model = [[AlwayModel alloc] init];
                model.title = string;
                if (![string isEqualToString:@"定位中"]) {
                    [self.productCity insertObject:model atIndex:0];
                }
                if (self.first) {
                    [self.baseTableView reloadData];
                    self.first = NO;
                }
            };
            return cell;
        }
    }else if (indexPath.section == 1){
        AlwaysCityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:alwayIndentifier forIndexPath:indexPath];
        cell.delegate =  self;
        cell.array = self.productCity;
        return cell;
    }else if (indexPath.section == 2){
        AlwaysCityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:alwayIndentifier forIndexPath:indexPath];
        cell.delegate =  self;
        cell.array = self.cityAry;
        return cell;
    }else if (indexPath.section == 3){
        return nil;
    }else{
        CitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityReuseIdentifier forIndexPath:indexPath];
        CityModel *city = self.cityList[indexPath.section - 4][indexPath.row];
        cell.cityName = city.cityName;
        cell.checked = city.checked;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= 4) {//本次点击的是4区以后
        CityModel *city = self.cityList[indexPath.section - 4][indexPath.row];
        self.selectedCity.checked = NO;//要保存上一个点击的city，中转的这个model，要是同一个类，也要有相同的属性
        city.checked = !city.checked;
        self.selectedCity = city;//记录一下被选中的city
        MyLog(@"%@", city.cityName);//在这里得到选中的地区，返回的时候根据选中的地区筛选
        
        self.alwayModel.isSelected = NO;
        if (self.myblock) {
            self.myblock(city.cityName);
        }
        
        [SingleTon shareSingleTon].zcdStr = city.cityName;
    }else if (indexPath.section == 0 && indexPath.row == 0){
        CityModel *city = self.cityList[34][0];
        self.selectedCity.checked = NO;
        city.checked = !city.checked;
        self.selectedCity = city;
        //
        self.alwayModel.isSelected = NO;
        //
        if (self.myblock) {
            self.myblock(nil);
        }
    }
    [self.baseTableView reloadData];
}

#pragma mark --HeaderViewDelegate
- (void)buttonClick:(UIButton *)sender{
    HeaderView *aView = (HeaderView *)sender.superview;//加载自定义的区头视图
    ProvinceModel *model = self.provinceArr[aView.tag - 2000 - 4];
    model.isOpen = !model.isOpen;
    [self.baseTableView reloadData];
}

//代理
- (void)alwaycityClicked:(UIButton *)sender cell:(UITableViewCell *)cells{
    NSIndexPath * indexpath =  [_baseTableView indexPathForCell:cells];
    self.selectedCity.checked = NO;
    self.alwayModel.isSelected = NO;
    AlwayModel * model;
    if (indexpath.section == 1) {
        model = self.productCity[sender.tag - 2000];
        for (int i = 0; i < self.cityAry.count;i++) {
            AlwayModel * models = self.cityAry[i];
            models.isSelected = NO;
        }
        
    }else if(indexpath.section == 2){
        model = self.cityAry[sender.tag - 2000];
        for (int i = 0; i < self.productCity.count;i++) {
            AlwayModel * models = self.productCity[i];
            models.isSelected = NO;
        }
    }
    model.isSelected = YES;
    self.alwayModel = model;
    
    if (self.myblock) {
        self.myblock(model.title);
    }
    [SingleTon shareSingleTon].zcdStr = model.title;
    [_baseTableView reloadData];
}

@end
