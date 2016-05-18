//
//  RealTimeDataViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/23.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RealTimeDataViewController.h"
#import "RealDataTableViewCell.h"
#import "VisitTableViewCell.h"
@interface RealTimeDataViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIButton * button;
@property (nonatomic, strong)NSMutableArray * buttonsAry;
@property (nonatomic, strong)UIView * topView;
@property (nonatomic, strong)UITableView * baseTableView;
@end

static NSString * indentifier = @"realDataCell";
static NSString * indentifier2 = @"visitCell";
@implementation RealTimeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(236, 236, 236);
    self.title = @"实时数据";
    [self configerTopView];
    [self.view addSubview:self.baseTableView];
    [self registerCell];
}
#pragma mark --
- (void)configerTopView{
    NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"企业数据",@"产品数据", @"游客", nil];
    self.buttonsAry = [@[]mutableCopy];
    for (int i = 0; i < 3; i++) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0 + (kUIScreenWidth/3)*i, kNavigationBarHeight, kUIScreenWidth/3, 45);
        _button.backgroundColor = RGBColor(250, 250, 250);
        [_button setTitleColor:RGBColor(104, 104, 104) forState:UIControlStateNormal];
        [_button setTitle:titleAry[i] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = RGBColor(231, 231, 231).CGColor;
        _button.tag = 1000 + i;
        [self.buttonsAry addObject:_button];
        [_button addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
        if (_button.tag == 1000) {
            [self selectButtonClicked:_button];
        }
    }
}
- (void)selectButtonClicked:(UIButton *)sender{
    sender.backgroundColor = RGBColor(236, 236, 236);//选中的颜色
    for (UIButton * button in self.buttonsAry) {
        if (button.tag != sender.tag) {
            [button setBackgroundColor:RGBColor(250, 250, 250)];//未选中的颜色
        }
    }
    if (self.topView) {
        [self.topView removeFromSuperview];
    }
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0 + (kUIScreenWidth/3) * (sender.tag - 1000), kNavigationBarHeight, kUIScreenWidth/3, 2)];
    _topView.backgroundColor = RGBColor(249, 153, 56);
    [self.view addSubview:_topView];
    [_baseTableView reloadData];
}

- (void)registerCell{
    [_baseTableView registerNib:[UINib nibWithNibName:@"RealDataTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    [_baseTableView registerNib:[UINib nibWithNibName:@"VisitTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier2];
}
#pragma mark -- Lazy Loading
- (UITableView *)baseTableView{
    if (_baseTableView == nil) {
        self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 109, kUIScreenWidth, kUIScreenHeight - 109) style:UITableViewStylePlain];
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
        _baseTableView.tableFooterView = [[UIView alloc] init];
    }
    return _baseTableView;
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 80;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
    view.backgroundColor = RGBColor(244, 244, 244);
    UILabel  * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 80, 20)];
    lable.text = @"访问记录";
    lable.textColor = RGBColor(111, 111, 111);
    lable.font = [UIFont systemFontOfSize:14];
    [view addSubview:lable];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RealDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
        return cell;
    }else{
        VisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
        return cell;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
