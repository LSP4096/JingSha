//
//  AddSupplyViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AddSupplyViewController.h"
#import "TableHeaderView.h"
#import "IssueRequestTableViewCell.h"
#import "AddSupplyTableViewCell.h"
#import "AddTableViewCell.h"
#import "DownTableViewController.h"
#import "ComponentPartViewController.h"
#import <MZFormSheetController.h>
#import "IssueModel.h"
#import "AddSupplyModel.h"
#import "SelectTypeViewController.h"
#import "SelectProTypeTableViewController.h"
@interface AddSupplyViewController ()<UITableViewDataSource, UITableViewDelegate, DownTableViewControllerDelegate, TableHeaderViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, AddSupplyTableViewCellDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)TableHeaderView * headerView;
@property (nonatomic, strong)NSArray * titleAry;
@property (nonatomic, strong)NSMutableArray * detailCellAry;//图文详细有几行，增加一个，该数组插入一个，更新
@property (nonatomic, strong)DownTableViewController * menuTableView;
@property (nonatomic, assign)BOOL showList;
@property (nonatomic, strong)UIImagePickerController * picker;

@property (nonatomic, strong)NSMutableArray * dataSourceAry;
@property (nonatomic, strong)NSArray * cidAry;
@property (nonatomic, strong)NSArray * keyAry;
@property (nonatomic, strong)NSIndexPath * indexPath;
@property (nonatomic, assign)BOOL isDetail;
@property (nonatomic, assign)NSInteger tagRow;
@property (nonatomic, strong)NSArray * photoAry;
@property (nonatomic, strong)NSMutableArray * imgAry;
@property (nonatomic, strong)UITextField * editingTextField;
//
@property (nonatomic, strong)NSMutableArray * backPhotoAry;
@property (nonatomic, strong)NSMutableArray * backImgAry;
@property (nonatomic, copy)NSString * backDetailStr;
@property (nonatomic, strong)NSMutableArray * backDetailAry;
//
@property (nonatomic, strong)NSArray * savaNameAry;
@property (nonatomic, strong)NSArray * savaPrecentAry;


#define KBtnTag(i) (3000+(i))
@end

@implementation AddSupplyViewController

static NSString * indentifier2 = @"issueCell";
static NSString * indentifier3 = @"detailCell";
static NSString * indentifier4 = @"addCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    if (self.isAlter) {
        self.title = @"供应修改";
        [self configerAlterData];
        [self configerRightBut];
    }else{
        self.title = @"添加供应";
        [self configerDetailCellAry];
    }
    self.titleAry = @[];
    self.photoAry = @[];
    self.imgAry = [NSMutableArray array];
    
//    [self setTypeString:@"纱线"];//（默认显示的)
    [self configerUITableView];
    [self configerDownMenu];
}

/**
 *  右上角保存按钮
 */
- (void)configerRightBut{
    UIButton * rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 40, 40);
    [rightBut setTitle:@"保存" forState:UIControlStateNormal];
    rightBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBut addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  =[[UIBarButtonItem alloc] initWithCustomView:rightBut];
}
/**
 *  要是修改的话，就请求一次数据展示出来
 */
