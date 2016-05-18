//
//  DownTableViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/26.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "DownTableViewController.h"

@interface DownTableViewController ()

@property (nonatomic, strong)NSMutableArray * dataAry;

@end

@implementation DownTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    MyLog(@"%@", self.cid);
    if ([self.cid isEqualToString:@"-1"]) {
        self.dataAry = [@[@"纱线",@"原料"]mutableCopy];
        CGRect frame = self.tableView.frame;
        frame.size.height = self.dataAry.count * 40;
        self.tableView.frame = frame;
        [self.tableView reloadData];
    }else{
        [self configerData];
    }

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.dataAry removeAllObjects];
    [self.tableView reloadData];//清空数据之后刷新。防止下一次显示该tableView的时候，会闪一下之前的数据
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 40;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
/**
 *  请求数据
 */
- (void)configerData{
    NSString * netPath = @"pro/typelist";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:self.cid forKey:@"cid"];
    MyLog(@"%@", self.cid);
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"***%@", responseObj);
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"@@@%@", error);
    }];
}
/**
 *  解析拿到的原始数据
 */
- (void)getDataFromResponseObj:(id)responseObj{
    self.dataAry = [NSMutableArray array];
    for (NSDictionary * dict in responseObj[@"data"]) {
        [self.dataAry addObject:dict[@"title"]];
    }
    CGRect frame = self.tableView.frame;
    if (self.dataAry.count < 5) {
        frame.size.height = self.dataAry.count * 40;
    }else{
    frame.size.height = 200;
    }
    self.tableView.frame = frame;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * indentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGBColor(119, 119, 119);
    cell.textLabel.text = self.dataAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CellGetValue:)]) {
        [self.delegate CellGetValue:cell.textLabel.text];
    }
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
