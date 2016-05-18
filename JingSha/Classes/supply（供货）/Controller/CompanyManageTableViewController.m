//
//  CompanyManageTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/20.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CompanyManageTableViewController.h"
#import "CompanyManageTableViewCell.h"
#import "MyRequestViewController.h"
#import "SupplyManageViewController.h"
#import "CompanyJudgeTableViewController.h"
#import "CompanyMessageViewController.h"
@interface CompanyManageTableViewController ()

@end
static NSString * indentifier = @"companyManageCell";
@implementation CompanyManageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业管理";
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanyManageTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置分割线的缩进
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = RGBColor(236, 236, 236);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyManageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    NSArray * titleAry = @[@"求购管理",@"供应管理",@"企业信息",@"企业评价"];
    NSArray * imageAry = @[@"Me_request",@"Me_supply",@"Me_message",@"Me_judge"];
    cell.titleLable.text = titleAry[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:imageAry[indexPath.section]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MyRequestViewController *myRequestVC = [[MyRequestViewController alloc] init];
        myRequestVC.fromMe = YES;
        [self.navigationController pushViewController:myRequestVC animated:YES];
    }else if (indexPath.section == 1){
        SupplyManageViewController * supplyVC = [[SupplyManageViewController alloc] init];
        [self.navigationController pushViewController:supplyVC animated:YES];
    }else if (indexPath.section == 2){
        CompanyMessageViewController * companyMessageVC = [[CompanyMessageViewController alloc] init];
        companyMessageVC.isCanAlter = YES;
        [self.navigationController pushViewController:companyMessageVC animated:YES];
    }else{
        CompanyJudgeTableViewController * companyJudgeVC =[[CompanyJudgeTableViewController alloc] init];
        [self.navigationController pushViewController:companyJudgeVC animated:YES];
    }
}



@end