- (void)configerAlterData{
    NSString * netPath = @"userinfo/my_pro_info";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.proid forKey:@"proid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self configerDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  获取原始数据
 */
- (void)configerDataFromResponseObj:(id)responseObj{
    NSDictionary * dataDic = responseObj[@"data"];//1纱线2原料
    NSString * str = dataDic[@"type"];
    if (![dataDic[@"photo"] isKindOfClass:[NSNull class]]) {
        self.backPhotoAry = [dataDic[@"photo"] mutableCopy];//上边的返回图片
    }
    if (![dataDic[@"img"] isKindOfClass:[NSNull class]]) {
        self.backImgAry = [dataDic[@"img"] mutableCopy];
    }
    if ([dataDic[@"text"] length] > 0) {
        self.backDetailStr = dataDic[@"text"];
        self.backDetailAry = [[self.backDetailStr componentsSeparatedByString:@"@_@"] mutableCopy];
    }
//    if ([str isEqualToString:@"1"]) {
//        _titleAry = @[@"产品大类:",@"产品名称:",@"原料成分:",@"支数:",@"数量:",@"价格:",@"所属类别:",@"乌斯特质量:"];
//        self.keyAry = @[@"type",@"title",@"chengfen",@"zhisu",@"num",@"jiage",@"leibie",@"wstzl"];
//    }else if ([str isEqualToString:@"2"]){
//        _titleAry = @[@"产品大类:",@"产品名称:",@"所属类别:",@"产品分类:",@"产品规格:",@"数量:"];
//        self.keyAry = @[@"type",@"title",@"leibie",@"fenlei",@"guige",@"num"];
//    }
    self.dataSourceAry = [NSMutableArray array];
    for (int i  = 0; i < _titleAry.count; i++) {
        IssueModel * model = [[IssueModel alloc] init];
        model.leftTitle = _titleAry[i];
        if (i == 0 && [str isEqualToString:@"1"]) {
            model.contentStr = @"纱线";
        }else if(i == 0 && [str isEqualToString:@"2"]){
            model.contentStr = @"原料";
        }else{
            model.contentStr = dataDic[self.keyAry[i]];
        }
        [self.dataSourceAry addObject:model];
    }
    self.detailCellAry = [NSMutableArray array];
    for (int j = 0; j < self.backDetailAry.count; j++) {
        AddSupplyModel * model = [[AddSupplyModel alloc ] init];
//        model.backImageStr = self.backImgAry[j];
        model.detailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.backImgAry[j]]]];
        model.detailStr = self.backDetailAry[j];
        [self.detailCellAry addObject:model];
    }
    [self.detailCellAry addObject:@""];
    [_baseTable reloadData];
}


- (void)configerDetailCellAry{
    self.detailCellAry = [NSMutableArray array];
    AddSupplyModel * model = [[AddSupplyModel alloc] init];
    [self.detailCellAry addObject:model];
    [self.detailCellAry addObject:@""];
    [self.detailCellAry addObject:@""];
}
- (void)setTypeString:(NSString *)typeString{
    if ([typeString isEqualToString:@"原料"]) {
//        _titleAry = @[@"产品大类:",@"产品名称:",@"所属类别:",@"产品分类:",@"产品规格:",@"数量:"];
//        self.keyAry = @[@"type",@"title",@"leibie",@"fenlei",@"guige",@"num"];
//        _cidAry = @[@"-1",@"-1",@"33",@"19",@"-1",@"-1"];
//        [self configerDetailCellAry];
        _titleAry = @[@"产品大类:",@"产品名称:",@"产品分类:",@"产品规格:",@"数量:"];
        self.keyAry = @[@"type",@"title",@"fenlei",@"guige",@"num"];
        _cidAry = @[@"-1",@"-1",@"33",@"-1",@"-1"];
        [self configerDetailCellAry];
    }else{
        _titleAry = @[@"产品大类:",@"产品名称:",@"原料成分:",@"支数:",@"数量:",@"价格:",@"产品分类:",@"乌斯特质量:"];
        self.keyAry = @[@"type",@"title",@"chengfen",@"zhisu",@"num",@"jiage",@"leibie",@"wstzl"];
        _cidAry = @[@"-1",@"-1",@"18",@"14",@"-1",@"-1",@"15",@"16"];
        [self configerDetailCellAry];
    }
    self.dataSourceAry = [NSMutableArray array];
    for (int i = 0; i < _titleAry.count; i++) {
        IssueModel * model = [[IssueModel alloc] init];
        model.leftTitle = _titleAry[i];
        if (i == 0) {
            model.contentStr = typeString;
        }
        [self.dataSourceAry addObject:model];
    }
//    [_baseTable reloadData];
}

