//
//  ComponentPartViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/18.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ComponentPartViewController.h"
#import "CompoentCollectionViewCell.h"
#import "CompoentLongCollectionViewCell.h"
#import <MZFormSheetController.h>
#import "ComponentModel.h"
#import "IssueRequestViewController.h"
#import "CompoentAnotherCollectionViewCell.h"
@interface ComponentPartViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (strong, nonatomic)  UICollectionView *baseCollectionView;
//@property (nonatomic, strong)NSMutableArray * dataSourceAry;

@property (nonatomic, strong)NSMutableArray * dataAry;

@property (nonatomic, strong)NSMutableArray * array;
@property (nonatomic, strong)NSMutableArray * array2;
@property (nonatomic ,strong)NSMutableArray * titleArray;//存放选中的原料成分的成分名称
@property (nonatomic, strong)NSMutableArray * countArray;//存放选中的原料成分数量
@property (nonatomic, strong)ComponentModel * model;

@property (nonatomic, strong)NSMutableArray * saveDataAry;
@property (nonatomic, strong)UITextField * editingField;
@end

static NSString * indentifier = @"compoentCell";
static NSString * indentifier2 = @"longCollectCell";
static NSString * indentifier3 = @"anotherCollectCell";
@implementation ComponentPartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = [NSMutableArray array];
    self.countArray = [NSMutableArray array];
    self.array = [NSMutableArray array];
    self.array2 = [NSMutableArray array];
    self.model = [[ComponentModel alloc] init];
    self.model.isAdd = YES;
    
    [self configerSaveData];
    
    [self configerData];
    [self.view addSubview:self.baseCollectionView];
    
}

- (void)configerSaveData{
    self.saveDataAry = [NSMutableArray array];
    for (int i = 0; i < self.saveNameArray.count; i++) {
        ComponentModel * model = [[ComponentModel alloc] init];
        model.title = self.saveNameArray[i];
        model.contentString = self.savePrecentArray[i];
        model.isSelected = YES;
        [self.saveDataAry addObject:model];
    }
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
        if (![dict[@"title"] isEqualToString:@"其它"] || ![dict[@"title"] isEqualToString:@"其他"]) {
            [self.dataAry addObject:dict[@"title"]];
        }
    }
    [self changeDataArray];//改变数组中的存放顺序，标题短的放到最前边
}

- (void)changeDataArray{
    self.array = [NSMutableArray array];
    self.array2 = [NSMutableArray array];
    for (NSString * str in self.dataAry) {
        int strLength = [self getToInt:str];
        ComponentModel * model = [[ComponentModel alloc] init];
        model.title = str;
        //
        for (ComponentModel * saveModel in self.saveDataAry) {
            if ([model.title isEqualToString:saveModel.title]) {
                model = saveModel;
            }
            if (![self.dataAry containsObject:saveModel.title]) {
                self.model = saveModel;
                MyLog(@"****");
            }
        }
        if (strLength >= 11) {
            [_array2 addObject:model];
        }else{
            [_array addObject:model];
        }
    }
    [self.dataAry removeAllObjects];
    [self.dataAry addObjectsFromArray:_array];
    [self.dataAry addObjectsFromArray:_array2];
    //在最后加一个“其他”

    [self.baseCollectionView reloadData];
//    MyLog(@"%@", self.dataSourceAry);
}
- (UICollectionView *)baseCollectionView{
    if (_baseCollectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        self.baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 42, kUIScreenWidth - 20, kUIScreenHeight - 84) collectionViewLayout:layout];//这个大小要按弹窗视图的大小来
        self.automaticallyAdjustsScrollViewInsets = YES;
        _baseCollectionView.backgroundColor = RGBColor(255, 255, 255);
        _baseCollectionView.delegate = self;
        _baseCollectionView.dataSource = self;
        //注册cell
        [_baseCollectionView registerNib:[UINib nibWithNibName:@"CompoentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:indentifier];
        [_baseCollectionView registerNib:[UINib nibWithNibName:@"CompoentLongCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:indentifier2];
        [_baseCollectionView registerNib:[UINib nibWithNibName:@"CompoentAnotherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:indentifier3];
    }
    return _baseCollectionView;
}

#pragma mark -- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.array.count;
    }else if(section == 1){
        return self.array2.count;
    }else{
        return 1;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }else if(section == 1){
        return UIEdgeInsetsMake(10, -20, 0, 10);
    }else{
        return UIEdgeInsetsMake(10, -20, 0, 10);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return CGSizeMake((collectionView.frame.size.width - 30)/2, 30);
    } else{
        return CGSizeMake(collectionView.frame.size.width - 50, 30);//自动居中
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.array.count == 0) {
            CompoentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
            return cell;
        }
        CompoentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
        cell.model = self.array[indexPath.row];
        cell.contenttextField.tag = 5000 + indexPath.row;
        cell.contenttextField.delegate = self;
        return cell;
    }else if(indexPath.section == 1){
        if (self.array2.count == 0) {
            CompoentLongCollectionViewCell * longCell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier2 forIndexPath:indexPath];
            return longCell;
        }
        CompoentLongCollectionViewCell * longCell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier2 forIndexPath:indexPath];
        longCell.model = self.array2[indexPath.row];
        longCell.contentField.tag = 6000 + indexPath.row;
        longCell.contentField.delegate = self;
        return longCell;
    }else{
        CompoentAnotherCollectionViewCell * anotherCell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier3 forIndexPath:indexPath];
        anotherCell.anotherModel = self.model;
        anotherCell.contentField.delegate = self;//自主输入的输入框的的代理
        anotherCell.precentField.delegate = self;
        anotherCell.contentField.tag = 2000;
        anotherCell.precentField.tag = 3000;
        return anotherCell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  == 0) {
        ComponentModel * model = [self.array objectAtIndex:indexPath.row];
        model.isSelected = !model.isSelected;
    }else if(indexPath.section == 1){
        ComponentModel * model = [self.array2 objectAtIndex:indexPath.row];
        model.isSelected = !model.isSelected;
    }else{
        self.model.isSelected = !self.model.isSelected;
    }
    [self.baseCollectionView reloadData];
}



