//
//  CompTypeViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/14.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "CompTypeViewController.h"
#import "CitiesTableViewCell.h"
#import "HeaderView.h"
#import "TypeModel.h"
@interface CompTypeViewController ()<UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate>
@property (nonatomic, strong)UITableView * baseTableView;
//
@property (nonatomic, strong) NSMutableArray *SubTypeAry;
@property (nonatomic, strong) TypeModel *Selectedmodel;
@property (nonatomic, strong) TypeModel * AllModel;//这个是不限。最上边的那个。

@property (nonatomic, strong) NSMutableArray * MainAry;
//@property (nonatomic, strong) NSMutableArray *typeItemList;
@end
static NSString *const cityReuseIdentifier = @"CitiesTableViewCell";
@implementation CompTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选类目";
    self.view.backgroundColor = [UIColor whiteColor];
    self.SubTypeAry = [NSMutableArray array];
    self.MainAry = [NSMutableArray array];
    
    [self.view addSubview:self.baseTableView];
    
    self.AllModel = [[TypeModel alloc] init];//做一个model，不在数组内。但会有共同属性
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.baseTableView didSelectRowAtIndexPath:indexPath];
    
    TypeModel * model = [[TypeModel alloc] init];
    model.title = @"企业分类";
    [self.MainAry addObject:model];
    
    
    [self loadData];
}

- (void)loadData
{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@"8" forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        //        MyLog(@"response obj %@", responseObj);
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    for (NSDictionary * dict in responseObj[@"data"]) {
        TypeModel * model = [TypeModel objectWithKeyValues:dict];
        [self.SubTypeAry addObject:model];
    }
    [_baseTableView reloadData];
}

/*
 *  配置UITableView
 */
- (UITableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kUIScreenWidth, kUIScreenHeight - 15) style:UITableViewStyleGrouped];
        _baseTableView.delegate = self;
        _baseTableView.dataSource =self;
        _baseTableView.backgroundColor = RGBColor(245, 245, 245);
        _baseTableView.rowHeight = 45;
//        [self.view addSubview:_baseTableView];
        //注册cell
        [_baseTableView registerNib:[UINib nibWithNibName:@"CitiesTableViewCell" bundle:nil] forCellReuseIdentifier:cityReuseIdentifier];
    }
    return _baseTableView;
}

#pragma mark --UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        TypeModel *model = self.MainAry.firstObject;
        if (model == nil) {
            return 0;
        }
        return model.isOpen ? self.SubTypeAry.count : 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return .01;
    }else{
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        HeaderView *aView = [[HeaderView alloc] init];
        TypeModel *model = self.MainAry[0];
        aView.typeModel = model;
        aView.delegate = self;
        return aView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityReuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        self.AllModel.title = @"不限";
        cell.model = self.AllModel;
    }else{
        TypeModel *model = self.SubTypeAry[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.Selectedmodel.isSelected = NO;
        self.AllModel.isSelected = !self.AllModel.isSelected;
        self.Selectedmodel = self.AllModel;
        if (self.myblock) {
            self.myblock(nil);
        }
    }else{
        TypeModel *model = self.SubTypeAry[indexPath.row];
        self.Selectedmodel.isSelected = NO;
        model.isSelected = !model.isSelected;
        self.Selectedmodel = model;
        MyLog(@"所选择的子类是%@", model.title);
        [SingleTon shareSingleTon].qiyefenleiStr = model.title;
        //
        if (self.myblock) {
            self.myblock(model.title);
        }
    }
    [self.baseTableView reloadData];
}
#pragma mark --HeaderViewDelegate
- (void)buttonClick:(UIButton *)sender{
//    HeaderView * aView = (HeaderView *)sender.superview;
//    NSInteger index = aView.tag - 3000 - 1;
    TypeModel * model =  self.MainAry[0];
    model.isOpen = !model.isOpen;
    [self.baseTableView reloadData];
    
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

