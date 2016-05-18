//
//  XWCommentViewController.m
//
//
//  Created by bocweb on 15/11/13.
//
//

#import "XWCommentViewController.h"
#import "XWDetailBottomView.h"
#import "XWWriteReply.h"
#import "CommentHeadTableViewCell.h"
#import "CommemtCountTableViewCell.h"
#import "CommentContentTableViewCell.h"
#import "CommentModel.h"
#import "SingleTon.h"
#import "XWLoginController.h"
#define kPage 1
#define kEachPageCount 10
//覆盖层按钮的tag
#define coverTag 1800
static NSString *const headIdentifier = @"CommentHeadTableViewCell";
static NSString *const countIdentifier = @"CommemtCountTableViewCell";
static NSString *const contentdentifier = @"CommentContentTableViewCell";
@interface XWCommentViewController () <XWDetailBottomDelegate,XWWriteReplyDelegate,UITableViewDataSource, UITableViewDelegate, CommentContentTableViewCellDelegate>
{
    NSInteger _currentPage;
}
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, weak) XWDetailBottomView *commentView;///底部的评论View
@property (nonatomic, weak) XWWriteReply *writeReply;///发送评论的输入框
@property (nonatomic, strong) NSMutableArray *arrList;
@property (nonatomic, strong) NSDictionary *dataSource;
@end

@implementation XWCommentViewController
- (NSMutableArray *)arrList {
    if (!_arrList) {
        self.arrList = [NSMutableArray array];
    }
    return _arrList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    self.title = @"评论";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //创建tableView
    [self setupTableView];
    
    [self configureData];
    //添加底部的评论view
    [self setupBottomComment];
    
    [self setupSendView];
    
}

- (void)decideIsNoCollection {
    if ([[SingleTon shareSingleTon].userInformation isKindOfClass:[NSDictionary class]] && [SingleTon shareSingleTon].userInformation != nil) {
        UIButton *collectionBtn = (UIButton *)[self.commentView viewWithTag:DetailCollectionType];
        MyLog(@"!!%@", self.dataSource[@"shou"]);
        if (self.dataSource[@"shou"] == 0 || [self.dataSource[@"shou"] isEqualToString:@"false"]) {
            [collectionBtn setImage:[UIImage imageNamed:@"icon_bottom_star"] forState:UIControlStateNormal];
            collectionBtn.selected = NO;//没有被收藏
        } else {
            [collectionBtn setImage: [UIImage imageNamed:@"icon_star_full"] forState:UIControlStateNormal];
            collectionBtn.selected = YES;//收藏了
        }
    }
}
#pragma mark - setupWebView
- (void)setupTableView {
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kUIScreenWidth, kUIScreenHeight-kNavigationBarHeight-DetailBottomH) style:UITableViewStyleGrouped];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self.view insertSubview:_contentTableView atIndex:1];
    
    /// 注册cell
    [_contentTableView registerNib:[UINib nibWithNibName:headIdentifier bundle:nil] forCellReuseIdentifier:headIdentifier];
    [_contentTableView registerNib:[UINib nibWithNibName:countIdentifier bundle:nil] forCellReuseIdentifier:countIdentifier];
    [_contentTableView registerNib:[UINib nibWithNibName:contentdentifier bundle:nil] forCellReuseIdentifier:contentdentifier];
}
- (void)configureData {
    [self refreshDataList];
    [self downRefresh];
}
#pragma mark - 下拉刷新 ，上拉加载
- (void)refreshDataList
{
    [self loadNewDataList];
}

- (void)loadNewDataList
{
    [self loadDataListWithPage:1];
}