/**
 *  用这个方法计算一个有英文字母和汉字的字符串的字节总长度
 */
- (int)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return (int)[da length];
}
#pragma mark --- 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField != nil) {
        if (textField.tag == 2000) {//前两个是自定义输入的
            self.model.title = textField.text;
        }else if(textField.tag == 3000){//3000
            self.model.contentString = textField.text;
        }else{
            if (textField.tag >= 5000 && textField.tag < 6000) {//短的
                ComponentModel * model = self.array[textField.tag - 5000];
                model.contentString = textField.text;
            }
            if(textField.tag >= 6000){//长的
                ComponentModel * model = self.array2[textField.tag - 6000];
                model.contentString = textField.text;
            }
        }
        [_baseCollectionView reloadData];
    }
    self.editingField = nil;
}

//确认按钮
- (IBAction)confirmBut:(UIButton *)sender {
    [self.titleArray removeAllObjects];
    [self.countArray removeAllObjects];
    [self.view endEditing:YES];
    //
    [self textFieldDidEndEditing:self.editingField];
    for (int i = 0; i < self.array.count; i++) {
        ComponentModel * model = self.array[i];
        if (model.isSelected) {
            [self.titleArray addObject:model.title];
            if (model.contentString.length > 0) {
                [self.countArray addObject:model.contentString];
            }else{
                [self alertView:@"请确保类型和输入内容数量匹配"];
                return;
            }
        }
    }
    if (self.array2.count != 0) {
        for (int j = 0; j < self.array2.count; j++) {
            ComponentModel * model = self.array2[j];
            if (model.isSelected) {
                [self.titleArray addObject:model.title];
                if (model.contentString.length > 0) {
                    [self.countArray addObject:model.contentString];
                }else{
                    [self alertView:@"请确保类型和输入内容数量匹配"];
                    return;
                }
            }
        }
    }
    //自定义的输入框
    if (self.model.isSelected && self.model.title.length > 0 && self.model.contentString.length > 0) {
        [self.titleArray addObject:self.model.title];
        [self.countArray addObject:self.model.contentString];
    }else if(self.model.isSelected && (self.model.title.length == 0 || self.model.contentString.length == 0)){
        [self alertView:@"请确保自选项填写完整"];
        return;
    }
    
    //    MyLog(@"&&&&&&&%d   %d", self.titleArray.count, self.countArray.count);
    if (self.myblock && self.titleArray.count != 0  && self.countArray.count != 0) {
        if (self.titleArray.count != self.countArray.count) {
            [self alertView:@"请确保类型和输入内容数量匹配"];
            return;
        }
        NSInteger sum = 0;
        for (int i = 0; i < self.countArray.count; i++) {
            if ([self isPureNumandCharacters:self.countArray[i]]) {
                sum += [self.countArray[i] integerValue];
            }else{
                [self alertView:@"请确保输入的百分比都为数字"];
                return;
            }
        }
//        MyLog(@"###%ld", self.countArray.count);
        if (sum != 100) {
            [self alertView:@"请确保各成分总和等于100"];
            return;
        }else{//什么都满足了，把数据传回去显示
            self.myblock(self.titleArray, self.countArray);
            [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            }];
        }
    }else if(self.titleArray.count == 0 && self.countArray.count == 0){//什么都没有就返回
        self.myblock(self.titleArray, self.countArray);
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        }];
    }
}
/**
 *  判断一个字符串是不是都是数字
 */
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

- (void)alertView:(NSString *)string{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [self.countArray removeAllObjects];
    [self.titleArray removeAllObjects];
}
- (IBAction)cancleBut:(UIButton *)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
