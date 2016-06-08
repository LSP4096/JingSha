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

#define KLabelHight (21 * KProportionHeight)
#define KLabelWeight (100 * KProportionHeight)

@interface SPLatestRequestCell () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *cntView;
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

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
    self.baseTableView.rowHeight = 90;
    [self.baseTableView registerNib:[UINib nibWithNibName:@"JSLastRequestDetailCell" bundle:nil] forCellReuseIdentifier:reUseCellId];
    
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
    NSString *netPath = @"pro/home_list2";
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool getWithPath:netPath params:params success:^(id responseObj) {
         MyLog(@"首页热门推荐数据%@", responseObj);
        self.countLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"buylistcount"]];
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"首页数据请求错误%@",error);
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
    MyLog(@"%ld",self.dataSource.count);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSLastRequestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseCellId];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//点击 more按钮
- (IBAction)moreBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
        [self.delegate moreBtnClick:sender];
    }
}

@end
