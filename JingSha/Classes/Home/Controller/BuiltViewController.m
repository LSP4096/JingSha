//
//  BuiltViewController.m
//  JingSha
//
//  Created by BOC on 15/11/9.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "BuiltViewController.h"

@interface BuiltViewController ()
@property (weak, nonatomic) IBOutlet UIButton *popBtn;

@end

@implementation BuiltViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popBtn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)handlePop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
