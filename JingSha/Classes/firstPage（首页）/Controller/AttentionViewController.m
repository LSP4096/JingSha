//
//  AttentionViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/11.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "AttentionViewController.h"
#import "AttentionTableViewCell.h"
#import "AttentionModel.h"
@interface AttentionViewController ()<UITableViewDelegate, UITableViewDataSource, AttentionTableViewCellDelegate>
@property (nonatomic, strong)NSMutableArray * attentionAry;
@property (nonatomic, strong)NSMutableArray * unAttentionAry;
@property (nonatomic, strong)UITableView * baseTable;
@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(234, 234, 234);
    self.title = @"关注类别";
    [self configerData];
    [self.view addSubview:self.baseTable];
}
- (void)configerData{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:@(15) forKey:@"cid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    self.unAttentionAry = [NSMutableArray array];
    self.attentionAry = [NSMutableArray array];
    NSArray * dataAry = responseObj[@"data"];
    for (NSDictionary * dict in dataAry) {
        AttentionModel * model = [AttentionModel objectWithKeyValues:dict];
        if ([model.guanzhu isEqualToString:@"true"]) {
            [self.attentionAry addObject:model];
        }else{
            [self.unAttentionAry addObject:model];
        }
    }
    [_baseTable reloadData];
}

#pragma mark -- Lazy Loading
- (UITableView *)baseTable{
    if (!_baseTable) {
        self.baseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight) style:UITableViewStyleGrouped];
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
        _baseTable.backgroundColor = RGBColor(235, 235, 235);
//        _baseTable.scrollEnabled = NO;//禁止滑动
        //注册cell
        [_baseTable registerNib:[UINib nibWithNibName:@"AttentionTableViewCell" bundle:nil] forCellReuseIdentifier:@"marketAttentionCell"];
    }
    return _baseTable;
}

#pragma mark --UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.attentionAry.count;
    }else{
        return self.unAttentionAry.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.attentionAry.count == 0) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 115)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 200)/2, 45, 200, 30)];
            lable.text = @"关注后，在首页轻松获知产品热点";
            lable.font = [UIFont systemFontOfSize:13];
            lable.textColor = RGBColor(179, 179, 179);
            [view addSubview:lable];
            return view;
        }else{
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 60, 30)];
            lable.text = @"已关注";
            lable.textColor = RGBColor(100, 100, 100);
            lable.font = [UIFont systemFontOfSize:14];
            [view addSubview:lable];
            return view;
        }
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 60, 30)];
        lable.text = @"未关注";
        lable.textColor = RGBColor(100, 100, 100);
        lable.font = [UIFont systemFontOfSize:14];
        [view addSubview:lable];
        return view;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.attentionAry.count == 0) {
            return 115;
        }else{
            return 45;
        }
    }else{
        return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AttentionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"marketAttentionCell"];
        cell.model = self.attentionAry[indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        AttentionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"marketAttentionCell"];
        cell.model = self.unAttentionAry[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/**
 *  AttentionTableViewCellDelegate
 */
- (void)didClickedAttentionBut:(UIButton *)sender{
    NSString * netPath = @"pro/user_guanzhu";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    
    AttentionTableViewCell * cell = (AttentionTableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [_baseTable indexPathForCell:cell];
    if ([sender.titleLabel.text isEqualToString:@"关注"]) {
        AttentionModel *model = self.unAttentionAry[path.row];
        [allParams setObject:model.Id forKey:@"tid"];
        [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
            [self configerData];
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
    }else{
        AttentionModel *model = self.attentionAry[path.row];
        [allParams setObject:model.Id forKey:@"tid"];
        [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
            [self configerData];
        } failure:^(NSError *error) {
            MyLog(@"%@", error);
        }];
    }
    [_baseTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
