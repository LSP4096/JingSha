//
//  XWMemberCenterViewController.m
//  JingSha
//
//  Created by BOC on 15/11/4.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "XWMemberCenterViewController.h"
#import "XWLoginController.h"
#import "MainNavigationController.h"
#import "SingleTon.h"
#import "MemberEditViewController.h"
#import "HelpTableViewController.h"

#import "ChangePWViewController.h"
#import "CompanyInfoViewController.h"
#import "BuiltViewController.h"
#import "MyCommentViewController.h"
#import "CollectionViewController.h"
#import "SSKeychain.h"
#import "CompanyManageTableViewController.h"
#import "MyStandingsTableViewController.h"
#import "RealTimeDataViewController.h"
#import "XWTableViewCell.h"

#import "AboutYarnViewController.h"
#import "HttpClient+Authentication.h"

@interface XWMemberCenterViewController () <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIImageView *avartView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *attendanceBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonatomic, copy)NSString * proclick;
@property (nonatomic, copy)NSString * click;
@property (nonatomic, copy)NSString * xingji;
//@property (nonatomic, copy)NSString * jifen;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (nonatomic, assign) CGRect oldRect;

@property (weak, nonatomic) IBOutlet UILabel *QianDaoLable;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, copy)NSString * num;
@property (nonatomic, copy)NSString * qiandao;//是否签到
@end
static NSString *const indentifier2 = @"XWCell";
@implementation XWMemberCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureAvariViewAndOtherInfo];
    [self configerShowData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldRect = self.headerView.frame;
    
    //设置微信登录头像
    [self setAvartView];
    
    self.view.backgroundColor = RGBColor(235, 235, 241);
    self.fd_prefersNavigationBarHidden = YES;
    [self setupTableView];
    [self setupTableHeadView];
    [self registerCell];
    
}

- (void)setAvartView {
    NSDictionary *weChatDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXResponse_UserInfo"];
    if (weChatDic) {
        [self.avartView sd_setImageWithURL:weChatDic[@"headimgurl"] placeholderImage:nil];
    }
}

- (void)registerCell{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XWTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier2];
}

- (void)configerShowData{
    //请求数据
    NSString *netPath = @"userinfo/userinfo_post";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        //        MyLog(@"%@", responseObj);
        self.proclick = responseObj[@"proclick"];
        NSDictionary * dict = responseObj[@"data"];
        self.click = dict[@"click"];
        self.xingji = dict[@"xinji"];
        self.num = dict[@"num"];
        self.qiandao = responseObj[@"qiandao"];
        [self hiddenOrShow];
        [_contentTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)hiddenOrShow{
    if ([self.qiandao isEqualToString:@"false"]) {
        self.QianDaoLable.hidden = YES;
        self.lineView.hidden = YES;
        self.attendanceBtn.hidden = NO;
    }else{
//        [self QianDaoSuccess];
        self.attendanceBtn.hidden = YES;
        self.QianDaoLable.hidden = NO;
        self.lineView.hidden = NO;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已连续签到%@天", self.num]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length - 6)];
        self.QianDaoLable.attributedText = str;
    }
}

/**布局TableView*/
- (void)setupTableView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 80)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentTableView.tableFooterView = footView;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 20, kUIScreenWidth - 40, 50);
    button.backgroundColor = RGBColor(30, 78, 144);
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(handleQuit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];

    if (KUserImfor == nil) {
        self.contentTableView.tableFooterView.hidden = YES;
    }

}
/**创建头视图*/
- (void)setupTableHeadView {
    //签到按钮
    CGFloat btnH = self.attendanceBtn.frame.size.height;
    self.attendanceBtn.layer.cornerRadius = btnH / 2;
    
}
/**配置头像等登录的信息*/
- (void)configureAvariViewAndOtherInfo {
    if (KUserImfor == nil) {
        [self viewDidLoad];
        return;
    }
    self.contentTableView.tableFooterView.hidden = NO;
    if ([KUserImfor[@"photo"] isKindOfClass:[NSNull class]]) {
        self.avartView.image = [UIImage imageNamed:@"tab-club"];
    }else{
        
        [self.avartView sd_setImageWithURL:[NSURL URLWithString:KUserImfor[@"photo"]] placeholderImage:[UIImage imageNamed:@"tab-club"]];
    }
    CGFloat avartViewH = _avartView.frame.size.height;
    _avartView.layer.cornerRadius = avartViewH / 2;
    _avartView.layer.masksToBounds = YES;
    if (![KUserImfor[@"username"] isKindOfClass:[NSNull class]]) {
        [self.loginBtn setTitle:KUserImfor[@"username"] forState:UIControlStateNormal];
    }else{
        
    }
}


