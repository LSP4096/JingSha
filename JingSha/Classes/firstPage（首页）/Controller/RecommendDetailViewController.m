//
//  RecommendDetailViewController.m
//  JingSha
//
//  Created by 周智勇 on 15/12/7.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "RecommendDetailViewController.h"
#import "DetailGeneralCollectionViewCell.h"
#import "TopCollectionReusableView.h"
#import "CompanyMessageViewController.h"
#import "SupplyDetailViewController.h"
#import "ProListModel.h"
@interface RecommendDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView * baseCollection;
@property (nonatomic, strong)NSMutableArray * proListAry;
@property (nonatomic, copy)NSString * sc;//收藏
@property (nonatomic, strong)NSDictionary * userInfo;

@property (nonatomic, copy)NSString * shareGongsi;
@property (nonatomic, copy)NSString * shareJianjie;
@property (nonatomic, copy)NSString * proid;

@end

@implementation RecommendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"企业详情";
    [self configerRightBarButton];
    
    self.proListAry = [NSMutableArray array];
    [self loadData];
    
    [self.view addSubview:self.baseCollection];
    [self configerBottombutton];
}

- (void)configerBottombutton{
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeight - 45, kUIScreenWidth, 1)];
    lineView.backgroundColor = RGBColor(104,140,179);
    [self.view addSubview:lineView];
    
    UIButton * introduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    introduceButton.frame = CGRectMake(0, kUIScreenHeight - 44, kUIScreenWidth/2, 44);
    introduceButton.backgroundColor = RGBColor(30, 78, 145);
    [introduceButton setTitle:@"公司介绍" forState:UIControlStateNormal];
    [introduceButton addTarget:self action:@selector(introduceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:introduceButton];
    //
    UIButton * connectUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    connectUsButton.frame = CGRectMake(kUIScreenWidth/2, kUIScreenHeight - 44, kUIScreenWidth/2, 44);
    connectUsButton.backgroundColor = RGBColor(254, 254, 254);
    [connectUsButton setTitleColor:RGBColor(163, 163, 163) forState:UIControlStateNormal];
    [connectUsButton setTitle:@"联系我们" forState:UIControlStateNormal];
    [connectUsButton addTarget:self action:@selector(connectUsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectUsButton];
}
/**
 *  请求数据
 */
- (void)loadData{
    NSString * netPath = @"pro/user_pro";
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.qiyeId forKey:@"uid"];
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
//        MyLog(@"+++%@", responseObj);
        [self getDataFromResponseObj:responseObj];
    } failure:^(NSError *error) {
        MyLog(@"%@", error);
    }];
}

- (void)getDataFromResponseObj:(id)responseObj{
    NSDictionary * dataDict = responseObj[@"data"];
    for (NSDictionary * dict in dataDict[@"prolist"]) {
        ProListModel * model = [ProListModel objectWithKeyValues:dict];
        [self.proListAry addObject:model];
    }
    self.userInfo = dataDict[@"userinfo"];
    self.sc = dataDict[@"sc"];
    self.proid = self.userInfo[@"id"];
    self.shareGongsi = self.userInfo[@"gongsi"];
    self.shareJianjie = self.userInfo[@"qyjj"];
    [_baseCollection reloadData];
}


/**
 *  右上角的分享按钮
 */
- (void)configerRightBarButton{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30); 
    [rightButton setImage:[UIImage imageNamed:@"tab-share"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
#pragma mark -- Lazy Loading
-(UICollectionView *)baseCollection{
    if (!_baseCollection) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kUIScreenWidth - 45)/2, 165);
        self.baseCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight - 45) collectionViewLayout:layout];
        _baseCollection.backgroundColor = [UIColor whiteColor];
        self.baseCollection.delegate =self;
        _baseCollection.dataSource =self;
        //注册cell
        [_baseCollection registerNib:[UINib nibWithNibName:@"DetailGeneralCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"generalCell"];
        [self.baseCollection registerNib:[UINib nibWithNibName:@"TopCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_baseCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return _baseCollection;
}
#pragma mark --UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.proListAry.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 20, 15);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailGeneralCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"generalCell" forIndexPath:indexPath];
    cell.model = self.proListAry[indexPath.row];
    return cell;
}
//返回区头区尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 105);
}
//区头区尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TopCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.userinfo = self.userInfo;
        headerView.sc = self.sc;
        return headerView;
    }else
    {
        return nil;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SupplyDetailViewController * supplyVC = [[SupplyDetailViewController alloc] init];
    ProListModel * model = self.proListAry[indexPath.row];
    supplyVC.sendUrlStr = [NSString stringWithFormat:@"http://202.91.244.52/index.php/supply/%@/%@", model.proId,KUserImfor[@"userid"]];
    supplyVC.chanpinId = model.proId;
//    supplyVC.userid = self.qiyeId;
    [self.navigationController pushViewController:supplyVC animated:YES];
}
#pragma mark -- 联系我们 公司介绍按钮响应事件
- (void)connectUsButtonClicked{
    NSString * telStr = self.userInfo[@"dianhua"];
//    MyLog(@"%@", telStr);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}
- (void)introduceButtonClicked{
    CompanyMessageViewController * companyVC = [[CompanyMessageViewController alloc] init];
    companyVC.proid = self.proid;
    [self.navigationController pushViewController:companyVC animated:YES];
}


/**
 *  分享
 */
- (void)shareClicked{
    //分享的图片
    NSArray *imageArrar = @[[UIImage imageNamed:@"icon@2x"]];
    //参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.shareJianjie images:imageArrar url:[NSURL URLWithString:@"www.baidu.com"] title:self.shareGongsi type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           [self showAlertViewWithTitle:@"分享成功" error:nil];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           [self showAlertViewWithTitle:@"分享失败" error:[NSString stringWithFormat:@"%@", error]];
                           break;
                       }
                       default:
                           break;
                   }
                   
               }];
}
- (void)showAlertViewWithTitle:(NSString *)title error:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}



@end
