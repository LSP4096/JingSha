//
//  ConnectViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/9.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "ConnectViewController.h"
#import <MZFormSheetController.h>
@interface ConnectViewController ()

@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLable;
@property (nonatomic,strong)NSDictionary * dataDict;
@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configerData];
}

- (NSDictionary *)dataDict{
    if (_dataDict == nil) {
        self.dataDict = [NSDictionary dictionary];
    }
    return _dataDict;
}

- (void)configerData{
    NSString * netPath = @"pro/pro_info";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.chanpinId forKey:@"proid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"联系方式%@", responseObj);
        self.dataDict = responseObj[@"data"];
        self.nameLabel.text = _dataDict[@"name"];
        self.gongsiLable.text = _dataDict[@"gongsi"];
        self.telLable.text = _dataDict[@"dianhua"];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (IBAction)cancleButClicked:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

- (IBAction)playTelClicked:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataDict[@"dianhua"]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
