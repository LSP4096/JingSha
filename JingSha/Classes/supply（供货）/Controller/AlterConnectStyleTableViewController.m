//
//  AlterConnectStyleTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AlterConnectStyleTableViewController.h"
#import "IssueRequestTableViewCell.h"
#import "IssueModel.h"

@interface AlterConnectStyleTableViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong)NSMutableArray * dataAry;
@property (nonatomic, strong)NSMutableArray * titleAry;
@property (nonatomic ,strong)NSMutableArray * keyAry;
@property (nonatomic, strong)UITextField * editingTextField;
@end
static NSString * indentifier = @"issueCell";

@implementation AlterConnectStyleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系方式";
    self.tableView.bounces = NO;
    [self.tableView registerClass:[IssueRequestTableViewCell class] forCellReuseIdentifier:indentifier];
    self.tableView.backgroundColor = RGBColor(236, 236, 236);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self configerRightTopBut];
    [self configerData];//请求数据
}
- (void)configerRightTopBut{
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 40, 30);
    [but setTitle:@"保存" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(saveButClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:but];
}
/**
 *  请求数据
 */
- (void)configerData{
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}
- (void)getDataFromResponseObj:(id)responseObj{
    MyLog(@"%@", responseObj);
    self.titleAry = [NSMutableArray arrayWithObjects:@"联系人:",@"部门职位:",@"电话:",@"传真:",@"手机:",@"邮箱:",@"QQ:",@"地址:",@"邮编:", nil];
    self.keyAry = [NSMutableArray arrayWithObjects:@"lxr",@"bmzw",@"dianhua",@"chuanzhen",@"shouji",@"youxiang",@"qq",@"dizhi",@"youbian",nil];
    self.dataAry = [NSMutableArray array];
    NSMutableDictionary * dict = responseObj[@"data"];
    for (int i = 0; i < self.titleAry.count; i++) {
        IssueModel * model = [[IssueModel alloc] init];
        model.leftTitle = self.titleAry[i];
        model.contentStr = dict[self.keyAry[i]];
        [self.dataAry addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.section];
    cell.contentField.delegate = self;
    if (indexPath.section == 4 || indexPath.section == 6 || indexPath.section == 8) {
        [cell.contentField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingTextField = textField;//拿到正在编辑的输入框
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
}
/**
 *  右上角保存 按钮
 */
- (void)saveButClicked:(UIButton *)sender{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
    NSString * netPath = @"userinfo/userinfoedit";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    for (int i = 0; i < 9; i++) {
        IssueModel * model = self.dataAry[i];
        if (!model.contentStr) {
            return;
        }else{
            [allParams setObject:model.contentStr forKey:_keyAry[i]];
        }
    }
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"%@", responseObj);
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}
/**
 *  及时拿到输入框内的值，并传给model 
 */
- (void)textFieldGetValue:(NSString *)value sender:(UITextField *)sender{
    IssueRequestTableViewCell * cell = (IssueRequestTableViewCell *)sender.superview.superview.superview;
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    IssueModel * model = self.dataAry[path.section];
//    MyLog(@"^^^%@", value);
    model.contentStr = value;
}


@end
