//
//  ConnectTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ConnectTableViewController.h"
#import "ConnectStyleTableViewCell.h"
#import "ConnectModel.h"
@interface ConnectTableViewController ()

//@property (nonatomic, strong)NSDictionary * dataDict;
@property (nonatomic, strong)NSMutableArray * dataAry;
@end

@implementation ConnectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configerData];
//    self.tableView.bounces = NO;
    self.tableView.backgroundColor  = RGBColor(236, 236, 236);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.view.frame = CGRectMake(0, 45 + kNavigationBarHeight, kUIScreenWidth, kUIScreenHeight - kNavigationBarHeight - 45);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"ConnectStyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"connectCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)configerData{
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    if (self.proID) {
        [allParams setObject:self.proID forKey:@"userid"];
    }else{
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    }
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}
- (void)getDataFromResponseObj:(id)responseObj{
//    MyLog(@"%@", responseObj);
    self.dataAry = [NSMutableArray array];
    NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"联系人:",@"部门职位:", @"电话:", @"传真:", @"手机:", @"邮箱:", @"QQ:", @"地址:", @"邮编:", nil];
    NSMutableArray * keyAry = [NSMutableArray arrayWithObjects:@"lxr",@"bmzw",@"dianhua",@"chuanzhen",@"shouji",@"youxiang",@"qq",@"dizhi",@"youbian",nil];
    for (int i = 0; i < titleAry.count; i++) {
        ConnectModel * model = [[ConnectModel alloc] init];
        model.titleStr = titleAry[i];
        model.contentStr = responseObj[@"data"][keyAry[i]];
        [self.dataAry addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnectStyleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"connectCell"];
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
