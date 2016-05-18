//
//  SearchViewController.m
//  JingSha
//
//  Created by BOC on 15/11/7.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//从左到右，从上到下
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondBTn;
@property (weak, nonatomic) IBOutlet UIButton *forthBtn;

@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;

@property (weak, nonatomic) IBOutlet UIButton *sevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;

@property (weak, nonatomic) IBOutlet UIButton *nineBtn;

@end

@implementation SearchViewController

#pragma mark - 取消搜索
- (IBAction)handlePop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    //配置状态栏
    [self configureStatueBar];
}
- (void)configureStatueBar {
    self.fd_prefersNavigationBarHidden = YES;
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 20)];
    
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:statusBarView];
}
//根据Btn的title进行搜索
- (IBAction)handleSearchWithBtnTitle:(UIButton *)sender {
    
    
}


@end
