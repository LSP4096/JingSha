//
//  IssueRequestViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/18.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "IssueRequestViewController.h"
#import "TableHeaderView.h"
#import "LeaveDetailMessageTableViewCell.h"
#import "IssueRequestTableViewCell.h"
#import <MZFormSheetController.h>
#import "ConfirmRequestViewController.h"
#import "ComponentPartViewController.h"
#import "DownTableViewController.h"
#import "IssueModel.h"

//#import "SelectTypeViewController.h"
#import "SelectProTypeTableViewController.h"
@interface IssueRequestViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,TableHeaderViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, DownTableViewControllerDelegate, UITextFieldDelegate, IssueRequestTableViewCellDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)UITableView * baseTable;
@property (nonatomic, strong)DownTableViewController * menuTableView;
@property (nonatomic, assign)CGFloat ContentY;
@property (nonatomic, assign)BOOL showList;
@property (nonatomic, strong)NSArray * titleAry;
@property (nonatomic, strong)LeaveDetailMessageTableViewCell * cell;
@property (nonatomic, strong)UIImagePickerController * picker;
@property (nonatomic, strong)TableHeaderView * headerView;
@property (nonatomic, strong)NSArray * cidAry;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSArray * keyAry;
@property (nonatomic, strong)NSMutableArray * dataSourceAry;
@property (nonatomic, strong)NSMutableDictionary * messageDict;
@property (nonatomic, strong)NSArray * imageArray;
@property (nonatomic, strong)UITextField * editingTextField;
@property (nonatomic, copy)NSString * type;
//
@property (nonatomic, strong)NSMutableArray * photoAry;
@property (nonatomic, assign)BOOL isHidden;
@property (nonatomic, strong)UIView * uintView;
@property (nonatomic, copy)NSString * uintString;//单位

//
@property (nonatomic, strong)NSArray * savaNameAry;
@property (nonatomic, strong)NSArray * savaPrecentAry;
@end

