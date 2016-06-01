//
//  SPExchangeCenterCell.m
//  JingSha
//
//  Created by 苹果电脑 on 5/26/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import "SPExchangeCenterCell.h"
#import "EcxhangeMinCell.h"

@interface SPExchangeCenterCell ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIScrollView *baseScrollerView;
@property (nonatomic, strong) UITableView *baseTabView;
@property (nonatomic, assign) NSInteger tabViewCount;
@property (nonatomic, strong) NSMutableArray *dateArr;

@end

@implementation SPExchangeCenterCell

- (NSMutableArray *)dateArr {
    if (!_dateArr) {
        _dateArr = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
    }
    return _dateArr;
}
- (UITableView *)baseTabView {
    if (!_baseTabView) {
        _baseTabView = [[UITableView alloc] init];
    }
    return _baseTabView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configUI];
}

- (void)configUI {
    
    CGFloat scrollerHight = (134 - self.headerView.frame.size.height);
    self.baseScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kUIScreenWidth, scrollerHight)];
    _baseScrollerView.delegate = self;
    _baseScrollerView.pagingEnabled = YES;
    _baseScrollerView.showsVerticalScrollIndicator = NO;
    _baseScrollerView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_baseScrollerView];
    
    if (self.dateArr.count <= 2) {
        self.tabViewCount = 1;
    } else if (self.dateArr.count > 2 && self.dateArr.count <= 4) {
        self.tabViewCount = 2;
    } else if (self.dateArr.count > 4 && self.dateArr.count <= 6) {
        self.tabViewCount = 3;
    }
    
    self.baseScrollerView.contentSize = CGSizeMake(self.tabViewCount * kUIScreenWidth, scrollerHight);
    
    for (int i = 0; i < self.tabViewCount; i++) {
        UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(i * kUIScreenWidth, 0, kUIScreenWidth, scrollerHight) style:UITableViewStylePlain];
        tabView.delegate = self;
        tabView.dataSource = self;
        tabView.scrollEnabled = NO;
        tabView.rowHeight = scrollerHight;
        [tabView registerNib:[UINib nibWithNibName:@"EcxhangeMinCell" bundle:nil] forCellReuseIdentifier:@"ExchangeMinCell"];
        [self.baseScrollerView addSubview:tabView];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dateArr.count == 0) {
        EcxhangeMinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeMinCell"];
        return cell;
    }
    EcxhangeMinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeMinCell"];
    NSInteger num = self.baseScrollerView.contentOffset.x / kUIScreenWidth;
    NSInteger index = 2 * num + indexPath.row;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    [self.delegate exchangeMoreBtnClick];
}

@end
