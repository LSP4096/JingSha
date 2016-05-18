//
//  CheckImageViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/29.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "CheckImageViewController.h"

@interface CheckImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation CheckImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.image) {
        self.imageview.image = self.image;
    }else{
        if (![self.imageUrl isKindOfClass:[NSNull class]]) {
            
            [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
        }
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
