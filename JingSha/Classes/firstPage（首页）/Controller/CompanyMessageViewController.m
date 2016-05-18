//
//  CompanyMessageViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CompanyMessageViewController.h"
#import "IntroductTableViewController.h"
#import "CertifyViewController.h"
#import "ConnectTableViewController.h"
#import "AlterCompanyMassageViewController.h"
#import "AlterConnectStyleTableViewController.h"
@interface CompanyMessageViewController ()<UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)UIView * topView;
@property (nonatomic, strong)NSMutableArray * buttonsAry;
@property (nonatomic ,strong)UIButton * button;
@property (nonatomic ,strong)IntroductTableViewController * introductVC;
@property (nonatomic, assign)NSInteger butTag;
@property (nonatomic, strong)UIButton * but;//右上角编辑按钮

@property (nonatomic, strong)UIImagePickerController * picker;
@property (nonatomic, copy)NSString * wanStr;
@property (nonatomic, strong)NSMutableArray * rzxximg;//图片id
@property (nonatomic, strong)NSMutableArray * rzxxarr;//图片链接
@end

@implementation CompanyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"企业信息";
    [self geDataFromUrl];
    [self configerTopView];
    [self configerRightTopBut];
}

- (void)geDataFromUrl{
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getWanStr:responseObj];
    } failure:^(NSError *error) {
        
    }];
}
- (void)getWanStr:(id)response{
//    MyLog(@"%@", response);
    _wanStr = response[@"data"][@"wan"];
    _rzxxarr = response[@"data"][@"rzxxarr"];
    _rzxximg = response[@"data"][@"rzxximg"];
}
/**
 *  配置右上角按钮
 */
- (void)configerRightTopBut{
    if (self.isCanAlter) {
        self.but = [UIButton buttonWithType:UIButtonTypeCustom];
        _but.frame = CGRectMake(0, 0, 40, 30);
        [_but setTitle:@"编辑" forState:UIControlStateNormal];
        _but.titleLabel.font = [UIFont systemFontOfSize:14];
        [_but addTarget:self action:@selector(rightTopButClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_but];
    }
}
#pragma mark --
- (void)configerTopView{
    NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"企业介绍",@"认证信息", @"联系方式", nil];
    self.buttonsAry = [@[]mutableCopy];
    for (int i = 0; i < 3; i++) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0 + (kUIScreenWidth/3)*i, kNavigationBarHeight, kUIScreenWidth/3, 45);
        _button.backgroundColor = [UIColor whiteColor];
        [_button setTitleColor:RGBColor(104, 104, 104) forState:UIControlStateNormal];
        [_button setTitle:titleAry[i] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        _button.tag = 1000 + i;
        [self.buttonsAry addObject:_button];
        [_button addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
        if (_button.tag == 1000) {
            [self selectButtonClicked:_button];
        }
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,kNavigationBarHeight + 44, kUIScreenWidth, 1)];
    view.backgroundColor = RGBColor(249, 249, 249);
//    view.backgroundColor  = [UIColor redColor];
    [self.view addSubview:view];
}
- (void)selectButtonClicked:(UIButton *)sender{
    self.butTag = sender.tag;
    if (self.topView) {
        [self.topView removeFromSuperview];
    }
    sender.backgroundColor = RGBColor(236, 236, 236);
    for (UIButton * button in self.buttonsAry) {
        if (button.tag != sender.tag) {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0 + (kUIScreenWidth/3) * (sender.tag - 1000), kNavigationBarHeight, kUIScreenWidth/3, 2)];
    _topView.backgroundColor = RGBColor(249, 153, 56);
    [self.view addSubview:_topView];
    //
    if (sender.tag == 1001) {
        if ([_wanStr isEqualToString:@"1"]) {
            self.but.hidden = YES;
        }else{
            self.but.hidden = NO;
        }
    }else{
        self.but.hidden = NO;
    }
    //在添加新的view之前，先把之前的移除
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
            
        }
    }
    NSMutableArray * ary = [self.childViewControllers mutableCopy];
    [ary removeAllObjects];
    if (sender.tag == 1000) {
        self.introductVC = [[IntroductTableViewController alloc] init];//重写初始化方法，给其传入数据源
        self.introductVC.proID = self.proid;
        [self.view addSubview:self.introductVC.view];
    }else if (sender.tag == 1001){
        CertifyViewController * certifyVC = [[CertifyViewController alloc] init];
        certifyVC.proID =  self.proid;
        [self addChildViewController:certifyVC];
        [self.view addSubview:certifyVC.view];
    }else{
        ConnectTableViewController * connectVC = [[ConnectTableViewController alloc] init];
        connectVC.proID = self.proid;
        [self addChildViewController:connectVC];
        [self.view addSubview:connectVC.view];
    }
}
/**
 *  企业信息的界面，如果右上角有编辑按钮的情况的响应事件
 */
- (void)rightTopButClick:(UIButton *)sender{
    if (self.butTag == 1000) {
        AlterCompanyMassageViewController * alterVC = [[AlterCompanyMassageViewController alloc] init];
        [self.navigationController pushViewController:alterVC animated:YES];
    }else if (self.butTag == 1001){
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择图片路径" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [action showInView:self.view];
    }else{
        AlterConnectStyleTableViewController * alterConnectVC = [[AlterConnectStyleTableViewController alloc] init];
        [self.navigationController pushViewController:alterConnectVC animated:YES];
    }
}
#pragma mark -- 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //警示框
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
    } else if(buttonIndex == 1){
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //选择模式
        _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _picker.delegate = self;
        //弹出相册
        [self presentViewController:self.picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CertifyViewController * certifyVC = [self.childViewControllers firstObject];
    certifyVC.centifierImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self uploadImg:image];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//取消
    }else{//确定
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //选择模式
        _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _picker.delegate = self;
        //弹出相册
        [self presentViewController:self.picker animated:YES completion:nil];
    }
}
/**
 *  上传拿到的图片
 */
- (void)uploadImg:(UIImage *)image{
    [MBProgressHUD showMessage:@"正在上传..."];
    NSString * netPath = @"userinfo/userinfoedit";
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];

    if (_rzxximg.count > 1) {
        [_rzxximg removeObjectAtIndex:0];
         NSString * imgString = [_rzxximg componentsJoinedByString:@","];
        [allParams setObject:imgString forKey:@"img"];
    }else{
        [allParams setObject:@"" forKey:@"img"];
    }
    
    [HttpTool postWithPath:netPath indexName:@"img" imagePathList:@[image] params:allParams success:^(id responseObj) {
        [MBProgressHUD hideHUD];
       MyLog(@"（）（（））%@", responseObj);
    } failure:^(NSError *error) {
        
    }];
}

@end
