//
//  ConnectDetailViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/7.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "ConnectDetailViewController.h"
#import <MZFormSheetController.h>
@interface ConnectDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *gongsiLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *telNumLable;
@property (weak, nonatomic) IBOutlet UILabel *chuanzhenLable;
@property (weak, nonatomic) IBOutlet UILabel *qqLable;
@end

@implementation ConnectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)cancleButton:(UIButton *)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
//    MyLog(@")))))%@", dict);
    self.gongsiLable.text = self.dict[@"gongsi"];
    self.nameLable.text = self.dict[@"name"];
    self.telNumLable.text = self.dict[@"tel"];
    self.chuanzhenLable.text = self.dict[@"chuanzhen"];
    self.qqLable.text = self.dict[@"qq"];
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
