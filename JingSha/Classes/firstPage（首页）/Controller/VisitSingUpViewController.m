//
//  VisitSingUpViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/18.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "VisitSingUpViewController.h"
#import "BannerTopTableViewCell.h"
#import "SleepTableViewCell.h"
#import "ContentTableViewCell.h"
#import "IssueModel.h"
#import "SleepModel.h"
#import "MyTextView.h"
@interface VisitSingUpViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ContentTableViewCellDelegate, SleepTableViewCellDelegate>
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, strong)NSMutableArray * sleepAry;
@property (nonatomic, strong)UITextField * editingTextField;
@property (nonatomic, strong)SleepModel * sleepModel;
@property (nonatomic, copy)NSString * detailStr1;
@property (nonatomic, copy)NSString * detailStr2;
@end

static NSString * indentifier1 = @"bannerTopCell";
static NSString * indentifier2 = @"sleepCell";
static NSString * indentifier3 = @"contentCell";
@implementation VisitSingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.sale) {
        self.title = @"参展报名";
    }else{
        self.title = @"参观报名";
    }
    self.detailStr1 = [NSString string];
    self.detailStr2 = [NSString string];
    [self configerData];
    [self getDataFromUrl];
    [self configerTableView];
}
- (void)getDataFromUrl{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@"29" forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self configerDataSleep:responseObj];
    } failure:^(NSError *error) {
        
    }];
}

- (void)configerDataSleep:(id)response{
    NSArray * ary = response[@"data"];
    self.sleepAry = [NSMutableArray array];
    for (NSDictionary * dict in ary) {
        SleepModel * model = [SleepModel objectWithKeyValues:dict];
        [self.sleepAry addObject:model];
    }
    [_baseTable reloadData];
}

- (void)configerData{
    self.dataAry = [NSMutableArray array];
    NSArray * ary = @[@"企业名称:",@"企业地址:",@"展位数量:",@"联系电话:",@"电子邮件:",@"姓名:",@"职务:",@"手机:"];
    for (int i = 0; i < ary.count; i++) {
        IssueModel * model = [[IssueModel alloc] init];
        model.leftTitle = ary[i];
        [self.dataAry addObject:model];
    }
}

- (void)configerTableView{
    self.baseTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _baseTable.separatorStyle = 0;
    [self.view addSubview:_baseTable];
    _baseTable.delegate = self;
    _baseTable.dataSource = self;
    //
    [_baseTable registerNib:[UINib nibWithNibName:@"BannerTopTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier1];
    [_baseTable registerNib:[UINib nibWithNibName:@"SleepTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier2];
    [_baseTable registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"contentCell"];
}
#pragma mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 12;
    if (self.sale) {
        return 11;
    }else{
        return 12;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 8) {
        return self.sleepAry.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section >= 0 && section <= 7) {
        return 15;
    }
    if (self.sale) {
        if (section == 8 || section == 9) {
            return 40;
        }else{
            return 20;
        }
    }else{
        if (section == 8 || section == 9 || section == 10) {
            return 40;
        }else{
            return 20;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sale) {
        if (indexPath.section == 9) {
            return 150;
        }else if (indexPath.section == 10){
            return 80;
        }else{
            return 40;
        }
    }else{
        if (indexPath.section == 9 || indexPath.section == 10) {
            return 150;
        }else if(indexPath.section == 11){
            return 80;
        }else{
            return 40;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
    view.backgroundColor = RGBColor(236, 236, 236);
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = RGBColor(136,136,136);
    if (self.sale) {
            if (section == 8) {
                lable.text = @"住宿要求";
            }else if (section == 9){
                lable.text = @"主要参展产品";
            }
    }else{
        if (section == 8) {
            lable.text = @"住宿要求";
        }else if (section == 9){
            lable.text = @"主要采购产品";
        }else if(section == 10){
            lable.text = @"意向采购产品";
        }
    }
    [view addSubview:lable];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >= 0 && indexPath.section <= 7) {
        BannerTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier1 forIndexPath:indexPath];
        cell.contentField.delegate = self;
        cell.contentField.tag = 3000 + indexPath.section;
        cell.model = self.dataAry[indexPath.section];
        return cell;
    }
    if (indexPath.section == 8){//住宿
        SleepTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
        cell.dayTextField.tag = 4000 + indexPath.row;
        cell.dayTextField.delegate = self;
        cell.delegate = self;
        cell.model = self.sleepAry[indexPath.row];
        return cell;
    }
    if (self.sale) {
        if (indexPath.section == 9){
            ContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier3 forIndexPath:indexPath];
            cell.delegate = self;
            cell.textview.text = self.detailStr1;
            cell.textview.tag = 6000 + indexPath.section;
            return cell;
        }
        if (indexPath.section == 10) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(20, 0, kUIScreenWidth - 40, 50);
                button.backgroundColor = RGBColor(30,78,145);
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 5;
                [button setTitle:@"确认提交" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(confirmButtonCliced) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
            }
            cell.backgroundColor = RGBColor(236, 236, 236);
            return cell;
        }
    }else{//不是卖家，多一个分区
        if (indexPath.section == 9 || indexPath.section == 10){
            ContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier3 forIndexPath:indexPath];
            if (indexPath.section == 9) {
                cell.textview.text = self.detailStr1;
            }else{
                cell.textview.text = self.detailStr2;
            }
            cell.textview.tag = 6000 + indexPath.section;
            cell.delegate = self;
            return cell;
        }else{//最后一个确认提交
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(20, 0, kUIScreenWidth - 40, 50);
                button.backgroundColor = RGBColor(30,78,145);
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 5;
                [button setTitle:@"确认提交" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(confirmButtonCliced) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
            }
            cell.backgroundColor = RGBColor(236, 236, 236);
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 8) {//住宿

    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.editingTextField resignFirstResponder];
}


- (void)sleepclicked:(UITableViewCell *)cells{
    self.sleepModel.isChecked = NO;
    SleepTableViewCell * cell = (SleepTableViewCell *)cells;
    cell.model.isChecked = !cell.model.isChecked;
    NSIndexPath * indexpath = [_baseTable indexPathForCell:cell];
    if (self.sleepAry[indexpath.row] == self.sleepModel) {
        cell.model.isChecked = NO;
    }
    self.sleepModel = self.sleepAry[indexpath.row];
    [_baseTable reloadData];
}
#pragma mark --- 

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldGetValue:textField.text sender:textField];
}

