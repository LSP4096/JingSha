//
//  SPLatestRequestCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SPLatestRequestCell.h"
#import "RequestMsgModel.h"
#import "JSLastRequestDetailCell.h"
#import "RequestDetailViewController.h"
#import "RequestMsgModel.h"

@interface SPLatestRequestCell () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *cntView;
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@end

static NSString *const reUseCellId = @"JSLastRequestDetailCell";
@implementation SPLatestRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cntView.layer.cornerRadius = 5;
    self.cntView.layer.borderWidth = 0.001;
    self.cntView.layer.masksToBounds = YES;
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 90 * KProportionHeight;
    [self.baseTableView registerNib:[UINib nibWithNibName:@"JSLastRequestDetailCell" bundle:nil] forCellReuseIdentifier:reUseCellId];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.headerView addGestureRecognizer:tap];
    
    [self loadData];
}
#pragma mark - LazingLoading
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

/**
 *  加载数据
 */
- (void)loadData {
    @WeakObj(self);
    [[HttpClient sharedClient] getFirstPageInfoComplecion:^(id resoutObj, NSError *error) {
        @StrongObj(self)
        if (error) {
            MyLog(@"首页数据请求错误%@", error);
        } else {
            MyLog(@"首页热门推荐数据%@\n", resoutObj);
            Strongself.countLabel.text = [NSString stringWithFormat:@"%@",resoutObj[@"buylistcount"]];
            [Strongself getDataFromResponseObj:resoutObj];

        }
    }];
    
}

/**
 *  分解数据
 *
 *  @param responseObj 数据
 */
- (void)getDataFromResponseObj:(id)responseObj {
    NSDictionary *dict = responseObj[@"data"];
    NSArray *arrData = dict[@"newbuy"];
    for (id dicData in arrData) {
        RequestMsgModel *model = [RequestMsgModel objectWithKeyValues:dicData];
        [self.dataSource addObject:model];
    }
    [self.baseTableView reloadData];
}
#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableViewH.constant = 90 * KProportionWidth *self.dataSource.count;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 0) {
        JSLastRequestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseCellId];
        return cell;
    }
    JSLastRequestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseCellId];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    RequestMsgModel * model = self.dataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToDetailPageVC:)]) {
        [self.delegate pushToDetailPageVC:model];//跳转用的企业数据
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self moreBtnClick:nil];
}

//点击 more按钮
- (IBAction)moreBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
        [self.delegate moreBtnClick:sender];
    }
}

@end
