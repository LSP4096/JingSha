//
//  CertifyViewController.m
//  JingSha
//
//  Created by 周智勇 on 16/1/25.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "CertifyViewController.h"

@interface CertifyViewController ()
@property (nonatomic, strong)NSMutableArray * rzxxarr;//图片链接
@property (nonatomic, copy)NSString * wan;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation CertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake( 0, 109, kUIScreenWidth, kUIScreenHeight - 109);
    
    [self geDataFromUrl];
    
}

- (void)geDataFromUrl{
    NSString * netPath = @"userinfo/userinfo_post";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    
    if (self.proID) {//这个存在说明是别人的信息
        [allParams setObject:self.proID forKey:@"userid"];
    }else{
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    }
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [self getWanStr:responseObj];
    } failure:^(NSError *error) {
        
    }];
}
- (void)getWanStr:(id)response{
    _rzxxarr = response[@"data"][@"rzxxarr"];
    _wan =response[@"data"][@"wan"];
    if ([_wan isEqualToString:@"1"]) {//完善
        if (self.proID) {//别人的
            self.backView.hidden = YES;
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 37, kUIScreenWidth -20, 30)];
//            lable.backgroundColor = [UIColor redColor];
            lable.text = @"此企业已经通过工商营业执照认证";
            lable.font = [UIFont systemFontOfSize:13];
            lable.textColor = RGBColor(102, 102, 102);
            [self.view addSubview:lable];
        }else{//自己的
            if (_rzxxarr.count > 0) {
                [self.centifierImageView sd_setImageWithURL:[NSURL URLWithString:[_rzxxarr firstObject]] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
            }
        }
    }else{//未完善
        if (self.proID) {
            //别人的未完善
        }else{
            if (_rzxxarr.count > 0) {
                [self.centifierImageView sd_setImageWithURL:[NSURL URLWithString:[_rzxxarr firstObject]] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
            }
        }
    }
}

@end