static NSString * indentifier1 = @"leaveMessageCell_2";
static NSString * indentifier2 = @"issueCell";
@implementation IssueRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageDict = [NSMutableDictionary dictionary];
    self.imageArray = [NSArray array];
    self.photoAry =  [NSMutableArray array];
    if (self.isAlter) {
        self.title = @"修改求购";
    }else{
        self.title = @"发布求购";
    }
    [self setTypeString:@"纱线"];//先主动调一次（默认显示的）
    self.type = @"1";
    self.uintString = @"吨";
    [self configerUITableView];
    [self configerDownMenu];
    //这个界面可以用来发布求购，还可以修改，所以可能要请求数据
    if (self.bid) {//这个bid是从求购详细传过来的，要是有，就说明是修改的，要请求数据
        NSString * netPath = @"userinfo/my_buy_info";
        NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
        [allParams setObject:self.bid forKey:@"bid"];
        [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
//            MyLog(@"====%@", responseObj);
            [self getDataFromResponseObj:responseObj];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)getDataFromResponseObj:(id)responseObj{
    self.dataSourceAry = [NSMutableArray array];
    NSDictionary * dataDict = responseObj[@"data"];
    if (![dataDict[@"photo"] isKindOfClass:[NSNull class]]) {
        
        self.photoAry = [dataDict[@"photo"] mutableCopy];//最下边有方法
    }
    if ([dataDict[@"type"] isEqualToString:@"1"]) {//纱线
        self.keyAry = @[@"type",@"title",@"chengfen",@"zhisu",@"num",@"jiage",@"fenlei",@"wstzl",@"jiaohuoqi",@"youxian", @"jianjie"];//11
        _titleAry = @[@"产品大类:",@"产品名称:",@"原料成分:",@"支数:",@"数量:",@"意向价格:",@"产品分类:",@"乌斯特质量:",@"交货期:",@"有效期:"];//10
    }else if ([dataDict[@"type"] isEqualToString:@"2"]){//原料
        self.keyAry = @[@"type",@"title",@"fenlei",@"guige",@"num",@"jiaohuoqi",@"youxian", @"jianjie"];//9
        _titleAry = @[@"产品大类:",@"产品名称:",@"产品分类:",@"产品规格:",@"数量:",@"交货期:",@"有效期:"];//8
    }
    
    for (int i = 0; i < self.titleAry.count; i++) {
        IssueModel * model = [[IssueModel alloc] init];
        if (i == 0) {
            if ([dataDict[self.keyAry[i]] isEqualToString:@"1"]) {
                model.contentStr = @"纱线";
                self.type = @"1";
            }else if ([dataDict[self.keyAry[i]] isEqualToString:@"2"]){
                model.contentStr = @"原料";
                self.type = @"2";
            }
        }else{
            if ([self.keyAry[i] isEqualToString:@"num"] && ![dataDict[self.keyAry[i]] isKindOfClass:[NSNull class]] && [dataDict[self.keyAry[i]] length] > 0 && dataDict[self.keyAry[i]] != nil) {
                NSMutableString * string = [dataDict[self.keyAry[i]] mutableCopy];
                if ([string rangeOfString:@"吨"].location != NSNotFound) {
                    model.contentStr = [[string componentsSeparatedByString:@"吨"] firstObject];
                }else if ([string rangeOfString:@"公斤"].location != NSNotFound){
                  model.contentStr = [[string componentsSeparatedByString:@"公斤"] firstObject];
                }
            }else{
                model.contentStr = dataDict[self.keyAry[i]];
            }
        }
        model.leftTitle = _titleAry[i];
        [self.dataSourceAry addObject:model];
    }
    if (![dataDict[@"jianjie"] isKindOfClass:[NSNull class]] && [dataDict[@"jianjie"] length] > 0) {
        [self.messageDict setObject:dataDict[@"jianjie"] forKey:@"detailMessage"];
    }
    
    [_baseTable reloadData];
}


#pragma mark ---
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
    //注册cell
    [self.baseTable registerNib:[UINib nibWithNibName:@"LeaveDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier1];
    [self.baseTable registerClass:[IssueRequestTableViewCell class] forCellReuseIdentifier:indentifier2];
}

- (void)setTypeString:(NSString *)typeString{
    if ([typeString isEqualToString:@"原料"]) {
        _titleAry = @[@"产品大类:",@"产品名称:",@"产品分类:",@"产品规格:",@"数量:",@"交货期:",@"有效期:"];
        self.keyAry = @[@"type",@"title",@"fenlei",@"guige",@"num",@"jiaohuoqi",@"youxian", @"jianjie"];
//        _cidAry = @[@"-1",@"8",@"19",@"8",@"8",@"8",@"17"];
        _cidAry = @[@"-1",@"8",@"15",@"8",@"8",@"8",@"17"];
    }else{
        _titleAry = @[@"产品大类:",@"产品名称:",@"原料成分:",@"支数:",@"数量:",@"意向价格:",@"产品分类:",@"乌斯特质量:",@"交货期:",@"有效期:"];
        self.keyAry = @[@"type",@"title",@"chengfen",@"zhisu",@"num",@"jiage",@"fenlei",@"wstzl",@"jiaohuoqi",@"youxian", @"jianjie"];
//        _cidAry = @[@"-1",@"8",@"18",@"14",@"8",@"8",@"19",@"16",@"8",@"17"];
        _cidAry = @[@"-1",@"8",@"18",@"14",@"8",@"8",@"33",@"16",@"8",@"17"];
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
}

#pragma  mark --- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _titleAry.count;
    }
    else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 140;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        return 70;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 40;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 90, 20)];
    label.text = @"详细要求:";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGBColor(89, 89, 89);
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IssueRequestTableViewCell *cell = [[IssueRequestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:indentifier2];
        cell.isRequest = YES;
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        cell.model = self.dataSourceAry[indexPath.row];
        cell.contentField.delegate = self;
        cell.rightButton.tag = 4000 + indexPath.row;
        if (indexPath.row == 4) {//正好都是第四个
            cell.delegate = self;
        }
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            self.cell = [tableView dequeueReusableCellWithIdentifier:indentifier1 forIndexPath:indexPath];
            _cell.textView.delegate =self;
            _cell.textView.text = self.messageDict[@"detailMessage"];
            _cell.backgroundColor = RGBColor(236, 236, 236);
            NSInteger count = _cell.textView.text.length;
            _cell.countLable.text = [NSString stringWithFormat:@"%ld/200", count];
            return _cell;
        }else{
            static NSString * indentifier = @"cells";
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, 10, kUIScreenWidth - 40, 50);
            [cell addSubview:button];
            button.backgroundColor = RGBColor(20, 83, 177);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            if (self.isAlter) {
                [button setTitle:@"提交" forState:UIControlStateNormal];
            }else{
                [button setTitle:@"下一步" forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor = RGBColor(236, 236, 236);
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.editingTextField resignFirstResponder];
    if (indexPath.section == 0) {
        IssueModel * model = self.dataSourceAry[indexPath.row];
        IssueRequestTableViewCell *cell = (IssueRequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([[self.dataSourceAry[0] contentStr] isEqualToString:@"纱线"] && [cell.model.leftTitle isEqualToString:@"产品分类:"]) {//纱线
            cell.model.isDown = NO;
            cell.model.isPush = YES;
        }else if([[self.dataSourceAry[0] contentStr] isEqualToString:@"原料"] && [cell.model.leftTitle isEqualToString:@"产品分类:"]){
            cell.model.isDown = NO;
            cell.model.isPush = YES;
        }
        if (model.isPromote) {//弹窗
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
                [_baseTable reloadData];
            };
            MZFormSheetController * fromSheet = [[MZFormSheetController alloc] initWithViewController:componentVC];
            fromSheet.shouldCenterVertically = YES;
            fromSheet.cornerRadius =0;
            fromSheet.shouldDismissOnBackgroundViewTap = YES;
            fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
            fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 20, kUIScreenHeight);
            [fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
            }];
            
        }else if (model.isDown){
            //不做弹出视图。做成下拉菜单 (Down)
            _menuTableView.cid = _cidAry[indexPath.row];
            _menuTableView.view.frame = CGRectMake(kUIScreenWidth/3, cell.frame.origin.y + 39, kUIScreenWidth*2/3 - 30, 100);
            if (self.showList) {
                [self.baseTable addSubview:_menuTableView.view];
                _menuTableView.delegate =self;
            }else{
                [_menuTableView.view removeFromSuperview];
            }
            self.showList = !self.showList;
            self.index = indexPath.row;
        }else if (model.isPush){
            MyLog(@"push");
//            SelectTypeViewController * selectTypeVC = [[SelectTypeViewController alloc] init];
//            selectTypeVC.myblock = ^(NSString *typeStr) {
//                model.contentStr = typeStr;
////                [_baseTable reloadData];
//                [_baseTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            };
//            selectTypeVC.typeNum = _cidAry[indexPath.row];
//            [self.navigationController pushViewController:selectTypeVC animated:YES];
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
            [self.navigationController pushViewController:selectTypeVC animated:YES];
        }else{
            //"empty"， “weight”
            cell.contentField.delegate = self;
      }
    }else{//2区。详细cell
        
    }
}
//正在编辑的输入框一旦出界就辞去键盘。不然等输入框出界后再点击键盘上的完成想要隐藏键盘，由于输入框这会是nil，所以会崩溃
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editingTextField) {
        [self.editingTextField resignFirstResponder];
    }
}
#pragma  mark -- IssueRequestTableViewCellDelegate
- (void)showUnitView:(UIButton *)sender{
//    IssueRequestTableViewCell * cell = (IssueRequestTableViewCell *)sender.superview.superview.superview;
    NSIndexPath * indexpath = [NSIndexPath indexPathForItem:sender.tag - 4000 inSection:0];
    IssueRequestTableViewCell * cell = [_baseTable cellForRowAtIndexPath:indexpath];
    
    if (_uintView == nil) {
        self.uintView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth - 70, cell.y + 42, 50, 50)];
        
        _uintView.backgroundColor = RGBColor(236, 236, 236);
        [_baseTable addSubview:_uintView];
        //
        NSArray  *titleAry = @[@"吨", @"公斤"];
        for (int i  = 0; i  < 2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titleAry[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, i * 25, 50, 25);
            button.tag = 3000 + i;
            [button setTitleColor:RGBColor(135, 135, 135) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.backgroundColor = RGBColor(236, 236, 236);
            [button addTarget:self action:@selector(optionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_uintView addSubview:button];
        }
    }
    if (self.isHidden) {
        _uintView.hidden = YES;
    }else{
        _uintView.hidden = NO;
    }
    self.isHidden = !self.isHidden;
    [_baseTable reloadData];
}
- (void)optionBtnClicked:(UIButton *)sender{
    NSArray  *titleAry = @[@"吨", @"公斤"];
    NSIndexPath * indexpath = [NSIndexPath indexPathForItem:4 inSection:0];
    IssueRequestTableViewCell * cell = [_baseTable cellForRowAtIndexPath:indexpath];
    [cell.rightButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    _uintView.hidden = YES;
    self.isHidden = !self.isHidden;
    if (sender.tag == 3001) {
        cell.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    self.uintString = titleAry[sender.tag - 3000];
}
/**
 *  下拉框的列表
 */
- (void)configerDownMenu{
    self.menuTableView = [[DownTableViewController alloc] init];
    self.showList = YES;
}
/**
 *  点击下拉视图内的选项，通过代理显示到该页面上
 */
- (void)CellGetValue:(NSString *)value{
    //其他
    if ([value isEqualToString:@"其他"]) {
        [self showContentField];
        return;
    }
    IssueModel * model = self.dataSourceAry[self.index];
    model.contentStr = value;
    if (self.showList) {
        [self.baseTable addSubview:_menuTableView.view];
    }else{
        [_menuTableView.view removeFromSuperview];
    }
    self.showList = !self.showList;
    if (self.index == 0) {
        self.typeString = value;
        
        if ([value isEqualToString:@"纱线"] ) {
            self.type = @"1";
        }else if ([value isEqualToString:@"原料"]){
            self.type = @"2";
        }
        MyLog(@"____%@", self.type);
    }
    [self.baseTable reloadData];
}

- (void)showContentField{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入自定义选项" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField * textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"请输入支数(最多输入7个字符)";
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
//        MyLog(@"%@", textField.text);
        NSString * string = [NSString string];
        if (textField.text.length > 7) {
            string = [textField.text substringToIndex:7];
        }else {
            string = textField.text;
        }
        [self CellGetValue:string];
    }
}

#pragma mark --- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldGetValue:textField.text sender:textField];
}

