//
//  HeadViewTableViewCell.h
//  
//
//  Created by bocweb on 15/11/12.
//
//

#import <UIKit/UIKit.h>
#import "JHTickerView.h"
#import "SDCycleScrollView.h"
#import "BannerModel.h"
@protocol HeadViewTableViewCellDelegate <NSObject>

//点击了搜索按钮
- (void)handlePushToSearchWithSender:(UIButton *)sender;
//点击了纤维超市和求购信息的代理，在视图控制器中push
- (void)clickedWantBuyViewToPush:(NSString *)sender;
- (void)clickedSuperMarketViewToPush:(NSString *)sender;
- (void)bannerPush:(BannerModel *)model;
@end


@interface HeadViewTableViewCell : UITableViewCell
@property (nonatomic, strong) SDCycleScrollView *sdcycleScroll;

@property (nonatomic, strong) UIButton *searchBarBtn;
@property (weak, nonatomic) IBOutlet JHTickerView *goView;
//纤维超市和购物车按钮，放在这里便于页面push


@property (nonatomic, weak) id<HeadViewTableViewCellDelegate> delegate;



//- (void)configureData;
@end