#pragma mark - 轻拍更换头像
- (IBAction)handleChangePhoto:(UITapGestureRecognizer *)sender {
    if (KUserImfor != nil) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择图片路径" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [action showInView:self.view];
    } else {
            XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
            loginVC.fd_prefersNavigationBarHidden = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - 提交编辑
- (void)handleSubmit {
    NSDictionary *userInfoDic = [SingleTon shareSingleTon].userInformation;
    NSString *netPath = @"userinfo/userinfoedit";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:userInfoDic[@"userid"] forKey:@"userid"];
    
    
    [HttpTool postWithPath:netPath name:@"photo" imagePathList:@[self.avartView.image] params:allParameters success:^(id responseObj) {
        if (![responseObj[@"return_code"] integerValue]) {
            [SingleTon shareSingleTon].userInformation = responseObj[@"data"];
            MyLog(@"提交%@", responseObj[@"data"]);
            [self.avartView sd_setImageWithURL:[NSURL URLWithString:responseObj[@"data"][@"photo"]]];
        }
        if (!responseObj[@"return_code"]) {
            //配置数据
        }
    } failure:^(NSError *error) {
    }];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //警示框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持拍照,是否调用相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //调用相册选择图片
    self.picker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.delegate = self;
            _picker.allowsEditing = YES;
            [self presentViewController:_picker animated:YES completion:nil];
            return;
        } else {
            [alertView show];
            return;
        }
        return;
    } else if(buttonIndex == 1){
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //选择模式
        _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _picker.delegate = self;
        //弹出相册
        [self presentViewController:self.picker animated:YES completion:nil];
    }

}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage = [self fixOrientation:image];
    self.avartView.image = newImage;
    [self handleSubmit];
    [picker dismissViewControllerAnimated:YES completion:nil];
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self handleSubmit];
    [picker dismissViewControllerAnimated:YES completion:nil];
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
#pragma mark - 解决照片旋转问题
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
#pragma mark - 编辑个人信息
- (IBAction)handleEdit:(UIButton *)sender {
    NSDictionary *userInfoDic = KUserImfor;
    if (![userInfoDic isKindOfClass:[NSDictionary class]] || ![userInfoDic[@"userid"] isKindOfClass:[NSString class]]) {
        XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
        loginVC.fd_prefersNavigationBarHidden = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    } else if (userInfoDic == nil) {
        XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
        loginVC.fd_prefersNavigationBarHidden = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    //请求数据
    NSString *netPath = @"userinfo/userinfo_post";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:userInfoDic[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParameters success:^(id responseObj) {
        MemberEditViewController *editVC = [[MemberEditViewController alloc] initWithNibName:@"MemberEditViewController" bundle:nil];
        editVC.sendDic = responseObj[@"data"];
        [self.navigationController pushViewController:editVC animated:YES];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 登录按钮相应事件
- (IBAction)handleLogin:(UIButton *)sender {
    if (KUserImfor == nil) {
    XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
        loginVC.fd_prefersNavigationBarHidden = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark -  AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.message isEqualToString:@"暂不支持拍照,是否调用相册?"]) {
        if (buttonIndex) {
            [self presentViewController:self.picker animated:YES completion:nil];
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            self.picker.delegate = self;
        }
    }else{
        if (buttonIndex == 0) {
            MyLog(@"取消");
        }else{
            MyLog(@"确定");
           
            //
            [SingleTon shareSingleTon].userInformation = nil;//置空用户名个密码
            [SingleTon shareSingleTon].userPassWoed = nil;
            //清空搜索记录
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"titleAry"];
            
            [SSKeychain deletePasswordForService:kServiceName account:kLoginStateKey];
            XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
            loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:loginVC animated:YES completion:nil];
            //
            NSString * netPath = @"userinfo/loginout";
            NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
            [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
            [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
                //没有任何返回
            } failure:^(NSError *error) {
                
            }];
        }
    }
}
#pragma mark - 签到相应事件
- (IBAction)handleAttendance:(UIButton *)sender {
    NSString * netPath = @"userinfo/qiandao";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
        [SVProgressHUD showSuccessWithStatus:@"签到成功"];
        [self QianDaoSuccess];
    } failure:^(NSError *error) {
        
    }];
}

