//
//  convertDetailTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "convertDetailTableViewController.h"
#import "convertTopTableViewCell.h"
#import "convertTotalTableViewCell.h"
#import "convertDetailMessageTableViewCell.h"
#import "bottomDetailTableViewCell.h"
#import "StandingShopViewController.h"
#import "DuiHUanHistoryModel.h"
@interface convertDetailTableViewController ()

@property (nonatomic, strong)DuiHUanHistoryModel * model;


@end

static NSString * indentifier = @"converTopCell";
static NSString * indentifier2 = @"convertTotalCell";
static NSString * indentifier3 = @"detailMessageCell";
static NSString * indentifier4 = @"bottomCell";
@implementation convertDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.view.backgroundColor = RGBColor(236, 236, 236);
    self.tableView.tableFooterView=[[UIView alloc]init];//去除多余的分割线
    [self registerCell];
    [self configerData];
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"convertTopTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"convertTotalTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier2];
    [self.tableView registerNib:[UINib nibWithNibName:@"convertDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier3];
    [self.tableView registerNib:[UINib nibWithNibName:@"bottomDetailTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier4];
}

- (void)configerData{
    NSString * netPath = @"userinfo/my_duihuan_info";
    NSMutableDictionary * allParmas = [NSMutableDictionary dictionary];
    [allParmas setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParmas setObject:self.did forKey:@"did"];
    [HttpTool postWithPath:netPath params:allParmas success:^(id responseObj) {
        [self getDataFromResponse:responseObj];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDataFromResponse:(id)responseObj{
    NSDictionary * dict = responseObj[@"data"];
    self.model = [DuiHUanHistoryModel objectWithKeyValues:dict];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2 || section == 3) {
        return 20;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 1){
        return 44;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 44;
        }else{
            return 75;
        }
    }else{
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        convertTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            convertTotalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
            cell.model = self.model;
            return cell;
        }else{
            convertTotalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
            cell.model2 = self.model;
            return cell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            convertTotalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
            cell.leftLable.text = @"收件信息";
            cell.rightLable.text = nil;
            return cell;
        }else{
            convertDetailMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier3 forIndexPath:indexPath];
            cell.model  = self.model;
            return cell;
        }
    }else{
        bottomDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier4 forIndexPath:indexPath];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[StandingShopViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}



@end
