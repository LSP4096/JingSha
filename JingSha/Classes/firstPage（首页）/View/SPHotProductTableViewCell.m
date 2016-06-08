//
//  SPHotProductTableViewCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SPHotProductTableViewCell.h"
#import "NewProModel.h"

@interface SPHotProductTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *cntView;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *title5;
@property (weak, nonatomic) IBOutlet UILabel *title6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *imgs;
@end

@implementation SPHotProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cntView.layer.cornerRadius = 5;
    self.cntView.layer.borderWidth = 0.001;
    self.cntView.layer.masksToBounds = YES;
    
    self.titleArr = [NSMutableArray arrayWithObjects:self.title1, self.title2, self.title3, self.title4, self.title5, self.title6, nil];
    self.imgs = [NSMutableArray arrayWithObjects:_imgView1, _imgView2, _imgView3, _imgView4, _imgView5, _imgView6, nil];
    [self loadData];
}

#define mark - Lazyloading
- (NSMutableArray *)dataArr {
    if (!_dataArr ) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

/**
 *  加载数据
 */
- (void)loadData {
    NSString *netPath = @"pro/home_list2";
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool getWithPath:netPath params:params success:^(id responseObj) {
        MyLog(@"首页热门推荐数据%@", responseObj);
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"首页数据请求错误%@",error);
    }];
}

/**
 *  分解数据
 */
- (void)getDataFromResponseObj:(id)responseObj {
    //供应信息条数
    self.countLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"prolistcount"]];

    NSDictionary * dict  = responseObj[@"data"];
    for (NSDictionary * smallDict in dict[@"newpro"]) {
        NewProModel * model = [NewProModel objectWithKeyValues:smallDict];
        [self.dataArr addObject:model];
    }
    [self setDataToLabel];
}

- (void)setDataToLabel {
    for (int i = 0 ; i < self.dataArr.count; i++) {
        NewProModel *model = [[NewProModel alloc] init];
        model = self.dataArr[i];
        UILabel *label = self.titleArr[i];
        label.text = model.title;
        
        UIImageView *imgView = self.imgs[i];
        imgView.userInteractionEnabled = YES;
        imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.photo]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imgView addGestureRecognizer:tap];
    }
}

-(void)tapAction:(UITapGestureRecognizer *)gesture {
    UIView *selectView = gesture.view;
    NSInteger index =selectView.tag - 101;
    NewProModel * model = _dataArr[index];
    NSString * ID = model.Id;
    if (_delegate && [_delegate respondsToSelector:@selector(pushToDetailVCFromCell:)]) {
        [_delegate pushToDetailVCFromCell:ID];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)moreBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(HotProductMoreBtnClick:)]) {
        [self.delegate HotProductMoreBtnClick:sender];
    }
}

@end
