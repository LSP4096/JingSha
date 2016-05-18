//
//  SupplierSearchTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/10.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "SupplierSearchTableViewController.h"
#import "AllSearchTableViewCell.h"
#import "SelectAreaViewController.h"
#import "SelectTypeViewController.h"

#import "CompTypeViewController.h"
@interface SupplierSearchTableViewController ()

@end

@implementation SupplierSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    [self conigureTableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"AllSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"allSearchCell"];
}
- (void)conigureTableView {
    /**
     左侧
     */
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tab-left"] style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    /**
     右侧
     */
    UIButton *btn=[[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 20, 20);
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片左移15
    //    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn setImage:[UIImage resizedImage:@"home22"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleRightItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView.backgroundColor = RGBAColor(235, 235, 235, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"AllSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"allSearchCell"];
}
/**
 搜索界面左侧按钮响应事件
 */
- (void)popself {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  搜索界面右侧按钮响应事件
 */
- (void)handleRightItem {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArray = @[@"地区", @"类目"];
    AllSearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"allSearchCell"];
    cell.titleLable.text = titleArray[indexPath.section];
    cell.contentLable.text = @"不限";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AllSearchTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        //筛选地区
        SelectAreaViewController * selectVC = [[SelectAreaViewController alloc] init];
        selectVC.myblock = ^(NSString *cityName){
            if (cityName == nil) {
                cell.contentLable.text = @"不限";
            }else{
                cell.contentLable.text = cityName;
            }
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }else{
        //筛选类目
//        SelectTypeViewController * selectTypeVC = [[SelectTypeViewController alloc] init];
//        [self.navigationController pushViewController:selectTypeVC animated:YES];
        CompTypeViewController * suppVC = [[CompTypeViewController alloc] init];
        suppVC.myblock = ^(NSString * string){
            if (string == nil) {
                cell.contentLable.text = @"不限";
            }else{
                cell.contentLable.text = string;
            }
        };
        [self.navigationController pushViewController:suppVC animated:YES];
        
    }
}

@end
