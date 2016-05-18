//
//  AlterCompanyMassageViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AlterCompanyMassageViewController.h"
#import "IssueRequestTableViewCell.h"
#import "LeaveDetailMessageTableViewCell.h"
#import <MZFormSheetController.h>
#import "ProductPromptViewController.h"
#import "IssueModel.h"
#import "UpLoadView.h"
#import <MZFormSheetController.h>
#import "CheckImageViewController.h"
#import "DownTableViewController.h"
@interface AlterCompanyMassageViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, DownTableViewControllerDelegate>
@property(nonatomic, strong)UITableView * baseTableView;
@property (nonatomic,strong)LeaveDetailMessageTableViewCell *cell;
@property (nonatomic ,strong)NSMutableArray * dataAry;
@property (nonatomic ,strong)NSMutableArray * keyAry;
@property (nonatomic, strong)NSMutableArray  * titleAry;
@property (nonatomic, strong)UITextField * editingTextField;

@property (nonatomic, strong)UIImagePickerController * picker;
@property (nonatomic, strong)UIImage * image;
@property (nonatomic, copy)NSString * imageUrl;
@property (nonatomic, strong)UpLoadView * topView;

@property (nonatomic, copy)NSString * wan;

@property (nonatomic, strong)DownTableViewController * menuTableView;
@property (nonatomic, assign)BOOL showList;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy)NSString * valued;

@property (nonatomic, copy)NSString * ncgl;
@end


static NSString * indentifier = @"issueCell";
static NSString * indentifier2 = @"leaveMessageCell_2";
@implementation AlterCompanyMassageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(236, 236, 236);
    self.title = @"企业介绍";
    self.valued = @"纱线生产企业";
    [self configerData];
    [self configerRightTopBut];
    [self configerTableView];
    [self configerDownMenu];
}

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
    self.wan = responseObj[@"data"][@"wan"];
    self.ncgl = responseObj[@"data"][@"ncgl"];
    [self setTitleeeAry:responseObj[@"data"][@"qyfl"]];
    NSDictionary * dict = responseObj[@"data"];
    self.imageUrl = dict[@"logo"];
    self.dataAry = [NSMutableArray array];

    for (int i = 0; i < _titleAry.count; i++) {
        IssueModel * model = [[IssueModel alloc] init];
        model.leftTitle = _titleAry[i];
        model.contentStr = dict[_keyAry[i]];
        
        if (i == 5 && [responseObj[@"data"][@"qyfl"] isKindOfClass:[NSNull class]]) {
            model.contentStr = @"纱线生产企业";
        }
        [self.dataAry addObject:model];
    }
    
    if (self.imageUrl) {
        [_topView.button1 setTitle:@"查看图片" forState:UIControlStateNormal];
    }else{
        [_topView.button1 setTitle:@"上传图片" forState:UIControlStateNormal];
    }
    [self.baseTableView reloadData];
}

- (void)setTitleeeAry:(NSString *)string{
    if (![string isKindOfClass:[NSNull class]]) {
        if ([string isEqualToString:@"纱线采购企业"]) {
            self.titleAry = [NSMutableArray arrayWithObjects:@"企业名称:",@"注册地:",@"注册资本:",@"法人代表:",@"企业规模:",@"企业分类:",@"主要采购纱线:",@"年采购量:",@"企业网址:", @"企业简介:",nil];//10
            self.keyAry = [NSMutableArray arrayWithObjects:@"gongsi",@"zcd",@"zczb",@"frdb",@"qygm",@"qyfl",@"zycp",@"ncgl",@"qywz",@"qyjj", nil];
        }else{
            self.titleAry = [NSMutableArray arrayWithObjects:@"企业名称:",@"注册地:",@"注册资本:",@"法人代表:",@"企业规模:",@"企业分类:",@"主营产品:",@"企业网址:", @"企业简介:",nil];//9
            self.keyAry = [NSMutableArray arrayWithObjects:@"gongsi",@"zcd",@"zczb",@"frdb",@"qygm",@"qyfl",@"zycp",@"qywz",@"qyjj", nil];
        }
    }else{
        self.titleAry = [NSMutableArray arrayWithObjects:@"企业名称:",@"注册地:",@"注册资本:",@"法人代表:",@"企业规模:",@"企业分类:",@"主营产品:",@"企业网址:", @"企业简介:",nil];//9
        self.keyAry = [NSMutableArray arrayWithObjects:@"gongsi",@"zcd",@"zczb",@"frdb",@"qygm",@"qyfl",@"zycp",@"qywz",@"qyjj", nil];
    }
}

