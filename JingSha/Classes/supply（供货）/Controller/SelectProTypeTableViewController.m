//
//  SelectProTypeTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/2/24.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "SelectProTypeTableViewController.h"
#import "TypeModel.h"
#import "CitiesTableViewCell.h"
@interface SelectProTypeTableViewController ()

@property (nonatomic, strong)NSMutableArray * typeItemList;
@property (nonatomic, strong)TypeModel * Selectedmodel;
@end

static NSString *const cityReuseIdentifier = @"CitiesTableViewCell";
@implementation SelectProTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选类目";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CitiesTableViewCell" bundle:nil] forCellReuseIdentifier:cityReuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self loadDataWithCid];
}

- (void)loadDataWithCid
{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:self.typeNum forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        //        MyLog(@"response obj %@", responseObj);
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(NSDictionary *)responseObj{
    self.typeItemList = [NSMutableArray array];
    for (NSDictionary * dict in responseObj[@"data"]) {
        TypeModel * model = [TypeModel objectWithKeyValues:dict];
        [self.typeItemList addObject:model];
    }
    if (self.isShaixuan) {
        TypeModel * model = [[TypeModel alloc] init];
        model.title = @"不限";
        [self.typeItemList insertObject:model atIndex:0];
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeItemList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityReuseIdentifier forIndexPath:indexPath];
    cell.model = self.typeItemList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.Selectedmodel.isSelected = NO;
    TypeModel * model = self.typeItemList[indexPath.row];
    model.isSelected = YES;
    self.Selectedmodel  = model;
    MyLog(@"所选择的子类是%@", model.title);

    if ([self.Selectedmodel.title isEqualToString:@"不限"]) {
        if (self.myblock) {
            self.myblock(nil);
        }
    }else{
        if (self.myblock) {
            self.myblock(model.title);
        }
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
