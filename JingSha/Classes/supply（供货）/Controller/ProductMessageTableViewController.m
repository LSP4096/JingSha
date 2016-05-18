//
//  ProductMessageTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/22.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "ProductMessageTableViewController.h"
#import "leaveMessageTopTableViewCell.h"
#import "MessageContentTableViewCell.h"
#import "AnswerMessageViewController.h"
#import "MessageModel.h"
 #import "UIScrollView+EmptyDataSet.h"
#define kPageCount 15
@interface ProductMessageTableViewController ()<MessageContentTableViewCellDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, copy)NSString * testString;
//@property (nonatomic, strong)NSMutableArray * contentDataAry;
@property (nonatomic, strong)NSMutableArray * messageDataAry;
@property (nonatomic, assign)NSInteger pageNum;
@end

static NSString * indentifier = @"topCell";
static NSString * indentifier2 = @"messageContentCell";
@implementation ProductMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(255, 255, 255);
    self.title = @"意向留言";
    [self registerTableViewCell];
    [self addMj];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.testString = @"nidfoijsog你都舒服的时刻都送饭都是叫奋斗发蛋糕附近的小哦感觉佛得角感觉哦机构就哦设计公司哦福建打工金佛山就感动激动设计哦的进攻积";
    self.pageNum = 1;
    [self refreshNewData];
    
    //
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
}

#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无留言记录";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"banner01"];
}

- (void)addMj{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
- (NSMutableArray *)messageDataAry{
    if (_messageDataAry == nil) {
        self.messageDataAry = [NSMutableArray array];
    }
    return _messageDataAry;
}
/**
 *  下拉刷新
 */
- (void)refreshNewData{
    self.pageNum = 1;
    self.messageDataAry = [NSMutableArray array];
    [self configerData];
}
/**
 *  上拉加载更多
 */
- (void)loadMoreData{
    self.pageNum++;
    [self configerData];
}

/**
 *  请求数据
 */
- (void)configerData{
    NSString * netPath = @"userinfo/pro_feedback_list";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(self.pageNum) forKey:@"page"];
    [allParams setObject:@(kPageCount) forKey:@"pagecount"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

/**
 *  解析数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {
        //没有数据（显示空白view，暂无留言）
        if (self.pageNum ==1) {
//            [self configerEmptyView];
        }
    }else{
        for (NSDictionary * dict in responseObj[@"data"]) {
            MessageModel * model = [MessageModel objectWithKeyValues:dict];
            [self.messageDataAry addObject:model];
        }
        [self.tableView reloadData];
    }
}
- (void)configerEmptyView{
    UIView * emptyView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    emptyView.backgroundColor = RGBColor(236, 236, 236);
    self.tableView.bounces = NO;
    [self.tableView addSubview:emptyView];
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 60)];
    lable.text = @"暂无留言消息";
    lable.backgroundColor = [UIColor whiteColor];
    lable.textColor = RGBColor(71, 71, 71);
    lable.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:lable];
}
- (void)registerTableViewCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"leaveMessageTopTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageContentTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier2];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.messageDataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 85;
    }else{
        return [MessageContentTableViewCell callHight:[self.messageDataAry[indexPath.section] title]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        leaveMessageTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
        cell.model = self.messageDataAry[indexPath.section];
        return cell;
    }else{
        MessageContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.messageDataAry[indexPath.section];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- MessageContentTableViewCellDelegate
- (void)answerMessage{
    AnswerMessageViewController * answerVC = [[AnswerMessageViewController alloc] init];
    [self.navigationController pushViewController:answerVC animated:YES];
}



@end