- (void)textFieldGetValue:(NSString *)value sender:(UITextField *)sender{
    IssueRequestTableViewCell * cell = (IssueRequestTableViewCell *)sender.superview.superview.superview;
    NSIndexPath * path = [self.baseTable indexPathForCell:cell];
    IssueModel * model = self.dataSourceAry[path.row];
    if (path.row != 0) {//由于在点击下一步时会调用这个方法，所以为了防止特殊情况，加这个判断
       model.contentStr = value;
    }
}
#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
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
        [self.messageDict setObject:_cell.textView.text forKey:@"detailMessage"];
    
}

/**
 *  下一步按钮，push到确认求购页面
 */
- (void)buttonClicked{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
    ConfirmRequestViewController * confimVC = [[ConfirmRequestViewController alloc] init];
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    confimVC.dict = allParams;
    
    for (int j = 0; j < _titleAry.count; j++) {
        IssueModel * model = self.dataSourceAry[j];
        
        if ([model.contentStr isKindOfClass:[NSNull class]] || model.contentStr == nil || [model.contentStr isEqualToString: @""]) {
            if ([model.leftTitle isEqualToString:@"产品大类:"] || [model.leftTitle isEqualToString:@"产品名称:"]||[model.leftTitle isEqualToString:@"支数:"]||[model.leftTitle isEqualToString:@"产品分类:"]||[model.leftTitle isEqualToString:@"有效期:"] || [model.leftTitle isEqualToString:@"产品规格:"]) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确保必填项不为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }else{
                [allParams setObject:@"" forKey:_keyAry[j]];
            }
        }else{
            if (j == 0) {
                [allParams setObject:self.type forKey:@"type"];
            }else{
                if (model.contentStr.length != 0) {
                    if (j == 4) {//带单位的
                        NSString * string = [NSString stringWithFormat:@"%@%@", model.contentStr, self.uintString];
                        [allParams setObject:string forKey:_keyAry[j]];
                    }else{
                        [allParams setObject:model.contentStr forKey:_keyAry[j]];
                    }
                }
            }
        }
    }
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    if (![self.messageDict[@"detailMessage"] length] == 0) {
        [allParams setObject:self.messageDict[@"detailMessage"] forKey:@"jianjie"];
    }else{
        [allParams setObject:@"" forKey:@"jianjie"];
    }
    if (self.bid) {//这个要是有值，就是修改。需要用到下边的参数
        [MBProgressHUD showMessage:@"正在提交..."];
        [allParams setObject:self.bid forKey:@"bid"];
    }else{
        //没有值，是发布
    }
    confimVC.imageAry = [self getImage];//新上传的
    
    if (self.isAlter) {
        NSString * netPath = @"userinfo/my_buy_edit";
            [HttpTool postWithPath:netPath indexName:@"photo" imagePathList:confimVC.imageAry params:allParams success:^(id responseObj) {
                MyLog(@"修改成功之后的返回%@", responseObj);
                [MBProgressHUD hideHUD];
                [SVProgressHUD showSuccessWithStatus:@"修改求购成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                MyLog(@"修改失败%@", error);
            }];
    }else{
        [self.navigationController pushViewController:confimVC animated:YES];
    }
}