- (void)loadMoreDataList
{
    [self loadDataListWithPage:_currentPage + 1];
}
- (void)loadDataListWithPage:(NSInteger)page {
    //判断有没有网络
    if([XWBaseMethod connectionInternet]==NO){
        XWNetworkLabel *label=[[XWNetworkLabel alloc]init];
        label.textStr=@"网络断开，请重新加载";
        label.x=(kUIScreenHeight-label.width)*0.5;
        label.y=self.view.height*0.45;
        [self.view addSubview:label];
        return;
    }
    NSString *netPath = @"news/pinglun_list";
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParams setObject:self.newsid forKey:@"newsid"];
    [allParams setObject:@(page) forKey:@"page"];
    [allParams setObject:@(kEachPageCount) forKey:@"pagecount"];
    
    [HttpTool getWithPath:netPath params:allParams success:^(id responseObj) {
        if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]] && ((NSDictionary *)responseObj[@"data"]).allKeys.count == 0) {
            
            UILabel *titleLAbel = [[UILabel alloc] initWithFrame:CGRectMake(150, 94, kUIScreenWidth - 200, 50)];
            titleLAbel.text = @"暂无资讯";
            titleLAbel.textColor = [UIColor lightGrayColor];
            [self.contentTableView addSubview:titleLAbel];
            return ;
        }
        [self.contentTableView.header endRefreshing];
        [self.contentTableView.footer endRefreshing];
        [self reloadDataWithPage:page responseObj:responseObj];
        self.dataSource = responseObj;
        MyLog(@"$$$%@", self.dataSource);
    } failure:^(NSError *error) {
        [self.contentTableView.header endRefreshing];
        [self.contentTableView.footer endRefreshing];
    }];
    
}
- (void)reloadDataWithPage:(NSInteger)page responseObj:(NSDictionary *)responseObj {
    MyLog(@"!!%@", responseObj[@"total"]);
    if (![responseObj isKindOfClass:[NSDictionary class]] || responseObj == nil) {
        XWNetworkLabel *label=[[XWNetworkLabel alloc]init];
        label.textStr=@"页面丢失，请查看别的吧！";
        label.x=(kUIScreenHeight-label.width)*0.2;
        label.y=self.view.height*0.45;
        [self.view addSubview:label];
        return;
    }
    _currentPage = page;
    NSInteger totalCount = [responseObj[@"total"] integerValue];
    if (page == 1) { //下拉刷新
        self.arrList = [NSMutableArray array];
    }
    
    NSArray *arrList = responseObj[@"data"];
    if ( ![arrList isKindOfClass:[NSArray class]] ) {
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        XWNetworkLabel *label=[[XWNetworkLabel alloc]init];
        label.textStr=@"页面丢失，请查看别的吧！";
        label.x=(kUIScreenHeight-label.width)*0.2;
        label.y=self.view.height*0.45;
        [view addSubview:label];
        return;
    }
    for (NSDictionary *dict in arrList) {
        if (dict == nil) {
            return;
        }
        CommentModel *model = [CommentModel commentModelWithDic:dict];
        [self.arrList addObject:model];
    }
    //配置是否收藏过
    self.dataSource = responseObj;
    [self decideIsNoCollection];
    [self.contentTableView reloadData];
    
    //判断是否要添加上拉加载
    NSInteger loadCount = kEachPageCount * (page - 1) + arrList.count;
    MyLog(@"%zd", loadCount);
    if (totalCount > loadCount && !self.contentTableView.footer) {
        self.contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataList)];
    }else if(totalCount == loadCount){
        self.contentTableView.footer = nil;
    }
}
- (void)downRefresh {
    self.contentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataList)];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? (self.arrList.count + 1): 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        return 40;
    } else {
        CommentContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentdentifier];
        
        CommentModel *model = self.arrList[indexPath.row-1];
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat height = [model.title boundingRectWithSize:CGSizeMake(cell.contentLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
        CGRect frame = cell.contentLabel.frame;
        frame.size.height = height;
        cell.contentLabel.frame = frame;
        if (model.title.length < 30) {
            return 120;
        } else {
            return (160 + height);
        }
    }
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///新闻标题
    if (!indexPath.section) {
        CommentHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headIdentifier forIndexPath:indexPath];
        [cell configureDataWithDic:self.dataSource];
        return cell;
    }///总评论数
    else if (1 == indexPath.section && 0 == indexPath.row) {
        CommemtCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countIdentifier forIndexPath:indexPath];
        MyLog(@"%@", self.dataSource[@"total"]);
        cell.countLabel.text = [NSString stringWithFormat:@"  评论(%@)", self.dataSource[@"total"]];
        return cell;
    }///评论详情
    else {
        CommentContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentdentifier forIndexPath:indexPath];
        cell.delegate = self;
        CommentModel *model = self.arrList[indexPath.row-1];
        cell.model = model;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 点赞响应事件
