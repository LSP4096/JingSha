//
//  SelectTypeViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "CitiesTableViewCell.h"
#import "HeaderView.h"
#import "TypeModel.h"
@interface SelectTypeViewController ()<UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate>
@property (nonatomic, strong)UITableView * baseTableView;
//
@property (nonatomic, strong) NSMutableArray *SubTypeAry;
@property (nonatomic, strong) TypeModel *Selectedmodel;
@property (nonatomic, strong) TypeModel * AllModel;//这个是不限。最上边的那个。

@property (nonatomic, strong) NSMutableArray *typeItemList;
@end
static NSString *const cityReuseIdentifier = @"CitiesTableViewCell";
@implementation SelectTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选类目";
    self.view.backgroundColor = [UIColor whiteColor];
    self.SubTypeAry = [NSMutableArray array];
    
    [self loadDataWithCcid:nil];
    
    [self.view addSubview:self.baseTableView];
    self.AllModel = [[TypeModel alloc] init];//做一个model，不在数组内。但会有共同属性
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.baseTableView didSelectRowAtIndexPath:indexPath];
}

- (void)loadDataWithCcid:(NSString *)ccid
{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    if (self.typeNum) {
        [allParams setObject:self.typeNum forKey:@"cid"];
    }else{
        [allParams setObject:@"15" forKey:@"cid"];
    }
    if (ccid) {
        [allParams setObject:ccid forKey:@"ccid"];
    }
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"response obj %@", responseObj);
        [self getDataFromResponseObj:responseObj ccid:ccid];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(NSDictionary *)responseObj ccid:(NSString *)ccid
{
    if (ccid == nil) {
        self.typeItemList = [NSMutableArray array];
        for (NSDictionary * dict in responseObj[@"data"]) {
            TypeModel * model = [TypeModel objectWithKeyValues:dict];
            [self.typeItemList addObject:model];
            [self loadDataWithCcid:model.Id];
        }
    }else{
        for (TypeModel *model in self.typeItemList) {
            if ([model.Id isEqualToString:ccid]) {
                NSMutableArray *tempList = [NSMutableArray array];
                for (NSDictionary * dict in responseObj[@"data"]) {
                    TypeModel * model = [TypeModel objectWithKeyValues:dict];
                    [tempList addObject:model];
                }
                model.typeItems = tempList;
            }
        }
    }
    [self.baseTableView reloadData];
}
/*
 *  配置UITableView
 */
- (UITableView *)baseTableView{
    if (_baseTableView == nil) {
        self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kUIScreenWidth, kUIScreenHeight - 15) style:UITableViewStyleGrouped];
        _baseTableView.delegate = self;
        _baseTableView.dataSource =self;
        _baseTableView.backgroundColor = RGBColor(245, 245, 245);
        _baseTableView.rowHeight = 45;
        [self.view addSubview:_baseTableView];
        //注册cell
        [_baseTableView registerNib:[UINib nibWithNibName:@"CitiesTableViewCell" bundle:nil] forCellReuseIdentifier:cityReuseIdentifier];
    }
    return _baseTableView;
}

#pragma mark --UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.typeItemList.count + 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        TypeModel *model = self.typeItemList[section - 1];
        NSArray *subTypeList = model.typeItems;
        return model.isOpen ? subTypeList.count : 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
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
        aView.tag = 3000 + section;
        TypeModel *model = self.typeItemList[section -1];
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
        TypeModel *mainTypeModel = self.typeItemList[indexPath.section - 1];
        TypeModel *model = mainTypeModel.typeItems[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.Selectedmodel.isSelected = NO;
        self.AllModel.isSelected = !self.AllModel.isSelected;
        self.Selectedmodel = self.AllModel;
        
        if ([self.Selectedmodel.title isEqualToString:@"不限"]) {
            if (self.myblock) {
                self.myblock(nil);
            }
        }
        
    }else{
        TypeModel *mainTypeModel = self.typeItemList[indexPath.section - 1];
        TypeModel *model = mainTypeModel.typeItems[indexPath.row];
        self.Selectedmodel.isSelected = NO;
        model.isSelected = !model.isSelected;
        self.Selectedmodel = model;
        MyLog(@"所选择的子类是%@", model.title);
        if (self.myblock) {
            self.myblock(model.title);
        }
        [SingleTon shareSingleTon].leibieStr = model.title;
    }
    [self.baseTableView reloadData];
}
#pragma mark --HeaderViewDelegate
- (void)buttonClick:(UIButton *)sender{
    HeaderView * aView = (HeaderView *)sender.superview;
    NSInteger index = aView.tag - 3000 - 1;
    TypeModel * model =  self.typeItemList[index];
    model.isOpen = !model.isOpen;
    [self.baseTableView reloadData];
}







@end
