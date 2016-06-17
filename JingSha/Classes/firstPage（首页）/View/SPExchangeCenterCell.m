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
@property (weak, nonatomic) IBOutlet UIView *cntView;
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
    
    self.cntView.layer.cornerRadius = 5;
    self.cntView.layer.borderWidth = 0.001;
    self.cntView.layer.masksToBounds = YES;
    
    [self loadHomePageData];
}

- (void)loadHomePageData {
    @WeakObj(self);
    [[HttpClient sharedClient] getFirstPageInfoComplecion:^(id resoutObj, NSError *error) {
        @StrongObj(self)
        if (error) {
            MyLog(@"首页数据加载错误信息%@", error);
        } else {
            MyLog(@"首页新品推荐数据%@\n", resoutObj);
            [Strongself getDataFromResponseObj:resoutObj];
        }
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
    
    CGFloat scrollerHight = (self.cntView.size.height - self.headerView.frame.size.height - 10);
    self.baseScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(_cntView.frame.origin.x, CGRectGetMaxY(self.headerView.frame) + 8, self.cntView.size.width, scrollerHight)];
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
    self.baseScrollerView.contentSize = CGSizeMake(self.pages * _cntView.frame.size.width, scrollerHight);
    int index = 0;
    CGFloat Width = self.cntView.size.width / 2;
    for (int i = 0; i < self.pages; i++) {
        for (int j = 0; j < 2; j++) {
            ExchangeDetailView *ExchangeView = [[ExchangeDetailView alloc] initWithFrame:CGRectMake(i * _cntView.frame.size.width + j * Width, 0, Width, scrollerHight)];
            ExchangeView.tag = 100 + index;
//            ExchangeView.backgroundColor = RandomColor;
            ExchangeView.model = self.dateArr[index++];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [ExchangeView addGestureRecognizer:tap];
            
            [self.baseScrollerView addSubview:ExchangeView];
        }
    }
    self.pageView.numberOfPages = self.pages;
    
    //给headerView添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTapAction)];
    [self.headerView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    UIView *view  = gesture.view;
    NSString *id = [self.dateArr[view.tag - 100] Id];
    [self putIntoExchangeDetail:id];
}

-(void)putIntoExchangeDetail:(NSString *)Id {
     if (self.delegate&&[self.delegate respondsToSelector:@selector(putIntoExchangeDetail:)]) {
        [self.delegate putIntoExchangeDetail:Id];
    }
}

- (void) headerViewTapAction {
    [self moreBtnClick:nil];
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