/**
 *  配置TableView
 */
- (void)configerUITableView{
    self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStyleGrouped];
    _baseTable.delegate = self;
    _baseTable.dataSource =self;
    _baseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTable.bounces = NO;
    _baseTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.baseTable];
    
    self.headerView = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 165)];
    _headerView.delegate = self;
    self.baseTable.tableHeaderView = _headerView;
    
    [self registerUITableViewCell];
}
- (void)registerUITableViewCell{
    [self.baseTable registerClass:[IssueRequestTableViewCell class] forCellReuseIdentifier:indentifier2];
    [self.baseTable registerNib:[UINib nibWithNibName:@"AddSupplyTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier3];
    [self.baseTable registerNib:[UINib nibWithNibName:@"AddTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier4];
}
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.isAlter) {
            if (indexPath.row == self.detailCellAry.count - 1) {
                return 60;
            }else{
                return 200;
            }
        }else{
            if (indexPath.row == self.detailCellAry.count - 1) {
                return 45;
                //            return self.isAlter ? 0 : 45;
            }else if (indexPath.row == self.detailCellAry.count - 2){
                return 60;
            }else{
                return 200;
            }
        }
    }else{
        return 44;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSourceAry.count;
    }else{
        return self.detailCellAry.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    views.backgroundColor = RGBColor(231, 231, 231);
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kUIScreenWidth-40, 30)];
    lable.text = @"图文详请(选填项)";
    lable.textColor = RGBColor(85, 85, 8);
    lable.font = [UIFont systemFontOfSize:15];
    [views addSubview:lable];
    if (section == 0) {
        return nil;
    }else{
        return views;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IssueRequestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
        cell.model = self.dataSourceAry[indexPath.row];
        cell.contentField.tag = 4000 + indexPath.row;
        cell.contentField.delegate = self;
        if ([[self.dataSourceAry[0] contentStr] isEqualToString:@"纱线"] && indexPath.row == 3) {
            cell.contentField.userInteractionEnabled = NO;
        }else  if([[self.dataSourceAry[0] contentStr] isEqualToString:@"原料"] && indexPath.row == 3){
            cell.contentField.userInteractionEnabled = YES;
        }
        return cell;
    }else{

        if (self.isAlter) {
            static NSString * indentifier = @"cell";
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            }
            if (indexPath.row == self.detailCellAry.count - 1) {//加号的
                AddTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier4 forIndexPath:indexPath];
                [cell.addCellButton addTarget:self action:@selector(addCellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else{
                AddSupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier3 forIndexPath:indexPath];
                AddSupplyModel * alterModel = self.detailCellAry[indexPath.row];
                cell.alterModel = alterModel;
                cell.delegate = self;
                cell.selectButton.tag = KBtnTag(indexPath.row);
                return cell;
            }
        }else{
            static NSString * indentifier = @"cell";
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            }
            if (indexPath.row == self.detailCellAry.count - 2) {//加号的
                AddTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier4 forIndexPath:indexPath];
                [cell.addCellButton addTarget:self action:@selector(addCellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else if(indexPath.row == self.detailCellAry.count - 1){//最后一行，确认 提交审核
                UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(0, 0, kUIScreenWidth, cell.height);
                but.backgroundColor = RGBColor(30, 78, 145);
                [but setTitle:@"确认提交审核" forState:UIControlStateNormal];
                [but setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
                [but addTarget:self action:@selector(comfierButClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
                return cell;
            }else{//剩下的都是图文详细的
                AddSupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier3 forIndexPath:indexPath];
                cell.delegate = self;
                cell.selectButton.tag = KBtnTag(indexPath.row);
                AddSupplyModel * model = self.detailCellAry[indexPath.row];
                cell.model = model;
                return cell;
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.editingTextField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        IssueRequestTableViewCell *cell = (IssueRequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        IssueModel * model = self.dataSourceAry[indexPath.row];
        cell.contentField.tag = 4000 + indexPath.row;
        if ([[self.dataSourceAry[0] contentStr] isEqualToString:@"纱线"] && [cell.model.leftTitle isEqualToString:@"产品分类:"]) {
            model.isPush = YES;
        }else if ([[self.dataSourceAry[0] contentStr] isEqualToString:@"原料"] && [cell.model.leftTitle isEqualToString:@"产品分类:"]){
            model.isPush = YES;
        }
        
        if (model.isPromote){//多项选择原料成分的视图
            ComponentPartViewController * componentVC = [[ComponentPartViewController alloc] init];
            //再次进入选择时，把之前选择的展示出来
            componentVC.saveNameArray = self.savaNameAry;
            componentVC.savePrecentArray = self.savaPrecentAry;
            componentVC.cid = _cidAry[indexPath.row];
            
            //把弹窗里的数据传出来
            __weak typeof(self)mySelf = self;
            componentVC.myblock = ^(NSArray *nameArray, NSArray *percentArray){
                
                mySelf.savaNameAry = nameArray;
                mySelf.savaPrecentAry = percentArray;
                
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0; i < nameArray.count; i++) {
                    NSString *tempStr = [nameArray[i] stringByAppendingString:percentArray[i]];
                    [tempArray addObject:tempStr];
                }
                NSString *restultStr = [tempArray componentsJoinedByString:@"%;"];
                if (restultStr.length != 0) {
                    model.contentStr = [restultStr stringByAppendingString:@"%;"];
                }else{
                    model.contentStr = nil;
                }
                [mySelf.baseTable reloadData];
            };
            MZFormSheetController * fromSheet = [[MZFormSheetController alloc] initWithViewController:componentVC];
            fromSheet.shouldCenterVertically = YES;
            fromSheet.cornerRadius =0;
            fromSheet.shouldDismissOnBackgroundViewTap = YES;
            fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
            fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 20, kUIScreenHeight);
            [fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
                
            }];
        }else if (model.isDown){//不做弹出视图。做成下拉菜单 (Down)
            _menuTableView.cid = _cidAry[indexPath.row];
            _menuTableView.view.frame = CGRectMake(kUIScreenWidth/3, cell.frame.origin.y + 39, kUIScreenWidth*2/3 - 30, 100);
            if (self.showList) {
                [self.baseTable addSubview:_menuTableView.view];
                _menuTableView.delegate =self;
            }else{
                [_menuTableView.view removeFromSuperview];
            }
            self.showList = !self.showList;
            self.indexPath = indexPath;
        }else if (model.isPush){
//            SelectTypeViewController * selectTypeVC = [[SelectTypeViewController alloc] init];
//            if ([[self.dataSourceAry[0] contentStr] isEqualToString:@"原料"]) {
//                selectTypeVC.typeNum = @"33";
//            }else{
//                selectTypeVC.typeNum = @"15";
//            }
//            selectTypeVC.myblock = ^(NSString *typeStr) {
//                model.contentStr = typeStr;
//                [_baseTable reloadData];
//            };
//             [self.navigationController pushViewController:selectTypeVC animated:YES];
            [_menuTableView.view removeFromSuperview];
            self.showList = !self.showList;
            SelectProTypeTableViewController * selectTypeVC = [[SelectProTypeTableViewController alloc] init];
            if ([[self.dataSourceAry[0] contentStr] isEqualToString:@"原料"]) {
                selectTypeVC.typeNum = @"33";
            }else{
                selectTypeVC.typeNum = @"15";
            }
            selectTypeVC.myblock = ^(NSString *typeStr) {
                model.contentStr = typeStr;
                [_baseTable reloadData];
            };
//            [self.editingTextField resignFirstResponder];
            [self.navigationController pushViewController:selectTypeVC animated:YES];

        }else{
            //"empty"， “weight”
        }
    }
}
//正在编辑的输入框一旦出界就辞去键盘。不然等输入框出界后再点击键盘上的完成想要隐藏键盘，由于输入框这会是nil，所以会崩溃
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editingTextField) {
        [self.editingTextField resignFirstResponder];
    }
}
/**
 *  下拉框的列表
 */
- (void)configerDownMenu{
    self.menuTableView = [[DownTableViewController alloc] init];
    self.showList = YES;
}
/**
 *  点击加号按钮，增加一个图文详细
 */
- (void)addCellButtonClicked:(UIButton *)sender{
    if (self.detailCellAry.count > 6) {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能添加5项图文详细" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertView addAction:ensureAction];
        [self presentViewController:alertView animated:YES completion:nil];
        return;
    }
    AddSupplyModel * model = [[AddSupplyModel alloc] init];
    model.detailImage = nil;
    model.detailStr = nil;
    if (self.isAlter) {//是修改
        [self.detailCellAry insertObject:model atIndex:self.detailCellAry.count - 1];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.detailCellAry.count - 1 inSection:1];
        [_baseTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.detailCellAry insertObject:model atIndex:self.detailCellAry.count - 2];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.detailCellAry.count - 2 inSection:1];
        [_baseTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [_baseTable reloadData];
}


/**
 *  提交审核按钮
 */
- (void)comfierButClicked:(UIButton *)sender{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
    NSString * netPath = @"userinfo/pro_add";
    NSMutableDictionary * allParams  = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    for (int i = 0; i < self.dataSourceAry.count; i++) {
        IssueModel * model = self.dataSourceAry[i];
        if ([model.contentStr isEqualToString:@"纱线"]) {
            [allParams setObject:@"1" forKey:self.keyAry[i]];
        }else if ([model.contentStr isEqualToString:@"原料"]) {
            [allParams setObject:@"2" forKey:self.keyAry[i]];
        }else{
            if (model.contentStr.length == 0) {
                if ([model.leftTitle isEqualToString:@"原料成分:"] || [model.leftTitle isEqualToString:@"数量:"] || [model.leftTitle isEqualToString:@"价格:"] || [model.leftTitle isEqualToString:@"乌斯特质量:"]) {
                    
                }else{
                    [self showWaring:@"请确保必填项不为空"];
                    return;
                }
            }else{
            [allParams setObject:model.contentStr forKey:self.keyAry[i]];
            }
        }
    }
    NSMutableArray * detailTextAry = [NSMutableArray array];
    for (int j = 0; j < self.detailCellAry.count - 2; j++) {
        AddSupplyModel * model = self.detailCellAry[j];
        if (model.detailImage != nil && model.detailStr.length > 0) {
            [detailTextAry addObject:model.detailStr];
            [self.imgAry addObject:model.detailImage];
        }else if(model.detailImage == nil && model.detailStr.length == 0){
            //图文都没有
        }else{
            [self showWaring:@"请确保图文详细数量匹配"];
            return;
        }
    }
    for (int i = 0; i < detailTextAry.count; i++) {
        NSString * contentName =[NSString stringWithFormat:@"%@%zd",@"content",i+1];
        [allParams setObject:detailTextAry[i] forKey:contentName];
    }
    
    self.photoAry = [self getTopImage];

    [MBProgressHUD showMessage:@"正在上传..."];
    [HttpTool postWithPath:netPath indexNames:@[@"photo",@"img"] imagePathLists:@[self.photoAry, self.imgAry] params:allParams success:^(id responseObj) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [MBProgressHUD hideHUD];
        MyLog(@"*****添加供应成功%@", responseObj);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)showWaring:(NSString *)string{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}



/**
 *  点击下拉视图内的选项，通过代理显示到该页面上 DownTableViewControllerDelegate
 */
- (void)CellGetValue:(NSString *)value{
    //其他
    if ([value isEqualToString:@"其他"]) {
        [self showContentField];
        return;
    }
    
    IssueModel * model = self.dataSourceAry[self.indexPath.row];
    model.contentStr = value;
    if (self.showList) {
        [self.baseTable addSubview:_menuTableView.view];
    }else{
        [_menuTableView.view removeFromSuperview];
    }
    self.showList = !self.showList;
    if (self.indexPath.row == 0) {
        self.typeString = value;
    }
    [self.baseTable reloadData];
}
- (void)showContentField{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入自定义选项" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField * textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"请输入支数(最多输入5个字符)";
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        //        MyLog(@"%@", textField.text);
        NSString * string = [NSString string];
        if (textField.text.length > 5) {
            string = [textField.text substringToIndex:5];
        }else {
            string = textField.text;
        }
        [self CellGetValue:string];
    }
}
/**
 *
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingTextField = textField;//拿到正在编辑的输入框
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
}

/**
 *  保存输入框内输入的内容(非图文详细的)
 */
- (void)textFieldGetValue:(NSString *)value sender:(UITextField *)sender{
//    IssueRequestTableViewCell * cell = (IssueRequestTableViewCell *)sender.superview.superview.superview;
//    NSIndexPath * path = [self.baseTable indexPathForCell:cell];
//    IssueModel * model = self.dataSourceAry[path.row];
    if (sender != nil) {
        IssueModel * model = self.dataSourceAry[sender.tag - 4000];
        model.contentStr = value;
    }
}

/**
 *  点击图文详细中图片右上角的删除按钮，删除已选择的图片
 */
- (void)deletePic:(UIButton *)sender cells:(UITableViewCell *)cells{
//    AddSupplyTableViewCell * cell = (AddSupplyTableViewCell *)sender.superview.superview;
//    NSIndexPath * indexPath = [_baseTable indexPathForCell:cell];
    NSIndexPath * indexPath = [_baseTable indexPathForCell:cells];
    if (self.isAlter) {
        AddSupplyModel * alterModel = self.detailCellAry[indexPath.row];
        alterModel.backImageStr = nil;
        alterModel.detailImage = nil;
    }else{
        AddSupplyModel * model = self.detailCellAry[indexPath.row];
        model.detailImage = nil;
    }
    [_baseTable reloadData];
}
#pragma mark --AddSupplyTableViewCellDelegate
/**
 *  通过代理拿到图片  下边的
 */
- (void)getImage:(UIButton *)sender{
    [self cameraBtnClicked:nil canCamera:NO];
    self.tagRow = sender.tag - 3000;
    self.isDetail = YES;
}

/**
 *  通过代理拿到输入的文字（图文详细的）
 */
- (void)getValueFromTextView:(MyTextView *)sender cells:(UITableViewCell *)cells{
//    AddSupplyTableViewCell * cell = (AddSupplyTableViewCell *)sender.superview.superview;
//    NSIndexPath * indexPath = [_baseTable indexPathForCell:cell];
     NSIndexPath * indexPath = [_baseTable indexPathForCell:cells];
    AddSupplyModel * model = self.detailCellAry[indexPath.row];
    model.detailStr = sender.text;
}
#pragma mark --- 表头视图的代理TableHeaderViewDelegate
/**
 *  点击图片右上角删除按钮的代理   !!上边的
 */
- (void)deleteBut:(UIImageView *)sender{//主要是修改的时候用

}
- (void)cameraBtnClicked:(TableHeaderView *)headerView canCamera:(BOOL)isCan
{
    if (isCan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片路径" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [actionSheet showInView:self.view];
    }else{
        [self selectPicFromPhotos];
    }
}
- (void)selectPicFromPhotos{
    [self.editingTextField resignFirstResponder];
    //调用相册选择图片
    self.picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //选择模式
    _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//动画
    _picker.delegate = self;
    //弹出相册
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持拍照,是否调用相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //调用相册选择图片
    self.picker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.delegate = self;
            _picker.allowsEditing = YES;
            [self presentViewController:_picker animated:YES completion:nil];
            return;
        } else {
            [alertView show];
            return;
        }
        return;
    }else if(buttonIndex == 1){
        [self selectPicFromPhotos];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!self.isDetail) {//不是图文详细的
        if ([self.headerView.picImageView1.subviews firstObject].hidden == YES) {
            self.headerView.picImageView1.image = image;
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
        }else if ([self.headerView.picImageView2.subviews firstObject].hidden == YES){
            self.headerView.picImageView2.image = image;
            [self.headerView.picImageView2.subviews firstObject].hidden = NO;
        }else if ([self.headerView.picImageView3.subviews firstObject].hidden == YES){
            self.headerView.picImageView3.image = image;
            [self.headerView.picImageView3.subviews firstObject].hidden = NO;
        }else if ([self.headerView.picImageView4.subviews firstObject].hidden == YES){
            self.headerView.picImageView4.image = image;
            [self.headerView.picImageView4.subviews firstObject].hidden = NO;
        }
        self.headerView.count += 1;
        if (self.headerView.count >= 4) {
            self.headerView.cameraBut.userInteractionEnabled = NO;
        }
    }else{//是图文详细的
        if (self.isAlter) {
            AddSupplyModel * alterModel = self.detailCellAry[self.tagRow];
            alterModel.detailImage = image;
            self.isDetail = NO;
        }else{
            AddSupplyModel * model = self.detailCellAry[self.tagRow];
            model.detailImage = image;
            self.isDetail = NO;
        }
        [_baseTable reloadData];
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)getTopImage{
    NSMutableArray * phoAry = [@[]mutableCopy];
    if (![self.headerView.picImageView1.image isEqual:[UIImage imageNamed:@"Request_pic2"]]) {
        [phoAry addObject:self.headerView.picImageView1.image];
    }
    if (![self.headerView.picImageView2.image isEqual:[UIImage imageNamed:@"Request_pic2"]]){
        [phoAry addObject:self.headerView.picImageView2.image];
    }
    if (![self.headerView.picImageView3.image isEqual:[UIImage imageNamed:@"Request_pic2"]]){
        [phoAry addObject:self.headerView.picImageView3.image];
    }
    if (![self.headerView.picImageView4.image isEqual:[UIImage imageNamed:@"Request_pic2"]]){
        [phoAry addObject:self.headerView.picImageView4.image];
    }
    return phoAry;
}
/**
 *  拿到上边的图片，并且不是服务器返回的
 */
