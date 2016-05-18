//
//  LeaveMessageTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/15.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "LeaveMessageTableViewController.h"
#import "LeaveMessageTableViewCell.h"
#import "LeaveDetailMessageTableViewCell.h"
#import "LeaveMesModel.h"
@interface LeaveMessageTableViewController ()<UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong)LeaveDetailMessageTableViewCell * cell;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, strong)UITextField * editingTextField;
@property (nonatomic, strong)NSArray * leftTitleAry;

@end

@implementation LeaveMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要留言";//H5界面备用
    self.view.backgroundColor = RGBColor(245, 245, 245);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeaveMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"leaveMessageCell_1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeaveDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"leaveMessageCell_2"];
    
//    [self configerModel];
    [self configerData];
    
}

- (void)configerData{
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self configerModel:responseObj];
    } failure:^(NSError *error) {
        
    }];
}

- (void)configerModel:(id)response{
    NSDictionary * dataDict = response[@"data"];
    self.leftTitleAry = @[@"公司名称:",@"联  系  人:",@"联系电话:",@"联系传真:",@"QQ:"];
    NSArray * array = @[@"gongsi",@"lxr",@"tel",@"chuanzhen",@"qq"];
    self.dataAry = [NSMutableArray array];
    for (int i  = 0; i < _leftTitleAry.count; i++) {
        LeaveMesModel * model = [[LeaveMesModel alloc] init];
        model.leftTitle = _leftTitleAry[i];
        model.contentText = dataDict[array[i]];
        [self.dataAry addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 5) {
        return 45;
    }else if (section == 6){
        return 20;
    }else{
        return 15;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 5) {
        return 140;
    }else if (indexPath.section == 6){
        return 90;
    }else{
        return 45;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 5) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
        view.backgroundColor = RGBColor(245, 245, 245);
        UILabel * leftLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 80, 30)];
        leftLable.text = @"留言内容:";
        leftLable.textColor = RGBColor(110, 110, 110);
        leftLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:leftLable];
        
        UILabel * rightLable = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth - 80, 7, 60, 30)];
        rightLable.text = @"留言须知";
        rightLable.textColor = RGBColor(115, 115, 115);
        rightLable.font = [UIFont systemFontOfSize:12];
        [view addSubview:rightLable];
        return view;
    }else if (section == 6){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 20)];
        view.backgroundColor = RGBColor( 245, 245, 245);
        return view;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 15)];
        view.backgroundColor = RGBColor( 245, 245, 245);
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 5) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"leaveMessageCell_2"];
        _cell.backgroundColor = RGBColor(245, 245, 245);
        _cell.textView.delegate = self;
        return _cell;
    }else if (indexPath.section == 6){//我要留言
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        UIButton * leaveMeaasgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leaveMeaasgeButton.frame = CGRectMake(20, 10, kUIScreenWidth - 40, 50);
        [leaveMeaasgeButton setBackgroundColor:RGBColor(30, 78, 145) forState:UIControlStateNormal];
        [leaveMeaasgeButton setTitle:@"提交留言" forState:UIControlStateNormal];
        leaveMeaasgeButton.layer.masksToBounds = YES;
        leaveMeaasgeButton.layer.cornerRadius  = 5;
        [leaveMeaasgeButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:leaveMeaasgeButton];
        cell.backgroundColor = RGBColor(245, 245, 245);
        return cell;
    }
    else{
        LeaveMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaveMessageCell_1"];
        cell.contentField.delegate = self;
        cell.model = self.dataAry[indexPath.section];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/**
 * 提交留言
 */
- (void)saveButtonClicked:(UIButton *)sender{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
    NSArray * array = @[@"gongsi",@"name",@"tel",@"fax",@"qq"];
    NSString * netPath = @"userinfo/pro_feedback";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.chanpinID forKey:@"proid"];
    for (int i = 0; i < self.dataAry.count; i++) {
        if ([self.dataAry[i] contentText] == nil) {
            [SVProgressHUD showErrorWithStatus:@"请确保必填项不为空"];
            return;
        }
        [allParams setObject:[self.dataAry[i] contentText] forKey:array[i]];
    }
    [allParams setObject:_cell.textView.text forKey:@"title"];
    
//    if ([KUserImfor[@"userid"] isEqualToString:self.userid]) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能给自己留言" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [SVProgressHUD showSuccessWithStatus:@"留言成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}
#pragma mark -- 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
}
- (void)textFieldGetValue:(NSString *)value sender:(UITextField *)sender{
    LeaveMessageTableViewCell * cell = (LeaveMessageTableViewCell *)sender.superview.superview.superview;
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    LeaveMesModel * model = self.dataAry[path.section];
    model.contentText = value;
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
//    MyLog(@"改变了");
    NSInteger number = [textView.text length];
    if (number < 200) {
        _cell.countLable.text = [NSString stringWithFormat:@"%ld/200", (long)number];
    }else{
        NSMutableString * string = [_cell.textView.text mutableCopy];
        [string deleteCharactersInRange:NSMakeRange(200, number - 200)];
        _cell.textView.text = string;
        _cell.countLable.text = [NSString stringWithFormat:@"%ld/200", (long)number];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能输入200字" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ensureAction];
    }
}

@end
