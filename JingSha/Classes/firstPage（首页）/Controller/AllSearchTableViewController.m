//
//  AllSearchTableViewController.m
//  
//
//  Created by bocweb on 15/11/23.
//
//

#import "AllSearchTableViewController.h"
#import "UIBarButtonItem+CH.h"
#import "FirstPageViewController.h"
#import "AllSearchTableViewCell.h"
#import "SelectAreaViewController.h"
#import "SelectAttributeViewController.h"
//#import "SelectTypeViewController.h"
#import "SelectProTypeTableViewController.h"
@interface AllSearchTableViewController ()

@end

@implementation AllSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self conigureTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self conigureTableView];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
    NSArray *titleArray = @[@"地区", @"类目", @"属性"];
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
        SelectAreaViewController * selectAreaVC = [[SelectAreaViewController alloc] init];
        selectAreaVC.myblock = ^(NSString *cityName){
            if (cityName == nil) {
                cell.contentLable.text = @"不限";
            }else{
            cell.contentLable.text = cityName;
            }
        };
        [self.navigationController pushViewController:selectAreaVC animated:YES];
    }else if (indexPath.section == 1){
        //筛选类目
//        SelectTypeViewController * selectTypeVC = [[SelectTypeViewController alloc] init];
//        selectTypeVC.myblock = ^(NSString * string){
//            if (string == nil) {
//                cell.contentLable.text = @"不限";
//            }else{
//                cell.contentLable.text = string;
//            }
//        };
//        [self.navigationController pushViewController:selectTypeVC animated:YES];
        SelectProTypeTableViewController * selectTypeVC = [[SelectProTypeTableViewController alloc] init];
        selectTypeVC.isShaixuan = YES;
        selectTypeVC.typeNum = @"15";
        selectTypeVC.myblock = ^(NSString *typeStr) {
            if (typeStr == nil) {
                cell.contentLable.text = @"不限";
            }else{
                cell.contentLable.text = typeStr;
            }
        };
        [self.navigationController pushViewController:selectTypeVC animated:YES];
    }else{
        //筛选属性
        SelectAttributeViewController * selectAttributeVC = [[SelectAttributeViewController alloc] init];
        selectAttributeVC.myblock = ^(NSString * shuxingAtr){
            if (shuxingAtr == nil) {
                cell.contentLable.text = @"不限";
            }else{
                cell.contentLable.text = shuxingAtr;
            }
        };
        [self.navigationController pushViewController:selectAttributeVC animated:YES];
    }
}

@end