- (NSArray *)getImage{
    NSMutableArray * ary = [NSMutableArray array];
    if (![self.headerView.picImageView1.image isEqual:[UIImage imageNamed:@"Request_pic2"]]) {//只要是上传图片了，tag值就会增加
        [ary addObject:self.headerView.picImageView2.image];
    }
    if (![self.headerView.picImageView2.image isEqual:[UIImage imageNamed:@"Request_pic2"]]){
        [ary addObject:self.headerView.picImageView2.image];
    }
    if (![self.headerView.picImageView3.image isEqual:[UIImage imageNamed:@"Request_pic2"]]){
        [ary addObject:self.headerView.picImageView3.image];
    }
    if (![self.headerView.picImageView4.image isEqual:[UIImage imageNamed:@"Request_pic2"]]){
        [ary addObject:self.headerView.picImageView4.image];
    }
    NSArray * array = [NSArray arrayWithArray:ary];
    return array;
}

/**
 *  重写这个方法，在给这个属性赋值的时候，把图片加载出来
 */
- (void)setBackPhotoAry:(NSMutableArray *)backPhotoAry{
    _backPhotoAry= backPhotoAry;
    if (_backPhotoAry.count != 0) {
        if (_backPhotoAry.count == 1) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
        }
        if (_backPhotoAry.count == 2) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
            [self.headerView.picImageView2 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[1]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView2.subviews firstObject].hidden = NO;
        }
        if (_backPhotoAry.count == 3) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
            [self.headerView.picImageView2 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[1]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView2.subviews firstObject].hidden = NO;
            [self.headerView.picImageView3 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[2]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView3.subviews firstObject].hidden = NO;
        }
        if (_backPhotoAry.count == 4) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
            [self.headerView.picImageView2 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[1]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView2.subviews firstObject].hidden = NO;
            [self.headerView.picImageView3 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[2]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView3.subviews firstObject].hidden = NO;
            [self.headerView.picImageView4 sd_setImageWithURL:[NSURL URLWithString:_backPhotoAry[3]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView4.subviews firstObject].hidden = NO;
        }
    }
}
/**
 *  修改的保存按钮
 */
