//
//  AppMacro.h
//  JingSha
//
//  Created by 苹果电脑 on 5/18/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

//1. 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)
#endif
// 2.获得RGB颜色

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RGBColor(r, g, b) RGBAColor(r,g,b,1.0)

#define kGlobalBg RGBColor(242, 242, 242)
#define kGlobalTintColor RGBColor(65, 156, 184)
#define kGlobalRedColor RGBColor(226, 91, 91)
#define kGlobalDividerColor RGBColor(230, 230, 230)

// 随机色
#define RandomColor RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//定义高度
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width
#define kUIScreenHeight kUIScreenSize.height

#define kNavigationBarHeight 64
#define kTabBarHeight 49

//Key
#define kLoginStateKey @"LoginStateKey"
#define kUserLogin [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStateKey]
#define kServiceName @"Yoyou"

#define kRongCloudTokenKey @"RongCloudTokenKey"
#define kRongCloudUserIdKey @"RongCloudUserIdKey"

#define kUserLogoutNotificaiton @"UserLogoutNotificaiton"

#define kAppID  @"401626263"

//#define kBaseURL  @"http://121.41.128.239:8096/jxw/index.php"
#define kBaseURL  @"http://202.91.244.52/index.php"
//存储用的key
#define KKeyWithNewsID(newsID) [NSString stringWithFormat:@"%@.sqlite", newsID]
#define KKeyWithHistory @"History.sqlite" //浏览历史
#define KKeyWithCollection @"Collection"
#define KKeyWithUserTel @"TEL"

#define KUserImfor [SingleTon shareSingleTon].userInformation
#import "SingleTon.h"
//屏幕比例
#define KProportionWidth kUIScreenWidth / 375
#define KProportionHeight kUIScreenHeight / 667



//程序全局委托
#define pub_appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#pragma mark - Format
/**
 *  生成字符串
 *
 *  @param ... 格式化参数
 *
 *  @return 得到的字符串
 */
#define str(...) [NSString stringWithFormat:__VA_ARGS__]

/**
 *  根据名字返回对应的图片
 */
#define img(name) [UIImage imageNamed:name]

/**
 *  弱对象
 *
 *  @param o 某个obj
 *
 *  @return selfWeak
 */
#define WeakObj(o) autoreleasepool{} __weak typeof(o) Weak##o = o;

/**
 *  在弱引用后强引用
 *
 *  @param o 某个obj
 *
 *  @return 强对象
 */
#define StrongObj(o) autoreleasepool{} __strong typeof(o) Strong##o = Weak##o;

#pragma mark - Tools methods
/**
 *  判断一个对象是否为空
 *
 *  @param thing 对象
 *
 *  @return 返回结果   inline是把函数展开为代码，避免函数调用开销，是为了加快运行速度，而不是加快编译速度
 */
static inline BOOL ICIsObjectEmpty(id thing){
    return thing == nil ||
    ([thing isEqual:[NSNull null]]) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

/**
 *  判断一个字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return 返回结果
 */
static inline BOOL ICIsStringEmpty(NSString *string){
    
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    
    if (string == nil) {
        return YES;
    }
    
    if (string.length == 0) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
}


#endif /* AppMacro_h */
