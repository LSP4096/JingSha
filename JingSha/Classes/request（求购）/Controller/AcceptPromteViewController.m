//
//  AcceptPromteViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/7.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "AcceptPromteViewController.h"
#import <MZFormSheetController.h>
@interface AcceptPromteViewController ()

@end

@implementation AcceptPromteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyLog(@"HHHHHHHHHHHHHHHHHHH%@", self.jid);
}
- (IBAction)didAcceptQuote:(UIButton *)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenPromote)]) {
        [self.delegate hiddenPromote];
    }
}
- (IBAction)goToJudge:(UIButton *)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenPromoteAndJudge:)]) {
        [self.delegate hiddenPromoteAndJudge:self.jid];
    }
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
