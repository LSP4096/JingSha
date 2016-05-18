//
//  SelectAttributeViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SelectAttributeViewController.h"
#import "HeaderView.h"
#import "TypeModel.h"
#import "CitiesTableViewCell.h"
@interface SelectAttributeViewController ()<UITableViewDataSource, UITableViewDelegate,HeaderViewDelegate>
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)NSMutableArray * MainTypeAry;
@property (nonatomic, strong)NSMutableArray * SubTypeAry;
@property (nonatomic, strong) TypeModel *Selectedmodel;
@property (nonatomic, strong) TypeModel * AllModel;//这个是不限。最上边的那个。
@end

static NSString *const cityReuseIdentifier = @"CitiesTableViewCell";
@implementation SelectAttributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选属性";
    self.view.backgroundColor = RGBAColor(236, 236, 236, 1);
    [self.view addSubview:self.baseTable];
    
    self.MainTypeAry = [NSMutableArray array];
    self.SubTypeAry = [NSMutableArray array];
    self.AllModel = [[TypeModel alloc] init];
    self.AllModel.title = @"不限";
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.baseTable didSelectRowAtIndexPath:indexPath];
    
    TypeModel * model = [[TypeModel alloc] init];
    model.title = @"纱支";
    [self.MainTypeAry addObject:model];
    
    [self loadData];
}

- (void)loadData{
    NSString *netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@"14" forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"大类%@",responseObj);
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
//    [self loadSubData];
    [_baseTable reloadData];
}
/*

 // 找子类
- (void)loadSubData{
    for (int i = 0; i < self.MainTypeAry.count; i++) {
        NSString * netPath = @"pro/typelist";
        NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
        [allParams setObject:@"14" forKey:@"cid"];
        [allParams setObject:[self.MainTypeAry[i] Id] forKey:@"ccid"];
        [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//            MyLog(@"子类%@",responseObj);
            [self getSubDataFromResponseObj:responseObj];
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
    }
}

- (void)getSubDataFromResponseObj:(id)response{
    NSMutableArray * ary = [@[]mutableCopy];
    for (NSDictionary * dict in response[@"data"]) {
        TypeModel * model = [TypeModel objectWithKeyValues:dict];
        [ary addObject:model];
    }
    [self.SubTypeAry addObject:ary];
    [_baseTable reloadData];
}
  */



#pragma mark --- Lazy Loading
- (UITableView *)baseTable{
    if (_baseTable == nil) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStyleGrouped];
        self.baseTable.delegate = self;
        self.baseTable.dataSource = self;
        _baseTable.rowHeight = 45;
        _baseTable.backgroundColor = RGBColor(245, 245, 245);
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"CitiesTableViewCell" bundle:nil] forCellReuseIdentifier:cityReuseIdentifier];
    }
    return _baseTable;
}

#pragma mark --- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSInteger count = self.MainTypeAry.count + 1;
//    return count;
    return self.MainTypeAry.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
//        TypeModel *model = self.MainTypeAry[section - 1];
//        return model.isOpen ? [self.SubTypeAry[section - 1] count] : 0;
        TypeModel *model = self.MainTypeAry[0];
        return model.isOpen ? self.SubTypeAry.count : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 10 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        HeaderView * aView = [[HeaderView alloc] init];
        aView.delegate = self;
//        aView.typeModel = self.MainTypeAry[section - 1];
        
        aView.typeModel = self.MainTypeAry[0];
        aView.tag = 3000 + section;
        return aView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CitiesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cityReuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = self.AllModel;
    }else{
//        cell.model = self.SubTypeAry[indexPath.section - 1][indexPath.row];
        cell.model = self.SubTypeAry[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.Selectedmodel.isSelected = NO;
        self.AllModel.isSelected = !self.AllModel.isSelected;
        self.Selectedmodel = self.AllModel;
        if (self.myblock) {
            self.myblock(@"不限");
        }
    }else{
//        TypeModel *model= self.SubTypeAry[indexPath.section -1][indexPath.row];
        TypeModel * model = self.SubTypeAry[indexPath.row];
        self.Selectedmodel.isSelected = NO;
        model.isSelected = !model.isSelected;
        self.Selectedmodel = model;
        [SingleTon shareSingleTon].zhisuStr = model.title;
        if (self.myblock) {
            self.myblock(model.title);
        }
    }
    [self.baseTable reloadData];
}

#pragma mark -- HeaderViewDelegate
- (void)buttonClick:(UIButton *)sender{
    HeaderView * aView = (HeaderView *)sender.superview;
    NSInteger index = aView.tag - 3000;
    TypeModel * model =  self.MainTypeAry[index - 1];
    model.isOpen = !model.isOpen;
    [self.baseTable reloadData];
//    [self.baseTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