- (void)QianDaoSuccess{
    self.attendanceBtn.hidden = YES;
    self.QianDaoLable.hidden = NO;
    self.lineView.hidden = NO;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已连续签到%zd天", [self.num integerValue] + 1]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,str.length - 6)];
    self.QianDaoLable.attributedText = str;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 6;
            break;
        default:
            return 3;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * visitConutStr = [NSString stringWithFormat:@"%@人", self.click];
    NSString * visitCountStr2 = [NSString stringWithFormat:@"%@人", self.proclick];
    NSMutableAttributedString * companyVisistCount = [self ChangeString:visitConutStr];
    NSMutableAttributedString * productVisitCount = [self ChangeString:visitCountStr2];
    //获取缓存数据的大小
    NSString *historySize = [self calculateHistorySize];
    NSString *strCache = [NSString stringWithFormat:@"%@KB", historySize];
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    NSArray *imageArray = @[@[@"memlog_07", @"memlog_19", @"memlog_21"], @[@"memlog_23", @"memlog_25", @"memlog_28", @"memlog_31", @"memlog_33", @"memlog_36"], @[@"memlog_39", @"memlog_43",@"修改资料_03"]];
    NSArray *titleArray = @[@[@"企业等级", @"企业访问", @"产品访问"], @[@"企业管理", @"我的积分", @"我的评论", @"我的收藏", @"修改密码", @"清除缓存"], @[@"帮助与反馈", @"联系客服",@"关于纱线网"]];
    NSArray *detailArray = @[@[[NSString stringWithFormat:@"实时数据(%@更新)", currentTime],companyVisistCount, productVisitCount],@[@"管理企业、产品、求购信息",@"积分换购享不停", @"评价消息一手掌握", @"信息收藏", @"信息安全轻松搞定", strCache], @[@"帮助反馈可以获得积分啦", @"0571-57579788",@"版本"]];
    if (indexPath.section == 0 && indexPath.row == 0) {
        XWTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier2 forIndexPath:indexPath];
        cell.titleImageView.image = [UIImage imageNamed:imageArray[indexPath.section][indexPath.row]];
        cell.titleLable.text = titleArray[indexPath.section][indexPath.row];
        cell.detailLable.text = detailArray[indexPath.section][indexPath.row];
        cell.starCount = self.xingji;
        return cell;
    }else{
        static NSString *identifier = @"MemberCenter";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.section][indexPath.row]];
        cell.textLabel.text = titleArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 0 && indexPath.row == 2)) {
            cell.detailTextLabel.attributedText = detailArray[indexPath.section][indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.detailTextLabel.text = detailArray[indexPath.section][indexPath.row];
            //        [self configureLabelText:cell.detailTextLabel size:5];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }

}

- (void)handleQuit {
//    [SingleTon shareSingleTon].userInformation = nil;
//    [SingleTon shareSingleTon].userPassWoed = nil;
    
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //退出
        [[HttpClient sharedClient] LogOutWithComplection:^(id resoutObj, NSError *error) {
            
        }];
        
        ///把保存的密码清空
        [SSKeychain deletePasswordForService:kServiceName account:kLoginStateKey];
        //
        [SingleTon shareSingleTon].userInformation = nil;//置空用户名个密码
        [SingleTon shareSingleTon].userPassWoed = nil;
        //清空搜索记录
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"titleAry"];

        XWLoginController *loginVC = [[XWLoginController alloc] initWithNibName:@"XWLoginController" bundle:nil];
        loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:loginVC animated:YES completion:nil];

    }];
    UIAlertAction * cancleAction  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // for iOS8
        [alertView addAction:ensureAction];
        [alertView addAction:cancleAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //刚选中又马上取消选中状态，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (1 == indexPath.section && 5 == indexPath.row) {//清除缓存
        [self clear];
    } else if (2 == indexPath.section && 1 == indexPath.row) {//联系客服
        [self handleCellCall];
    } else if (2 == indexPath.section && 0 == indexPath.row) {//帮助于反馈
        HelpTableViewController *helpVC = [[HelpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:helpVC animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 2){//关于
        AboutYarnViewController *aboutVC = [AboutYarnViewController new];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (1 == indexPath.section && 4 == indexPath.row) {//修改密码
        if (KUserImfor != nil) {
            ChangePWViewController *changeVC = [[ChangePWViewController alloc] initWithNibName:@"ChangePWViewController" bundle:nil];
            [self.navigationController pushViewController:changeVC animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
        }
    } else if (1 == indexPath.section && 3 == indexPath.row) {//我的收藏
        if ([self checkIsLogin] == NO) {
            return;
        }
        CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
        [self.navigationController pushViewController:collectionVC animated:YES];
    } else if (1 == indexPath.section && 2 == indexPath.row){//我的评论
        if ([self checkIsLogin] == NO) {
            return;
        }
        MyCommentViewController *buildVC = [[MyCommentViewController alloc] init];
        [self.navigationController pushViewController:buildVC animated:YES];
    } else if (1 == indexPath.section && 0 == indexPath.row) {//企业管理
        CompanyManageTableViewController * companyTableVC = [[CompanyManageTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:companyTableVC animated:YES];
    } else if(indexPath.section == 1 && indexPath.row == 1){//我的积分
        MyStandingsTableViewController * myStandingVC = [[MyStandingsTableViewController alloc] init];
        [self.navigationController pushViewController:myStandingVC animated:YES];
//        BuiltViewController * buitVC = [[BuiltViewController alloc] init];
//        [self.navigationController pushViewController:buitVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 0){//企业等级
        RealTimeDataViewController * realTimeVC = [[RealTimeDataViewController alloc] init];
        [self.navigationController pushViewController:realTimeVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1){//企业访问
        
    }else if (indexPath.section == 0 && indexPath.row == 2){//产品访问
        
    }
    
}
#pragma mark - 清理缓存
//获取缓存数据的大小
- (NSString *)calculateHistorySize {
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSString *size = [NSString stringWithFormat:@"%zd", files.count /2 * 2];
    return size;
}
//清理缓存
- (void)clear {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认清除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    }];
    UIAlertAction *cancelACtion = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:ensureAction];
    [alertController addAction:cancelACtion];
    [self presentViewController:alertController animated:YES completion:nil];
}
//清理缓存成功
-(void)clearCacheSuccess
{
    [MBProgressHUD showSuccess:@"清除成功"];
    [self.contentTableView reloadData];
}
#pragma mark - 拨打电话
- (void)handleCellCall {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:0571-57579788"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
/**
 *  重新设置分割线
 */
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
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - 判断用户是否登录
- (BOOL)checkIsLogin {
    ///先判断用户当点是否登录
    if ([[SingleTon shareSingleTon].userInformation isKindOfClass:[NSDictionary class]] && [SingleTon shareSingleTon].userInformation != nil) {
        return YES;
    } else {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return NO;
    }
}
#pragma mark -- 显示浏览人数（不同颜色）
-(NSMutableAttributedString *)ChangeString:(NSString *)string{
    NSRange range = NSMakeRange(0, string.length - 1);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:RGBColor(196, 29, 38) range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, string.length)];
    return str;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    MyLog(@"offset****%f",offset.y + 20);
    if (offset.y + 20< 0) {
        //背景图
        CGRect rect = self.headerView.frame;
        rect.size.height = CGRectGetHeight(self.oldRect) - offset.y - 20;
        self.headerView.frame = rect;
        self.headerView.clipsToBounds=NO;
        //头像
        CGRect imgRect = self.avartView.frame;
        imgRect.origin.y = CGRectGetMidY(self.oldRect) - 60 - offset.y - 20;
        self.avartView.frame = imgRect;
        //用户名
        CGRect btnRect = self.loginBtn.frame;
        btnRect.origin.y = CGRectGetMidY(self.oldRect) - offset.y - 5;
        self.loginBtn.frame = btnRect;
        //线条
        CGRect lineRect = self.lineView.frame;
        lineRect.origin.y = CGRectGetMidY(self.oldRect) - offset.y + 35;
        self.lineView.frame = lineRect;
        //签到字条
        CGRect signRect = self.QianDaoLable.frame;
        signRect.origin.y = CGRectGetMidY(self.oldRect) - offset.y + 45;
        self.QianDaoLable.frame = signRect;
        //签到btn
        CGRect signBtnRect = self.attendanceBtn.frame;
        signBtnRect.origin.y = CGRectGetMidY(self.oldRect) - offset.y + 30;
        self.attendanceBtn.frame = signBtnRect;
    }
}

@end
