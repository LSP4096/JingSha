//
//  ProductPromptViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/21.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ProductPromptViewController.h"
#import <MZFormSheetController.h>
#import "OptionProductCollectionViewCell.h"
#import "OptionAnotherCollectionViewCell.h"
#import "ZYCPModel.h"
@interface ProductPromptViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
@property (nonatomic, strong)UICollectionView * baseCollectionView;
@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, strong)UITextField * editingField;
@property (nonatomic, copy)NSString * anotherContentStr;
@end

static NSString * indentifier = @"optionCell";
static NSString * indentifier1 = @"optionAnotherCell";
@implementation ProductPromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configerCollectionView];
    [self configerData];
}

- (void)configerData{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:self.cid forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:(responseObj)];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}
- (void)getDataFromResponseObj:(id)responseObj{
    self.dataAry = [NSMutableArray array];
    for (NSDictionary * dict in responseObj[@"data"]) {
        if (![dict[@"title"] isEqualToString:@"其他"] && ![dict[@"title"] isEqualToString:@"其它"] ) {
            
            ZYCPModel * model = [ZYCPModel objectWithKeyValues:dict];
            model.isSelected = NO;
            [self.dataAry addObject:model];
//            [self.dataAry addObject:dict[@"title"]];
        }
    }
    [_baseCollectionView reloadData];
}

- (IBAction)confirmButtonClicked:(UIButton *)sender {//确认
    //一定要把正在编辑的输入框的内容保存
    [self textFieldDidEndEditing:self.editingField];
    
//    MyLog(@"*&*&*&&*&*&*&*%@", self.anotherContentStr);
    NSMutableArray * ary = [NSMutableArray array];
    for (int i = 0; i < self.dataAry.count; i++) {
//        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        OptionProductCollectionViewCell *cell = (OptionProductCollectionViewCell *)[_baseCollectionView cellForItemAtIndexPath:indexPath];
//        if (cell.selected) {
//            [ary addObject:cell.titleLable.text];
//        }
        ZYCPModel * model = self.dataAry[i];
        if (model.isSelected) {
            [ary addObject:model.title];
        }
    }
    //1区
    NSIndexPath * indexpath = [NSIndexPath indexPathForItem:0 inSection:1];
    OptionAnotherCollectionViewCell * cell = (OptionAnotherCollectionViewCell *)[_baseCollectionView cellForItemAtIndexPath:indexpath];
    if (cell.isSelected && cell.contentField.text.length > 0) {
        [ary addObject:self.anotherContentStr];
    }else if(cell.isSelected && cell.contentField.text.length == 0){
        [self alertView:@"请确保已勾选的其他选项内容不为空"];
        return;
    }
    //通过block把数据返回到主界面
    if (self.myBlock && ary.count > 0) {
        if (ary.count > 5) {
            [self alertView:@"所选内容最多不能超过5项"];
            return;
        }
        self.myBlock(ary);
        [self cancleButtonClicked:nil];
    }else if(self.myBlock && ary.count == 0){
        self.myBlock(nil);
        [self cancleButtonClicked:nil];
    }
}
- (IBAction)cancleButtonClicked:(UIButton *)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}
- (void)alertView:(NSString *)string{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}



- (void)configerCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 41, kUIScreenWidth - 60, kUIScreenHeight - 84) collectionViewLayout:layout];
    _baseCollectionView.delegate =self;
    _baseCollectionView.dataSource = self;
    _baseCollectionView.backgroundColor = [UIColor whiteColor];
    _baseCollectionView.showsVerticalScrollIndicator = NO;
    _baseCollectionView.bounces = YES;
    [self.view addSubview:_baseCollectionView];
    //
    [_baseCollectionView registerNib:[UINib nibWithNibName:@"OptionProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:indentifier];
    [_baseCollectionView registerNib:[UINib nibWithNibName:@"OptionAnotherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:indentifier1];
}
#pragma mark -- 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((kUIScreenWidth - 80)/3, 30);
    }else{
        return CGSizeMake(kUIScreenWidth, 30);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(5, 0, 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 60, 0, 0);
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataAry.count;
    }else{
        if ([self.cid isEqualToString: @"8"]) {
            return 0;
        }else{
            return 1;
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OptionProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
//        cell.titleLable.text = self.dataAry[indexPath.row];
        cell.model = self.dataAry[indexPath.row];
        return cell;
    }else{
        OptionAnotherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier1 forIndexPath:indexPath];
        cell.contentField.delegate = self;
        cell.contentField.text = self.anotherContentStr;
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        OptionProductCollectionViewCell *cell = (OptionProductCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.isSelected = !cell.isSelected;
        ZYCPModel * model = self.dataAry[indexPath.row];
        model.isSelected = !model.isSelected;
    }else{
        OptionAnotherCollectionViewCell * cell = (OptionAnotherCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isSelected = !cell.isSelected;
    }
    [_baseCollectionView reloadData];
}
#pragma mark -- 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.anotherContentStr = textField.text;
}




@end