- (void)rightBarButtonClicked{
    
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
    NSString * netPath = @"userinfo/my_pro_edit";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.proid forKey:@"proid"];

    NSMutableArray * detailTextAry = [NSMutableArray array];//新添加的详细文字
    NSMutableArray * detailImageAry = [NSMutableArray array];//新添加的详细图片
    for (int j = 0; j < self.detailCellAry.count - 1; j++) {
        AddSupplyModel * alterModel = self.detailCellAry[j];
//        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:j inSection:1];
//        AddSupplyTableViewCell * cell = [_baseTable cellForRowAtIndexPath:indexpath];
//        if (cell.selectButton.hidden) {
//            alterModel.detailImage = cell.detailImageView.image;
//        }else{
//            alterModel.detailImage = nil;
//        }
        if (alterModel.detailImage && alterModel.detailImage != [UIImage imageNamed:@"Me_addSupply"] && alterModel.detailStr.length > 0) {
            [detailTextAry addObject:alterModel.detailStr];
            [detailImageAry addObject:alterModel.detailImage];
        }else if (alterModel.detailImage == nil && alterModel.detailStr.length == 0){
        }else{
            //提示错误。应该输入的图片和文字数量一致。要么都有，要么都没有
            [self showWaring:@"请确保图文详细数量匹配"];
            return;
        }
    }
    for (int i = 0; i < detailTextAry.count; i++) {//图文详细的文字 新的
        NSString * contentName =[NSString stringWithFormat:@"%@%zd",@"content",i+1];
        [allParams setObject:detailTextAry[i] forKey:contentName];
    }
    
    for (int i = 0; i < self.dataSourceAry.count; i++) {//上边的信息
        IssueModel * model = self.dataSourceAry[i];
        if ([model.contentStr isEqualToString:@"纱线"] && i == 0) {
            [allParams setObject:@"1" forKey:self.keyAry[i]];
        }else if ([model.contentStr isEqualToString:@"原料"] && i == 0) {
            [allParams setObject:@"2" forKey:self.keyAry[i]];
        }else{
            if (model.contentStr.length == 0) {
                if ([model.leftTitle isEqualToString:@"产品大类:"] ||[model.leftTitle isEqualToString:@"产品名称:"] ||[model.leftTitle isEqualToString:@"支数:"] ||[model.leftTitle isEqualToString:@"所属类别:"] ||[model.leftTitle isEqualToString:@"产品分类:"] ||[model.leftTitle isEqualToString:@"产品规格:"] ) {
                    [self showWaring:@"请确保必填项不为空"];
                    return;
                }
            }else{
                [allParams setObject:model.contentStr forKey:self.keyAry[i]];
            }
        }
    }
    
     NSArray * ary = [self getImage];//新上传的图2片(上边的)
    [MBProgressHUD showMessage:@"正在保存..."];
    [HttpTool postWithPath:netPath indexNames:@[@"photo",@"img"] imagePathLists:@[ary, detailImageAry] params:allParams success:^(id responseObj) {
        MyLog(@"修改供应成功%@", responseObj);
        [MBProgressHUD hideHUD];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        MyLog(@"修改供应失败%@", error);
    }];
    
}

@end
