//
//  AppDelegate.m
//  JingSha
//
//  Created by BOC on 15/10/31.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
//#import "OldRootViewController.h"
//#import "MainNavigationController.h"
#import "ICETutorialController.h"
#import "ICETutorialPage.h"
#import <SSKeychain.h>
#import "XWLoginController.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate+IQKeyBoard.h"
#import "AppDelegate+Bugle.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSArray *tutorialLayers;
@property (nonatomic, strong) ICETutorialController *viewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /*分享*/
    [self configureShare];
    /*配置键盘*/
    [self configureKeyBoard];
    
    [self configureBugle];
    //判断是不是第一次启动应用
    [self firstBegin];

    return YES;
}

#pragma mark - 第一次启动
- (void)firstBegin {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        MyLog(@"第一次启动");
        //删除存储到钥匙链的密码
        [SSKeychain deletePasswordForService:kServiceName account:kLoginStateKey];
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        // Init the pages texts, and pictures.
        ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 1" description:@"Champs-Elysées by night" pictureName:@"引导页.jpg"];
        
        ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:@"tutorial_background_00@2x.jpg"
                                                                description:@"The Eiffel Tower with\n cloudy weather"pictureName:@"引导页-2.jpg"];
        
        ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 3" description:@"An other famous street of Paris" pictureName:@"引导页-3.jpg"];
        
        self.tutorialLayers = [NSArray arrayWithObjects:layer1, layer2, layer3, nil];
        self.viewController = [[ICETutorialController alloc] initWithNibandPages:_tutorialLayers];
        self.viewController = [[ICETutorialController alloc] init];
        self.viewController.pages = _tutorialLayers;
        self.window.rootViewController = self.viewController;
    }else{
        MyLog(@"不是第一次启动");
        XWLoginController * loginVC =[[XWLoginController alloc ]initWithNibName:@"XWLoginController" bundle:nil];
        self.window.rootViewController = loginVC;
        //如果不是第一次启动的话,使用LoginViewController作为根视图
//        RootViewController *rootVC = [[RootViewController alloc] init];
//        self.window.rootViewController = rootVC;
    }
    [self.window makeKeyAndVisible];
    [NSThread sleepForTimeInterval:0.5];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSString * netPath = @"userinfo/loginout";
    NSMutableDictionary * allParams = [NSMutableDictionary dictionary];
    if (KUserImfor[@"userid"]) {
        [allParams setObject:KUserImfor[@"userid"] forKey:@"userid"];
    }
    [HttpTool postWithPath:netPath params:allParams success:^(id responseObj) {
//没有任何返回
    } failure:^(NSError *error) {
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bocweb.JingSha" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JingSha" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JingSha.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