- (void)sendCommentPid:(NSString *)pid {
    if ([self checkIsLogin] == NO) {
        return;
    }
    NSString *netPath = @"news/pinglun_zan";
    NSMutableDictionary *allParemeters = [NSMutableDictionary dictionary];
    [allParemeters setObject:pid forKey:@"pid"];
    NSString *userid = [SingleTon shareSingleTon].userInformation[@"userid"];
    [allParemeters setObject:userid forKey:@"userid"];
    MyLog(@"!!!%@ ,%@", pid,userid);
    [HttpTool getWithPath:netPath params:allParemeters success:^(id responseObj) {
        MyLog(@"%@, %@", responseObj[@"return_code"], responseObj[@"msg"]);
        
        if ([responseObj[@"msg"] isEqualToString:@"ok"]) {
            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
            [self loadDataListWithPage:_currentPage];
            [self.contentTableView reloadData];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:responseObj[@"msg"]];
        [self loadDataListWithPage:_currentPage];
        [self.contentTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 添加底部的评论view
-(void)setupBottomComment {
    CGFloat bottomX = 0;
    CGFloat bottomH = DetailBottomH;
    CGFloat bottobW = self.view.width;
    CGFloat bottomY = self.view.height-bottomH;
    XWDetailBottomView *bottom = [[XWDetailBottomView alloc] initWithFrame:CGRectMake(bottomX, bottomY, bottobW, bottomH)];
    bottom.delegate = self;
    [self.view addSubview:bottom];
    self.commentView = bottom;
}
#pragma mark 底部view的代理方法
-(void)detailBottom:(XWDetailBottomView *)detailView tag:(DetailButtonType)tag
{
    switch (tag) {
        case DetailCommentType:
        {
            if ([self checkIsLogin] == NO) {
                return;
            }
            //1.添加一个遮盖层
            UIButton *cover=[[UIButton alloc]initWithFrame:self.view.bounds];
            [cover setBackgroundColor:RGBAColor(0, 0, 0, 0.6)];
            cover.tag=coverTag;
            [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view insertSubview:cover belowSubview:self.writeReply];
//            //2.输入框获取焦点
            [self.writeReply.textView becomeFirstResponder];
        }
            break;
            /**
             *  收藏
             */
        case DetailCollectionType:
        {
            UIButton *collectionBtn = (UIButton *)[self.commentView viewWithTag:tag];
            collectionBtn.selected = !collectionBtn.selected;
            //  检测是否已经登录
            if ([self checkIsLogin] == NO) {
                return;
            }
                NSString *netPath = @"userinfo/shoucan_add";
                NSMutableDictionary *allParemeters = [NSMutableDictionary dictionary];
                [allParemeters setObject:[SingleTon shareSingleTon].userInformation[@"userid"] forKey:@"userid"];
                [allParemeters setObject:self.newsid forKey:@"newsid"];
                [HttpTool postWithPath:netPath params:allParemeters success:^(id responseObj) {
                    [self loadDataListWithPage:_currentPage];
                    [self.contentTableView reloadData];
                    [SVProgressHUD showSuccessWithStatus:responseObj[@"msg"]];//收藏 取消收藏成功
                } failure:^(NSError *error) {
                    
                }];
        }
            break;
            /**
             *  分享
             */
        case DetailLikeType:
        {
            NSArray *imageArrar = [NSArray new];
            if ([self.newsInfoDic[@"photo"] isKindOfClass:[NSArray class]] && ((NSArray *)self.newsInfoDic[@"photo"]).count) {
                MyLog(@"%@", self.newsInfoDic[@"photo"]);
                NSString *imageName = [NSString stringWithFormat:@"%@",((NSArray *)self.newsInfoDic[@"photo"]).firstObject];
                imageArrar = @[imageName];
            } else {
                imageArrar = @[[UIImage imageNamed:@"icon@2x"]];
            }
            //参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:self.newsInfoDic[@"content"] images:imageArrar url:[NSURL URLWithString:self.sendUrl] title:self.dataSource[@"title"] type:SSDKContentTypeAuto];
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
            break;
    }
}
- (void)showAlertViewWithTitle:(NSString *)title
                         error:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}
#pragma mark 添加发送评论的输入框
-(void)setupSendView
{
    XWWriteReply *write=[[XWWriteReply alloc]init];
    write.delegate=self; //实现代理
    write.x=0;
    write.y=self.view.height;
    [self.view addSubview:write];
    self.writeReply=write;
    //监听文本框值的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:write.textView];
    
}
#pragma mark 文本框的输入值发生改变的时候
-(void)textChange
{
    if(self.writeReply.textView.text.length>0){
        [self.writeReply.send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.writeReply.send setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}
#pragma mark 文本输入框的代理方法
-(void)writeReply:(XWWriteReply *)write buttonTag:(SendButtonType)tag
{
    switch (tag) {
        case SendButton:
        {
            if(self.writeReply.textView.text.length < 2){
                self.writeReply.writeLabel.hidden=YES;
                //添加一个动画
                [UIView animateWithDuration:1.5 animations:^{
                    
                    self.writeReply.lightLabel.hidden=NO;
                    //有一个等待时间
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.writeReply.lightLabel.hidden=YES;
                        self.writeReply.writeLabel.hidden=NO;
                    });
                } ];
                
            } else {
                /// 发送评论
                NSString *netPath = @"userinfo/pinglun_add";
                NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
                [allParameters setObject:[SingleTon shareSingleTon].userInformation[@"userid"] forKey:@"userid"];
                [allParameters setObject:self.newsid forKey:@"newsid"];
                [allParameters setObject:self.writeReply.textView.text forKey:@"title"];
                [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
                    [SVProgressHUD showSuccessWithStatus:responseObj[@"msg"]];
                    
                    [self loadNewDataList];
                    [self.contentTableView reloadData];
                    // 移除覆盖层
                    UIButton *cover=(UIButton*)[self.view viewWithTag:coverTag];
                    [cover removeFromSuperview];
                    [self coverClick:cover];
                    
                    [self.writeReply.textView resignFirstResponder]; //失去焦点
                } failure:^(NSError *error) {
                    
                }];
                
            }
            
        }
            break;
        case CancelButton:
        {
            // 移除覆盖层
            UIButton *cover=(UIButton*)[self.view viewWithTag:coverTag];
            [cover removeFromSuperview];
            [self coverClick:cover];
            
            [self.writeReply.textView resignFirstResponder]; //失去焦点
        }
    }
}
#pragma mark 遮盖层按钮的点击
-(void)coverClick:(UIButton*)cover
{
    [cover removeFromSuperview]; //移除按钮
    [self.writeReply.textView resignFirstResponder];
}
//视图将要出现的时候

-(void)viewWillAppear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //    UIApplication *app = [UIApplication sharedApplication];
    //    app.statusBarStyle = UIStatusBarStyleDefault;
    
    //监听键盘的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //将要隐藏的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillClose:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //键盘
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
#pragma mark 键盘将要出现
-(void)keyboardWillShow:(NSNotification*)note
{
    
    
    CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //改变发送框的frame
    [UIView animateWithDuration:duration animations:^{
        self.writeReply.transform=CGAffineTransformMakeTranslation(0, -(keyboardF.size.height+self.writeReply.height));
        
    }];
}

#pragma mark 键盘将要隐藏
-(void)keyboardWillClose:(NSNotification*)note
{
    //移除遮盖层
    //     [self.cover removeFromSuperview];
    
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
        self.writeReply.transform=CGAffineTransformIdentity;
        
    }];
}

-(void)dealloc
{
    //在控制器销毁的时候 设置回颜色
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - tableView下划线
-(void)viewDidLayoutSubviews
{
    if ([self.contentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contentTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.contentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.contentTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,20,0,20)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,20,0,20)];
    }
}
#pragma mark - 判断用户是否登录
- (BOOL)checkIsLogin {
    ///先判断用户当点是否登录
    if (KUserImfor != nil) {
        return YES;
    } else {
        [self showAlertView];
        return NO;
    }
}
- (void)showAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先登录" message:@"是否前往登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark -  AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
        loginVC.fd_prefersNavigationBarHidden = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}
@end
