//
//  CheckQuoteViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "CheckQuoteViewController.h"
#import "CheckQuoteTableViewCell.h"
#import "JudgeViewController.h"
#import "CheckQuoteModel.h"
#import "AcceptPromteViewController.h"
#import <MZFormSheetController.h>
#import "UIScrollView+EmptyDataSet.h"
#define kPageCount 15
@interface CheckQuoteViewController ()<UITableViewDelegate, UITableViewDataSource, CheckQuoteTableViewCellDelegate, AcceptPromteViewControllerDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong)UITableView *baseTable;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)NSMutableArray * dataAry;
@end

@implementation CheckQuoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看报价";
    [self configerTableView];
    self.pageNum = 1;
    self.dataAry = [NSMutableArray array];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshNewData];
}
- (void)refreshNewData{
    self.pageNum = 1;
    [self configerData];
}
- (void)loadMoreData{
    self.pageNum++;
    [self configerData];
}

- (void)configerData{
    NSString * netPath = @"userinfo/buy_bao_list";//求购报价列表
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [allParams setObject:self.bid forKey:@"bid"];//求购的id
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"^^^^^%@", responseObj);
        if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
            [self getDataFromResponseObj:responseObj];
        }
        [_baseTable.header endRefreshing];
        [_baseTable.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"查看报价消息的错误%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    if (self.pageNum == 1) {
        [self.dataAry removeAllObjects];
    }
    for (NSDictionary * dict in responseObj[@"data"]) {
        CheckQuoteModel * model = [CheckQuoteModel objectWithKeyValues:dict];
        [self.dataAry addObject:model];
    }
    [_baseTable reloadData];
}
/**
 *  配置UITableView
 */
- (void)configerTableView{
    self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStylePlain];
    _baseTable.delegate = self;
    _baseTable.dataSource = self;
    _baseTable.rowHeight  = 120;
    [self.view addSubview:_baseTable];
    _baseTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    _baseTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _baseTable.tableFooterView = [[UIView alloc] init];
    //控制分割线缩进
    if ([_baseTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_baseTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_baseTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_baseTable setLayoutMargins:UIEdgeInsetsZero];
    }
    //注册cell
    [_baseTable registerNib:[UINib nibWithNibName:@"CheckQuoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"checkQuoteCell"];
    //
    _baseTable.emptyDataSetDelegate = self;
    _baseTable.emptyDataSetSource = self;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置需要的偏移量,这个UIEdgeInsets左右偏移量不要太大，不然会titleLabel也会偏移的。
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { // iOS8的方法
        // 设置边界为0，默认是{8,8,8,8}
        [cell setLayoutMargins:inset];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
}
#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无报价记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}

#pragma mark --UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count == 0) {
        CheckQuoteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"checkQuoteCell"];
        return cell;
    }
    CheckQuoteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"checkQuoteCell"];
    cell.model = self.dataAry[indexPath.row];
    cell.delegate =self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- 代理
/**
 *  CheckQuoteTableViewCellDelegate的代理  接受报价按钮
 */
- (void)delegatePushToJudgeVC:(UIButton *)sender{
    NSIndexPath * indexPath = [_baseTable indexPathForCell:(CheckQuoteTableViewCell *)sender.superview.superview];
    CheckQuoteModel * model = self.dataAry[indexPath.row];
    NSString * netPath = @"userinfo/buy_bao_jieshou";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:model.bid forKey:@"bid"];//求购的id
    [allParams setObject:model.Id forKey:@"jid"];//报价的id
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"---%@", responseObj);
        [self showPromoteWithJid:model.Id];
    } failure:^(NSError *error) {
        MyLog(@"接收报价的错误:%@", error);
        [SVProgressHUD showErrorWithStatus:@"接受报价失败"];
    }];
}
- (void)showPromoteWithJid:(NSString *)jid{
    //提示弹窗
    AcceptPromteViewController * acceptVC = [[AcceptPromteViewController alloc] init];
    acceptVC.jid = jid;
    acceptVC.delegate = self;
    MZFormSheetController * fromSheet = [[MZFormSheetController alloc] initWithViewController:acceptVC];
    fromSheet.shouldCenterVertically = YES;
    fromSheet.cornerRadius =0;
    //    fromSheet.shouldDismissOnBackgroundViewTap = YES;
    fromSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    fromSheet.presentedFormSheetSize = CGSizeMake(kUIScreenWidth - 70, 160);
    [fromSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}

#pragma mark --AcceptPromteViewControllerDelegate
- (void)hiddenPromote{
    [_baseTable reloadData];
}

- (void)hiddenPromoteAndJudge:(NSString *)jid{
    JudgeViewController * judgeVC = [[JudgeViewController alloc] initWithNibName:@"JudgeViewController" bundle:nil];
    judgeVC.jid = jid;
    [self.navigationController pushViewController:judgeVC animated:YES];
}



@end
