//
//  IntroductTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "IntroductTableViewController.h"
#import "TopImageTableViewCell.h"
#import "TwoTableViewCell.h"
#import "FourTableViewCell.h"
#import "FiveTableViewCell.h"
#import "ConpanyMessageModel.h"
@interface IntroductTableViewController ()
@property (nonatomic, strong)NSDictionary * dataDict;
@property (nonatomic, strong)NSMutableArray * idAry;

@property (nonatomic, strong)NSMutableArray * dataAry;
@property (nonatomic, copy)NSString * hightString;
@property (nonatomic, copy)NSString * pingjiaStr;
@property (nonatomic, copy)NSString * qyjjStr;
@end

@implementation IntroductTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 45 + kNavigationBarHeight, kUIScreenWidth, kUIScreenHeight -45 - kNavigationBarHeight);
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 20)];
//    self.tableView.tableFooterView.backgroundColor = RGBColor(236, 236, 236);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.idAry = [NSMutableArray arrayWithObjects:@"logo",@"gongsi",@"xinji",@"zcd",@"zczb",@"frdb",@"qygm",@"zycp",@"qywz",@"sxwpj",@"qyjj", nil];//13 个
    [self registerCell];
    [self configerData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self configerData];
}

- (void)registerCell{
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TopImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"topCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"twoCell"];//正常的
    [self.tableView registerNib:[UINib nibWithNibName:@"FourTableViewCell" bundle:nil] forCellReuseIdentifier:@"fourCell"];//企业简介
    [self.tableView registerNib:[UINib nibWithNibName:@"FiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"fiveCell"];//星星
}

- (void)configerData{
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParmas = [NSMutableDictionary  dictionary];
    if (self.proID) {
        [allParmas setObject:self.proID forKey:@"userid"];
    }else{
        [allParmas setObject:KUserImfor[@"userid"] forKey:@"userid"];
    }
    
    [HttpTool postWithPath:netPath params:allParmas success:^(id responseObj) {
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
//     MyLog(@"%@", responseObj);
    self.dataAry = [NSMutableArray array];
    NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"公司名称:",@"企业星级:",@"注册地:",@"注册资本:",@"法人代表:",@"企业规模:",@"主营产品:",@"企业网址:",@"纱线网评价:",@"企业简介:", nil];//12个
    self.dataDict = responseObj[@"data"];
    for (int i = 1; i< _idAry.count; i++) {
        ConpanyMessageModel * model = [[ConpanyMessageModel alloc] init];
        model.title = titleAry[i - 1];
        model.contentStr = self.dataDict[_idAry[i]];
        [self.dataAry addObject:model];
    }
    self.hightString = [[self.dataAry lastObject] contentStr];
    self.pingjiaStr = self.dataDict[@"sxwpj"];
    self.qyjjStr = self.dataDict[@"qyjj"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }else if((indexPath.row > 0 && indexPath.row < 10)){
        if (indexPath.row == 9) {
            if (![self.pingjiaStr isKindOfClass:[NSNull class]]) {
                return [TwoTableViewCell callHight:self.pingjiaStr];
            }else{
                return 34;
            }
        }else{
            return 34;
        }
    }else// 10
    {
        //        return 170;
        if (![self.qyjjStr isKindOfClass:[NSNull class]]) {
            MyLog(@"00000000000000%ld", self.qyjjStr.length);
            if (self.qyjjStr.length <= 200) {
                return 170;
            }else{
                return [FourTableViewCell callHight:self.qyjjStr];
            }
        }else{
            return 170;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TopImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        if (![self.dataDict[@"logo"] isKindOfClass:[NSNull class]]) {
            [cell.topImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"logo"]] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
        }else{
            cell.topImageView.image = [UIImage imageNamed:@"NetBusy"];
        }
        return cell;
    }else if (indexPath.row == 1 || (indexPath.row > 2 && indexPath.row < 10)){
        TwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
        if (indexPath.row == 1) {
            cell.model = self.dataAry[indexPath.row - 1];
        }else{
            cell.model = self.dataAry[indexPath.row - 1];
        }
        return cell;
    }else if (indexPath.row == 2){
        FiveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fiveCell"];
        cell.titleLable.text = @"企业星级:";
        cell.starCount = [self.dataAry[indexPath.row - 1] starCount];
        return cell;
    }else{//企业简介
        FourTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"fourCell"];
        cell.titleLable.text = @"企业简介";
        if ([self.qyjjStr isKindOfClass:[NSNull class]] || self.qyjjStr == nil) {
            cell.contentLable.text = @"";
        }else{
            cell.contentLable.text = self.qyjjStr;
            MyLog(@"self.qyjjStr.length == %ld", self.qyjjStr.length);
//            if (self.qyjjStr.length > 1000) {
//                cell.contentLable.text = [self.qyjjStr substringToIndex:1000];
//            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