- (void)textFieldGetValue:(NSString *)value sender:(UITextField *)sender{
    if (sender.tag >= 3000 && sender.tag < 4000) {//上边的
        IssueModel * model = self.dataAry[sender.tag - 3000];
        model.contentStr = value;
    }else if (sender.tag >= 4000 && sender.tag < 5000){
        SleepModel * model = self.sleepAry[sender.tag - 4000];
        model.timeStr = value;
    }
    [_baseTable reloadData];
}
#pragma mark ---
- (void)textViewChanged:(MyTextView *)sender{
    if (sender.tag == 6009) {
        self.detailStr1 = sender.text;
    }else if (sender.tag == 6010){
        self.detailStr2 = sender.text;
    }
}

#pragma mark --
- (void)confirmButtonCliced{
    [self textFieldDidEndEditing:self.editingTextField];
    
    for (int i = 0; i < 8; i++) {
        if ([self.dataAry[i] contentStr].length == 0) {//没有值
            [self showAlertview:@"请确保必填项不为空"];
            return;
        }
    }
   
    
    NSArray * keyAry = @[@"qymc",@"qydz",@"zwsl",@"fax",@"email",@"username",@"zhiwu",@"tel"];
    
    
    NSString *netPath = [NSString string];
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    for (int i = 0; i < 8; i++) {
        [allParams setObject:[self.dataAry[i] contentStr] forKey:keyAry[i]];
    }
    [allParams setObject:self.hid forKey:@"hid"];

//    NSMutableArray * ary = [NSMutableArray array];
    for (SleepModel * model in self.sleepAry) {
        if (model.isChecked) {
//            [ary addObject:model];
            if (model.timeStr.length == 0) {
                [self showAlertview:@"请选择住宿天数"];
                return;
            }else{
                //选了住宿，并写了时间
                [allParams setObject:model.title forKey:@"zsyq"];
                [allParams setObject:model.timeStr forKey:@"num"];
            }
        }else{
            //不住宿
        }
    }
//    if (ary.count == 0) {
//        [self showAlertview:@"请选择住宿"];
//        return;
//    }
//    if (ary.count != 0 && [[ary firstObject] timeStr].length == 0) {
//        [self showAlertview:@"请选择住宿天数"];
//        return;
//    }
    
//    [allParams setObject:[[ary firstObject] title] forKey:@"zsyq"];
//    [allParams setObject:[[ary firstObject] timeStr] forKey:@"num"];
    
    if (self.sale) {//参展
        netPath = @"userinfo/canzhan_feedback";
        if (self.detailStr1.length == 0) {
            [self showAlertview:@"请填写参展产品"];
            return;
        }else{
            [allParams setObject:self.detailStr1 forKey:@"czcp"];
        }
    }else{
        netPath = @"userinfo/canguang_feedback";
        if (self.detailStr1.length == 0) {
            [self showAlertview:@"请填写主要采购产品"];
            return;
        }else if(self.detailStr2.length == 0){
            [self showAlertview:@"请填写意向采购产品"];
            return;
        }
    }
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"^^^^^^^%@", responseObj);
        [SVProgressHUD showSuccessWithStatus:@"报名成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

- (void)showAlertview:(NSString *)string{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertView show];
}


@end
