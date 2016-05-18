//
//  XWHomeController.m
//  JingSha
//
//  Created by BOC on 15/11/2.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "XWHomeController.h"
#import "SXTitleLable.h"
#import "XWNewsShowController.h"
#import "XWMemberCenterViewController.h"
#import "SSKeychain.h"
#import "NSString+Hash.h"
#define smallScrollMenuH 40
#define KSmallLabelHeight 30
#define KSearchBarHeight 40
@interface XWHomeController () <UIScrollViewDelegate>

//大的滑动
@property (nonatomic, weak) UIScrollView *bigScroll;
//小的滑动视图
@property (nonatomic, weak) UIScrollView *smallScroll;

@property (nonatomic, strong) UILabel *smallLabel;
@property (nonatomic, strong) SXTitleLable *oldTitleLable;
@property (nonatomic, assign) CGFloat beginOffsetX;

/**  新闻接口的数组*/
@property (nonatomic, strong) NSArray *arrarList;
@end

@implementation XWHomeController
- (void)dataLoad{

    NSString *netPath = @"news/newstitlelist";
//    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:netPath params:nil success:^(id responseObj) {
        self.arrarList = responseObj[@"data"];
        MyLog(@"%zd", self.arrarList.count);
        [self setupScrollView];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self dataLoad];
    
//    [self setupLeftItem];
    [self handleLogin];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setupLeftItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab-men"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked)];
    leftItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftItemClicked
{
    XWMemberCenterViewController *menberVC = [[XWMemberCenterViewController alloc]init];
    [self.navigationController pushViewController:menberVC animated:YES];

}

#pragma mark 添加滑动视图
- (void)setupScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    //1.添加小的滚动菜单栏
    UIScrollView *smallScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(8, kNavigationBarHeight , kUIScreenWidth - smallScrollMenuH, smallScrollMenuH)];
    [self.view addSubview:smallScroll];
    smallScroll.showsHorizontalScrollIndicator = NO;
    smallScroll.showsVerticalScrollIndicator = YES;
    self.smallScroll = smallScroll;
    //1.1
    //添加标签栏上的按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kUIScreenWidth - smallScrollMenuH, kNavigationBarHeight, smallScrollMenuH , smallScrollMenuH );
    [btn setImage:[UIImage imageNamed:@"tab-menu.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleChangeScroll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //1.2
    //添加菜单栏下面的滚动条
//    self.smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kNavigationBarHeight + smallScrollMenuH - KSmallLabelHeight) , 70, KSmallLabelHeight)];
//    self.smallLabel.backgroundColor = RGBColor(42, 88, 148);
//    [self.view addSubview:self.smallLabel];
    //2.添加大的滚动菜单栏
    UIScrollView *bigScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+smallScrollMenuH, kUIScreenWidth, (kUIScreenHeight - 64 - smallScrollMenuH - kTabBarHeight))];
    bigScroll.showsHorizontalScrollIndicator = NO;
    bigScroll.showsVerticalScrollIndicator = NO;
    bigScroll.delegate = self;
    [self.view addSubview:bigScroll];
    self.bigScroll = bigScroll;
    
    //3.添加子控制器
    [self addController];
    //4.添加标题栏
    [self addLabel];
    //5.设置大的scrollView的滚动范围
    CGFloat contentX = self.childViewControllers.count * kUIScreenWidth;
    self.bigScroll.contentSize = CGSizeMake(contentX, 0);
    self.bigScroll.pagingEnabled = YES;
    
    //6.添加默认子控制器 （第一个）
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = CGRectMake(0, 0, kUIScreenWidth, (kUIScreenHeight - 64 -smallScrollMenuH - kTabBarHeight));
    [self.bigScroll addSubview:vc.view];
    SXTitleLable *label = [self.smallScroll.subviews firstObject];
    label.scale = 1.0;
}
#pragma mark - handleChangeScroll
- (void)handleChangeScroll:(UIButton *)sender {
    //获得索引
    NSUInteger index = self.bigScroll.contentOffset.x / kUIScreenWidth;
    if (index + 4 >= self.smallScroll.subviews.count - 1) {
        index = self.smallScroll.subviews.count - 2;
    } else {
        index = index + 4;
    }
    
    SXTitleLable *titleLabel = self.smallScroll.subviews[index];
    
    CGFloat offsetX = titleLabel.tag * self.bigScroll.frame.size.width;
    
    CGFloat offsetY = self.bigScroll.contentOffset.y;
    
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScroll setContentOffset:offset animated:YES];
    
}
#pragma mark 添加子视图控制器
- (void)addController {
    for (int i = 0; i < self.arrarList.count; i++) {
        XWNewsShowController *vc = [[XWNewsShowController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.title = self.arrarList[i][@"title"];
        vc.cid = self.arrarList[i][@"cid"];
        MyLog(@"%@", vc.title);
        [self addChildViewController:vc];
    }
}

#pragma mark 添加标题栏
- (void)addLabel {
    CGFloat lblW = 70;
    CGFloat lblH = smallScrollMenuH;
    CGFloat lblY = 0;
    CGFloat lblX = 0;
    for (int i = 0; i < self.arrarList.count; i++) {
        lblX = i * lblW;
        SXTitleLable *lbl1 = [[SXTitleLable alloc] init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text = vc.title;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:18];
        [self.smallScroll addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblClick:)]];
    }

    //设置小scroll滚动的范围
    self.smallScroll.contentSize = CGSizeMake(lblW * self.arrarList.count, 0);
    
}
#pragma mark 标签栏的点击事件
- (void)lblClick:(UITapGestureRecognizer *)recognizer {
    SXTitleLable *titleLabel = (SXTitleLable *)recognizer.view;
    
    CGFloat offsetX = titleLabel.tag * self.bigScroll.frame.size.width;
    
    CGFloat offsetY = self.bigScroll.contentOffset.y;
    
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScroll setContentOffset:offset animated:YES];
    
}

