//
//  HelpTableViewController.m
//  
//
//  Created by bocweb on 15/11/24.
//
//

#import "HelpTableViewController.h"
#import "Feedback ViewController.h"
#import "HelpAnswerViewController.h"
@interface HelpTableViewController ()

@property (nonatomic ,strong)NSMutableArray * titleAry;
@property (nonatomic, strong)NSMutableArray * contentAry;
@end

@implementation HelpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助与反馈";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configerData];
    [self configuTableView];
}
/**
 *  配置数据
 */
- (void)configerData{
    NSString *netPath = @"news/feedbacklist";
    [HttpTool getWithPath:netPath params:nil success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        
    }];
}
- (void)getDataFromResponseObj:(id)responseObj{
    self.titleAry = [NSMutableArray array];
    self.contentAry = [NSMutableArray array];
    NSArray * titleArray = responseObj[@"data"];
    for (NSDictionary * dict in titleArray) {
        [self.titleAry addObject:dict[@"title"]];
        [self.contentAry addObject:dict[@"content"]];
    }
    [self.tableView reloadData];
}
/**
 *  配置TableView
 */
- (void)configuTableView {
    self.tableView.rowHeight = 50;
    
    //tableHeadView
    UIView *tableHearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 80)];
    UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    optionBtn.frame = CGRectMake(20, 20, kUIScreenWidth - 40, 50);
    [optionBtn setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [optionBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
    [optionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [optionBtn addTarget:self action:@selector(handleFeed:) forControlEvents:UIControlEventTouchUpInside];
    optionBtn.backgroundColor = [UIColor whiteColor];
    [tableHearView addSubview:optionBtn];
    
    self.tableView.tableHeaderView = tableHearView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"system"];
}
/**
意见反馈页面响应事件
 */
- (void)handleFeed:(UIButton *)sender {
    if (KUserImfor == nil) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
    }else{
        Feedback_ViewController *feedVC = [[Feedback_ViewController alloc] initWithNibName:@"Feedback ViewController" bundle:nil];
        [self.navigationController pushViewController:feedVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titleAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    titleLabel.text = @"常见问题";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor darkGrayColor];
    [hearView addSubview:titleLabel];

    return hearView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"system" forIndexPath:indexPath];
    cell.textLabel.text = self.titleAry[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HelpAnswerViewController * helpVC = [[HelpAnswerViewController alloc] init];
    helpVC.contentString = self.contentAry[indexPath.row];
    [self.navigationController pushViewController:helpVC animated:YES];
}
#pragma mark - tableView下划线
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,20,0,20)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,20,0,20)];
    }
}
@end
