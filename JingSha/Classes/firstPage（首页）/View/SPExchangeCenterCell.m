//
//  SPExchangeCenterCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SPExchangeCenterCell.h"
#import "ExchangeDetailView.h"
#import "SuppleMsgModel.h"

@interface SPExchangeCenterCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIScrollView *baseScrollerView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) NSMutableArray *dateArr;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;

@end

@implementation SPExchangeCenterCell

- (NSMutableArray *)dateArr {
    if (!_dateArr) {
        _dateArr = [[NSMutableArray alloc] init];
    }
    return _dateArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self loadHomePageData];
}

- (void)loadHomePageData {
    NSString * netPath = @"pro/home_list2";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        //        MyLog(@"++%@", responseObj);
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"首页数据加载错误信息%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj {
    NSDictionary * dict  = responseObj[@"data"];
    self.dateArr = [NSMutableArray new];
    for (NSDictionary * smallDict in dict[@"mypro"]) {
         SuppleMsgModel* model = [SuppleMsgModel objectWithKeyValues:smallDict];
        [self.dateArr addObject:model];
    }
    [self configUI];
}

- (void)configUI {
    
    CGFloat scrollerHight = (134 - self.headerView.frame.size.height);
    self.baseScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kUIScreenWidth, scrollerHight)];
    _baseScrollerView.delegate = self;
    _baseScrollerView.pagingEnabled = YES;
    _baseScrollerView.showsVerticalScrollIndicator = NO;
    _baseScrollerView.showsHorizontalScrollIndicator = NO;
    _baseScrollerView.bounces = NO;
    [self addSubview:_baseScrollerView];
    
    if (self.dateArr.count <= 2) {
        self.pages = 1;
    } else if (self.dateArr.count > 2 && self.dateArr.count <= 4) {
        self.pages = 2;
    } else if (self.dateArr.count > 4 && self.dateArr.count <= 6) {
        self.pages = 3;
    }
    
    self.baseScrollerView.contentSize = CGSizeMake(self.pages * kUIScreenWidth, scrollerHight);
    
    for (int i = 0; i < self.pages; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img(@"exchange")];
        imgView.frame = CGRectMake(25 + i * kUIScreenWidth, 55 - CGRectGetMaxY(self.headerView.frame), 64, 61);
        [self.baseScrollerView addSubview:imgView];
        
        CGFloat tableWidth = (kUIScreenWidth - 120) / 2;

        for (int j = 0; j < 2; j++) {
            ExchangeDetailView *ExchangeView = [[ExchangeDetailView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + j * tableWidth + 10, 0, tableWidth, scrollerHight)];
            ExchangeView.tag = 100 + i;
            ExchangeView.model = self.dateArr[i];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [ExchangeView addGestureRecognizer:tap];
            
            [self.baseScrollerView addSubview:ExchangeView];
        }
    }
    self.pageView.numberOfPages = self.pages;
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    UIView *view  = gesture.view;
    NSString *id = [self.dateArr[view.tag] Id];
    [self putIntoExchangeDetail:id];
}

-(void)putIntoExchangeDetail:(NSString *)Id {
     if (self.delegate&&[self.delegate respondsToSelector:@selector(tapAction:)]) {
//        [self.delegate tapAction:Id];
    }
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    [self.delegate exchangeMoreBtnClick];
}

#define mark - UIScrollerViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNum = (scrollView.contentOffset.x + kUIScreenWidth / 2) / kUIScreenWidth;
    self.pageView.currentPage = pageNum;
}


@end