#pragma mark --- 表头视图的代理
- (void)cameraBtnClicked:(TableHeaderView *)headerView canCamera:(BOOL)isCan
{
    if (isCan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片路径" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [actionSheet showInView:self.view];
    }else{
        [self selectPicFromPhotos];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持拍照,是否调用相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //调用相册选择图片
            self.picker = [[UIImagePickerController alloc] init];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([self.headerView.picImageView1.subviews firstObject].hidden == YES) {
        self.headerView.picImageView1.image = image;
//        self.headerView.picImageView1.tag += 300;
        [self.headerView.picImageView1.subviews firstObject].hidden = NO;
    }else if ([self.headerView.picImageView2.subviews firstObject].hidden == YES){
        self.headerView.picImageView2.image = image;
        [self.headerView.picImageView2.subviews firstObject].hidden = NO;
    }else if ([self.headerView.picImageView3.subviews firstObject].hidden == YES){
        self.headerView.picImageView3.image = image;
        [self.headerView.picImageView3.subviews firstObject].hidden = NO;
    }else if ([self.headerView.picImageView4.subviews firstObject].hidden == YES){
        self.headerView.picImageView4.image = image;
//        self.headerView.picImageView4.tag += 300;
        [self.headerView.picImageView4.subviews firstObject].hidden = NO;
    }
    self.headerView.count += 1;
    if (self.headerView.count >= 4) {
        self.headerView.cameraBut.userInteractionEnabled = NO;
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)getImage{
    NSMutableArray * ary = [NSMutableArray array];
    if (![self.headerView.picImageView1.image isEqual:[UIImage imageNamed:@"Request_pic2"]]) {
        [ary addObject:self.headerView.picImageView1.image];
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
 *  修改求购时加载图片
 */
- (void)setPhotoAry:(NSMutableArray *)photoAry{
    _photoAry = photoAry;
    if (_photoAry.count != 0) {
        if (_photoAry.count == 1) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_photoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
        }
        if (_photoAry.count == 2) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_photoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
            [self.headerView.picImageView2 sd_setImageWithURL:[NSURL URLWithString:_photoAry[1]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView2.subviews firstObject].hidden = NO;
        }
        if (_photoAry.count == 3) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_photoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
            [self.headerView.picImageView2 sd_setImageWithURL:[NSURL URLWithString:_photoAry[1]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView2.subviews firstObject].hidden = NO;
            [self.headerView.picImageView3 sd_setImageWithURL:[NSURL URLWithString:_photoAry[2]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView3.subviews firstObject].hidden = NO;
        }
        if (_photoAry.count == 4) {
            [self.headerView.picImageView1 sd_setImageWithURL:[NSURL URLWithString:_photoAry[0]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView1.subviews firstObject].hidden = NO;
            [self.headerView.picImageView2 sd_setImageWithURL:[NSURL URLWithString:_photoAry[1]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView2.subviews firstObject].hidden = NO;
            [self.headerView.picImageView3 sd_setImageWithURL:[NSURL URLWithString:_photoAry[2]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView3.subviews firstObject].hidden = NO;
            [self.headerView.picImageView4 sd_setImageWithURL:[NSURL URLWithString:_photoAry[3]] placeholderImage:[UIImage imageNamed:@"Request_pic2"] completed:nil];
            [self.headerView.picImageView4.subviews firstObject].hidden = NO;
        }
    }
}
/**
 *  点击图片右上角删除按钮的代理
 */
- (void)deleteBut:(UIImageView *)sender{
//    NSInteger Tag = sender.tag - 4000;
//    if (self.bid) {//这个存在说明是修改的
//        MyLog( @"^^^%@", self.photoAry);
//        [self.photoAry removeObjectAtIndex:Tag];
//    }
}

@end