/**
 *  配置右上角按钮
 */
- (void)configerRightTopBut{
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 0, 40, 30);
        [but setTitle:@"保存" forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        [but addTarget:self action:@selector(saveButClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:but];
}
- (void)configerTableView{
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStylePlain];
    _baseTableView.delegate = self;
    _baseTableView.dataSource =self;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.bounces = NO;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = RGBColor(236, 236, 236);
    [self.view addSubview:_baseTableView];
    
    self.topView = [[UpLoadView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 50)];
    self.baseTableView.tableHeaderView = _topView;

    [_topView.button2 addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    [_topView.button1 addTarget:self action:@selector(checkImage:) forControlEvents:UIControlEventTouchUpInside];//中间的
    
    //注册cell
    [_baseTableView registerClass:[IssueRequestTableViewCell class] forCellReuseIdentifier:indentifier];
    [_baseTableView registerNib:[UINib nibWithNibName:@"LeaveDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier2];
}
#pragma mark --UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataAry.count == 10) {
        return 10;
    }else{
        return 9;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataAry.count == 10) {
        if (section == 9) {
            return 30;
        }else{
            return 6;
        }
    }else{
        if (section == 8) {
            return 30;
        }else{
            return 6;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 10) {
        if (indexPath.section == 9) {
            return 160;
        }else{
            return 44;
        }
    }else{
        if (indexPath.section == 8) {
            return 160;
        }else{
            return 44;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 20)];
    view.backgroundColor = RGBColor(236, 236, 236);
    if (self.dataAry.count == 10) {
        if (section == 9) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
            label.text = @"企业简介:";
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGBColor(136, 136, 136);
            [view addSubview:label];
        }
    }else{
        if (section == 8) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
            label.text = @"企业简介:";
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGBColor(136, 136, 136);
            [view addSubview:label];
        }
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 10) {
        if ((indexPath.section >= 0 && indexPath.section < 7) || indexPath.section == 8) {
            IssueRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
            cell.model = self.dataAry[indexPath.section];
            cell.contentField.delegate = self;
            cell.contentField.tag =  4000 + indexPath.section;
            if ((indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 0) && [self.wan isEqualToString:@"1"]) {
                cell.canChange = YES;
            }
            return cell;
        }else if (indexPath.section == 7){
            IssueRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
            cell.model = self.dataAry[indexPath.section];
            cell.contentField.delegate = self;
            cell.contentField.tag =  4000 + indexPath.section;
            cell.canChange = YES;
            return cell;
        }else{
            self.cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
            _cell.textView.delegate = self;
            IssueModel * model = self.dataAry[9];
            if (![model.contentStr isKindOfClass:[NSNull class]]) {
                _cell.textView.text = model.contentStr;
                if (model.contentStr.length > 1000) {
                    _cell.textView.text = [model.contentStr substringToIndex:999];
                }
                _cell.countLable.text = [NSString stringWithFormat:@"%ld/1000", (long)[model.contentStr length]];
            }
            return _cell;
        }
    }else{
        if (indexPath.section >= 0 && indexPath.section < 8) {
            if (self.dataAry.count == 0) {
                IssueRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
                return cell;
            }
            IssueRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
            cell.model = self.dataAry[indexPath.section];
            cell.contentField.delegate = self;
            cell.contentField.tag =  4000 + indexPath.section;
            if ((indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 0) && [self.wan isEqualToString:@"1"]) {
                cell.canChange = YES;
            }
            return cell;
        }else{
            if (self.dataAry.count == 0) {
                 self.cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
                return _cell;
            }
            self.cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
            _cell.textView.delegate = self;
            IssueModel * model = self.dataAry[8];
            if (![model.contentStr isKindOfClass:[NSNull class]]) {
                _cell.textView.text = model.contentStr;
                _cell.countLable.text = [NSString stringWithFormat:@"%ld/1000", (long)[model.contentStr length]];
            }
            return _cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 5 || indexPath.section == 6) {//5 企业分类  6 主营产品
        IssueModel * model = self.dataAry[indexPath.section];
        ProductPromptViewController * productPromptVC = [[ProductPromptViewController alloc] init];
        if (indexPath.section == 6) {
            productPromptVC.cid = @"9";
            productPromptVC.myBlock = ^(NSArray * productAry){
                if (productAry != nil) {
                    NSString * resultStr = [productAry componentsJoinedByString:@";"];
                    model.contentStr = resultStr;
                }else{
                    model.contentStr = nil;
                }
                [_baseTableView reloadData];
            };
            MZFormSheetController * fromSheet = [[MZFormSheetController alloc] initWithViewController:productPromptVC];
            fromSheet.cornerRadius = 0;
            fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
            fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 40, kUIScreenHeight);
            fromSheet.shouldCenterVertically = YES;
            [fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
                
            }];
        }else{
            IssueRequestTableViewCell *cell = (IssueRequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            _menuTableView.cid = @"8";
            _menuTableView.view.frame = CGRectMake(kUIScreenWidth/3, cell.frame.origin.y + 39, kUIScreenWidth*2/3 - 30, 100);
            if (self.showList) {
                [self.baseTableView addSubview:_menuTableView.view];
                _menuTableView.delegate =self;
            }else{
                [_menuTableView.view removeFromSuperview];
            }
            self.showList = !self.showList;
            self.index = indexPath.section;
        }
    }else{
        if (self.dataAry.count == 10) {
            if (indexPath.section == 7) {
                IssueRequestTableViewCell *cell = (IssueRequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                _menuTableView.cid = @"39";
                _menuTableView.view.frame = CGRectMake(kUIScreenWidth/3, cell.frame.origin.y + 39, kUIScreenWidth*2/3 - 30, 100);
                if (self.showList) {
                    [self.baseTableView addSubview:_menuTableView.view];
                    _menuTableView.delegate =self;
                }else{
                    [_menuTableView.view removeFromSuperview];
                }
                self.showList = !self.showList;
                self.index = indexPath.section;
            }
        }
    }
}

- (void)configerDownMenu{
    self.menuTableView = [[DownTableViewController alloc] init];
    self.showList = YES;
}

- (void)CellGetValue:(NSString *)value{
    if (self.index != 5) {
        IssueModel * model = self.dataAry[self.index];
        model.contentStr = value;
        if (self.showList) {
            [self.baseTableView addSubview:_menuTableView.view];
        }else{
            [_menuTableView.view removeFromSuperview];
        }
        self.showList = !self.showList;
    }else{
        //
//        if (![[self.dataAry[5] contentStr] isEqualToString:@"纱线采购企业"]) {
        if ([self.valued isEqualToString:value]) {
            
        }else{
        if ([value isEqualToString:@"纱线采购企业"]) {
            [self setTitleeeAry:@"纱线采购企业"];
            IssueModel * models = [[IssueModel alloc] init];
            models.leftTitle = @"年采购量:";
            if (self.ncgl) {
                models.contentStr = self.ncgl;
            }else{
                models.contentStr = @"";
            }
            [self.dataAry insertObject:models atIndex:7];
            [_baseTableView insertSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationFade];
            //
            IssueModel * model2 = self.dataAry[6];
            model2.leftTitle  = @"主要采购纱线:";
        }else //if (value isEqualToString:@"纱线采购企业"])
        {
            [self setTitleeeAry:@"hah"];
            if (self.dataAry.count == 10) {
                [self.dataAry removeObjectAtIndex:7];
            }
            IssueModel * model2 = self.dataAry[6];
            model2.leftTitle  = @"主营产品:";
        }
        self.valued = value;
     }
        IssueModel * model = self.dataAry[self.index];
        model.contentStr = value;
        if (self.showList) {
            [self.baseTableView addSubview:_menuTableView.view];
        }else{
            [_menuTableView.view removeFromSuperview];
        }
        self.showList = !self.showList;
    }
    
    [self.baseTableView reloadData];
}



#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
//    MyLog(@"改变了");
    NSInteger number = [textView.text length];
    if (number < 1000) {
        _cell.countLable.text = [NSString stringWithFormat:@"%ld/1000", (long)number];
    }else{
        NSMutableString * string = [_cell.textView.text mutableCopy];
        [string deleteCharactersInRange:NSMakeRange(1000, number - 1000)];
        _cell.textView.text = string;
        _cell.countLable.text = [NSString stringWithFormat:@"%ld/1000", (long)number];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能输入1000字" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ensureAction];
    }
    if (self.dataAry.count == 10) {
        IssueModel * model = self.dataAry[9];
        model.contentStr = textView.text;
    }else{
        IssueModel * model = self.dataAry[8];
        model.contentStr = textView.text;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingTextField = textField;//拿到正在编辑的输入框
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
}
#pragma amrk ----- UITextFieldDelegate 保存每个改变的输入框内容
- (void)textFieldGetValue:(NSString *)value sender:(UITextField *)sender{
    if (sender != nil) {
        IssueModel * model = self.dataAry[sender.tag - 4000];
        model.contentStr = value;
    }
}

#pragma mark -- 
/**
 *  保存按钮响应事件
 */
- (void)saveButClicked:(UIButton *)sender{
    [self textFieldGetValue:self.editingTextField.text sender:self.editingTextField];
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    MyLog(@"+_++_+_+_+%ld", self.dataAry.count);
    for (int i =  0; i < self.dataAry.count - 1; i++) {
        IssueModel * model = self.dataAry[i];
        if ([model.contentStr isKindOfClass:[NSNull class]] || model.contentStr.length == 0) {
            //请输入  不能有空项
            MyLog(@"%@ %@", model.leftTitle, model.contentStr);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确保必填项不为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }else{
            [allParams setObject:model.contentStr forKey:_keyAry[i]];
        }
    }
    MyLog(@" _cell.textView.text.length %ld", _cell.textView.text.length);
    if ([_cell.textView.text isKindOfClass:[NSNull class]] || _cell.textView.text.length > 0) {
        if (self.dataAry.count == 10) {
            [allParams setObject:_cell.textView.text forKey:_keyAry[9]];
        }else{
            [allParams setObject:_cell.textView.text forKey:_keyAry[8]];
        }
    }
    //传空@“”不会改变
    
    [MBProgressHUD showMessage:@"正在上传..."];
    NSString * netPath = @"userinfo/userinfoedit";
    if (self.image) {
        [HttpTool postWithPath:netPath name:@"logo" imagePathList:@[self.image] params:allParams success:^(id responseObj) {
            MyLog(@"&*&**%@", responseObj);
            [MBProgressHUD hideHUD];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
    }else{
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"&*&**%@", responseObj);
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
    
    }
}

#pragma mark --
- (void)uploadImage:(UIButton *)sender{//右边的
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"图片选取" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}
/**
 *  查看图片
 */
- (void)checkImage:(UIButton *)sender{
    CheckImageViewController * checkVC = [[CheckImageViewController alloc] init];
    if (self.image) {
        checkVC.image = self.image;
    }else{
        checkVC.imageUrl = self.imageUrl;
    }
    MZFormSheetController * fromSheet = [[MZFormSheetController alloc] initWithViewController:checkVC];
    fromSheet.shouldCenterVertically = YES;
    fromSheet.cornerRadius =0;
    fromSheet.shouldDismissOnBackgroundViewTap = YES;
    fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 20, 200);
    [fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}
#pragma mark --UIActionSheetDelegate
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//取消
    }else{
        [self selectPicFromPhotos];
    }
}

- (void)selectPicFromPhotos{
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
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    if (self.image) {
        [_topView.button1 setTitle:@"查看图片" forState:UIControlStateNormal];
    }
}


@end
