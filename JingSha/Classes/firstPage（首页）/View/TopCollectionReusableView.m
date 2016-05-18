//
//  TopCollectionReusableView.m
//  JingSha
//
//  Created by 周智勇 on 15/12/8.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "TopCollectionReusableView.h"

@interface TopCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *telLable;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end

@implementation TopCollectionReusableView

- (void)awakeFromNib {
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.size.width/2;
    
}

- (void)setUserinfo:(NSDictionary *)userinfo{
    _userinfo = userinfo;
//        MyLog(@"_______%@", self.userinfo);
    if ([_userinfo[@"gongsi"] isKindOfClass:[NSString class]] && ((NSString *)_userinfo[@"gongsi"]).length != 0) {
        self.nameLable.text = _userinfo[@"gongsi"];
    } else {
        self.nameLable.text = @"暂无";
    }
    if ([_userinfo[@"zcd"] isKindOfClass:[NSString class]] && ((NSString *)_userinfo[@"zcd"]).length != 0) {
        self.addressLable.text = _userinfo[@"zcd"];
    } else {
        self.addressLable.text = @"暂无";
    }
    if ([_userinfo[@"dianhua"] isKindOfClass:[NSString class]] && ((NSString *)_userinfo[@"dianhua"]).length != 0) {
        self.telLable.text = _userinfo[@"dianhua"];
    } else {
        self.telLable.text = @"暂无";
    }
    if ([_userinfo[@"logo"] isKindOfClass:[NSString class]] && ((NSString *)_userinfo[@"logo"]).length != 0) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_userinfo[@"logo"]] placeholderImage:[UIImage imageNamed:@"NetBusy"] completed:nil];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"NetBusy"];
    }
    
}

-(void)setSc:(NSString *)sc{
    _sc = sc;
//    MyLog(@"++%@", sc);
    if ([_sc isEqualToString:@"false"]) {
        [self.collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [self.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
}

- (IBAction)collectBtnClicked:(UIButton *)sender {
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    NSString * netPath = @"userinfo/shoucan_add";
    NSString * string = [NSString string];
    if ([_sc isEqualToString:@"false"]) {
        string = @"收藏";
        [self setSc:@"true"];
    }else if ([_sc isEqualToString:@"true"]){
        string = @"取消收藏";
        [self setSc:@"false"];
    }
    [allParams setObject:self.userinfo[@"id"]forKey:@"uid"];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        MyLog(@"成功%@", responseObj);
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",string]];
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@失败",string]];
    }];
}

@end