#pragma mark - ScrollView代理方法
/**
 *  滚动结束 （手势导致）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
/**
 *  结束滚动后调用 (代码导致)
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //获得索引
    NSUInteger index = scrollView.contentOffset.x / kUIScreenWidth;
    //滚动标题栏
    SXTitleLable *titleLabel = (SXTitleLable *)self.smallScroll.subviews[index];
    CGFloat offsetx = titleLabel.center.x - self.smallScroll.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.smallScroll.contentSize.width - self.smallScroll.frame.size.width;
    
    
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    } else {
        offsetx-= smallScrollMenuH / 2;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.smallScroll.contentOffset.y);
    //  NSLog(@"%@",NSStringFromCGPoint(offset));
    [self.smallScroll setContentOffset:offset animated:YES];
    
    // 添加控制器
    XWNewsShowController *newsVc = self.childViewControllers[index];
    newsVc.cid = self.arrarList[index][@"cid"];
    
    [self.smallScroll.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            if ([self.smallScroll.subviews[idx] isKindOfClass:[SXTitleLable class]]) {
                SXTitleLable *temlabel = self.smallScroll.subviews[idx];
                temlabel.scale = 0.0;
            }
        }
    }];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.bigScroll addSubview:newsVc.view];
}
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SXTitleLable *labelLeft = self.smallScroll.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScroll.subviews.count) {
        
        if ([self.smallScroll.subviews[rightIndex] isKindOfClass:[SXTitleLable class]]) {
            SXTitleLable *labelRight = self.smallScroll.subviews[rightIndex];
            
            labelRight.scale = scaleRight;
        }

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//自动登录
#pragma mark - 登录
- (void)handleLogin {
    NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
    NSString *userTel = [defalts objectForKey:KKeyWithUserTel];
    [defalts synchronize];
    
    NSString *passWord = [SSKeychain passwordForService:kServiceName account:kLoginStateKey];
    if (!userTel.length || !passWord) {
        return;
    }
    
    NSString *netPath = @"userinfo/login";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:userTel forKey:@"tel"];
    [allParameters setObject:passWord.md5String forKey:@"password"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        if (![responseObj[@"return_code"] integerValue]) {
            KUserImfor = responseObj[@"data"];
            [SingleTon shareSingleTon].userPassWoed = passWord.md5String;
            MyLog(@"自动登录成功， %@, %@", [SingleTon shareSingleTon].userInformation, responseObj[@"msg"]);
            self.navigationController.navigationBarHidden = NO;
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"登录信息已过期"];
            [SSKeychain deletePasswordForService:kServiceName account:kLoginStateKey];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
