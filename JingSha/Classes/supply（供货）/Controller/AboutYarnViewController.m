//
//  AboutYarnViewController.m
//  JingSha
//
//  Created by 苹果电脑 on 6/30/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "AboutYarnViewController.h"

@interface AboutYarnViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *version;

@end

@implementation AboutYarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"关于中国纱线网";
    self.headerImg.layer.cornerRadius = 5;
    self.headerImg.layer.masksToBounds = YES;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    self.version.text = str(@"版本号:%@",appVersion);
    
    // 获取App的build版本
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    // 获取App的名称
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    
    MyLog(@"%@",appVersion);
    MyLog(@"%@",appBuildVersion);
    MyLog(@"%@",appName);
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
