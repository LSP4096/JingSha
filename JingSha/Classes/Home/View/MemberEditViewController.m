//
//  MemberEditViewController.m
//  JingSha
//
//  Created by BOC on 15/11/5.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "MemberEditViewController.h"
#import "UIBarButtonItem+CH.h"
@interface MemberEditViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *picker;


@property (weak, nonatomic) IBOutlet UIButton *avartBtn;
@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *conpanyBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (nonatomic, strong) UIImage *userChoseImage;
@property (nonatomic, strong) UIButton *selectedSEXBtn;
@property (nonatomic, strong) UIButton *unSelectedSEXBtn;
@end

@implementation MemberEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息修改";
    [self configureWithSingleTon];
    [self setupRightItem];
}
- (void)configureWithSingleTon {
    if (![self.sendDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *userInfoDic = self.sendDic;
    if ([userInfoDic[@"headimgurl"] isKindOfClass:[NSString class]]) {
        UIImageView *photo = [[UIImageView alloc] init];
        [photo sd_setImageWithURL:[NSURL URLWithString:userInfoDic[@"headimgurl"]] placeholderImage:[UIImage imageNamed:@"tab-club"]];
        self.avartBtn.layer.cornerRadius = _avartBtn.size.width / 2;
        self.avartBtn.layer.masksToBounds = YES;
        [self.avartBtn setBackgroundImage:photo.image forState:UIControlStateNormal];
    }
    if ([userInfoDic[@"nickname"] isKindOfClass:[NSString class]]) {
        [self.userNameBtn setTitle:userInfoDic[@"nickname"] forState:UIControlStateNormal];
    }
    if ([userInfoDic[@"sex"] isKindOfClass:[NSString class]]) {
        if ([userInfoDic[@"sex"] integerValue] == 1) {
            [self.manBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_03"] forState:UIControlStateNormal];
            self.selectedSEXBtn = self.manBtn;
            [self.womenBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_05"] forState:UIControlStateNormal];
            self.unSelectedSEXBtn = self.womenBtn;
        } else if ([userInfoDic[@"sex"] integerValue] == 2){
            [self.manBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_05"] forState:UIControlStateNormal];
            self.unSelectedSEXBtn = self.manBtn;
            [self.womenBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_03"] forState:UIControlStateNormal];
            self.selectedSEXBtn = self.womenBtn;
        } else {
            [self.womenBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_05"] forState:UIControlStateNormal];
            [self.manBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_05"] forState:UIControlStateNormal];
        }
    }
    if ([userInfoDic[@"tel"] isKindOfClass:[NSString class]]) {
        [self.phoneBtn setTitle:userInfoDic[@"tel"] forState:UIControlStateNormal];
    }
     if ([userInfoDic[@"gongsi"] isKindOfClass:[NSString class]]) {
        [self.conpanyBtn setTitle:userInfoDic[@"gongsi"] forState:UIControlStateNormal];
    }
    if ([userInfoDic[@"addr"] isKindOfClass:[NSString class]]) {
        [self.addressBtn setTitle:userInfoDic[@"addr"] forState:UIControlStateNormal];
    }
}
- (void)setupRightItem {
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithRightTitle:@"保存" target:self action:@selector(handleSubmit)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - 提交编辑
- (void)handleSubmit {
    NSString *passWord = [SingleTon shareSingleTon].userPassWoed;
    NSString *netPath = @"userinfo/userinfoedit";
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters setObject:KUserImfor[@"userid"] forKey:@"userid"];
    [allParameters setObject:passWord forKey:@"password"];
    [allParameters setObject:self.userNameBtn.currentTitle forKey:@"nickname"];
    NSString *userSex = [NSString stringWithFormat:@"%zd", self.selectedSEXBtn.tag];
        [allParameters setObject:userSex forKey:@"sex"];
    [allParameters setObject:self.conpanyBtn.currentTitle forKey:@"gongsi"];
    [allParameters setObject:self.addressBtn.currentTitle forKey:@"addr"];
    [HttpTool postWithPath:netPath name:@"headimgurl" imagePathList:@[self.avartBtn.currentBackgroundImage] params:allParameters success:^(id responseObj) {
        if (![responseObj[@"return_code"] integerValue]) {
            KUserImfor = responseObj[@"data"];
            MyLog(@"提交%@", responseObj[@"data"]);
            [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)configureIQKeyboard {
    //头像按钮的圆角
     CGFloat avartBtnH = self.avartBtn.frame.size.height;
    _avartBtn.layer.cornerRadius = avartBtnH / 2;
    _avartBtn.layer.masksToBounds = YES;
}
#pragma mark - 修改图片
- (IBAction)handleChangePic:(UIButton *)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择图片路径" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [action showInView:self.view];
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
#pragma mark -  AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.message isEqualToString:@"暂不支持拍照,是否调用相册?"]) {
        if (buttonIndex) {
            [self presentViewController:self.picker animated:YES completion:nil];
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            self.picker.delegate = self;
        }
    } else if ([alertView.message isEqualToString:@"请输入昵称"]) {
         if (buttonIndex) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeDefault;
            [self.userNameBtn setTitle:tf.text forState:UIControlStateNormal];
         }
    } else if ([alertView.message isEqualToString:@"请输入联系方式"]) {
        if (buttonIndex) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeDefault;
            [self.phoneBtn setTitle:tf.text forState:UIControlStateNormal];
        }
    }else if ([alertView.message isEqualToString:@"请输入公司名称"]) {
        if (buttonIndex) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeDefault;
            [self.conpanyBtn setTitle:tf.text forState:UIControlStateNormal];
        }
    }else if ([alertView.message isEqualToString:@"请输入地址"]) {
        if (buttonIndex) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeDefault;
            [self.addressBtn setTitle:tf.text forState:UIControlStateNormal];
        }
    }

}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage = [self fixOrientation:image];
    newImage = [self cutImage:newImage];
    self.userChoseImage = newImage;
    CGFloat avartBtnH = self.avartBtn.frame.size.height;
    self.avartBtn.layer.cornerRadius = avartBtnH / 2;
    self.avartBtn.layer.masksToBounds = YES;
    [self.avartBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
#pragma mark - 照片压缩的问题
//裁剪图片
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (self.avartBtn.frame.size.width / self.avartBtn.frame.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * self.avartBtn.frame.size.height / self.avartBtn.frame.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * self.avartBtn.frame.size.width / self.avartBtn.frame.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    return [UIImage imageWithCGImage:imageRef];
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

#pragma mark - 修改昵称
- (IBAction)handleChangeUserName:(UIButton *)sender {
    [self showAlertViewWithMessage:@"请输入昵称"];
}
#pragma mark - 修改性别
- (IBAction)handleMan:(UIButton *)sender {
    MyLog(@"nan:%zd", sender.tag);
    [self chooseSEXWithBtn:sender];
}
- (IBAction)handleWomen:(UIButton *)sender {
    MyLog(@"nv:%zd", sender.tag);
    [self chooseSEXWithBtn:sender];
}
- (void)chooseSEXWithBtn:(UIButton *)sender {
    if (sender == self.selectedSEXBtn) {
        return;
    }
    self.unSelectedSEXBtn = self.selectedSEXBtn;
     self.selectedSEXBtn = sender;
    
    [self.selectedSEXBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_03"] forState:UIControlStateNormal];
    [self.unSelectedSEXBtn setBackgroundImage:[UIImage imageNamed:@"修改资料_05"] forState:UIControlStateNormal];
}
#pragma mark - 修改联系方式
- (IBAction)handleChangePhone:(UIButton *)sender {
//    [self showAlertViewWithMessage:@"请输入联系方式"];
}
#pragma mark - 修改公司
- (IBAction)handleChanCompany:(UIButton *)sender {
//    [self showAlertViewWithMessage:@"请输入公司名称"];
}
#pragma mark - 修改地址
- (IBAction)handleChangeAddress:(UIButton *)sender {
    [self showAlertViewWithMessage:@"请输入地址"];
}
#pragma mark - 修改信息的公共方法
- (void)showAlertViewWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
