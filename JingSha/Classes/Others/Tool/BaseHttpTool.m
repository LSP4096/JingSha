//
//  BaseHttpTool.m
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import "BaseHttpTool.h"
#import "AFNetworking.h"

@implementation BaseHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",nil];
    
    
//        if ([url rangeOfString:@"pro/pro_list"].location != NSNotFound) {
//            mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//            mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//        }
    
    
    // 2.发送GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//         MyLog(@"url %@--- %@",url, responseObj);
         
//                 if ([url rangeOfString:@"pro/pro_list"].location != NSNotFound) {
//                     NSString *result = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
//                     MyLog(@"&&&&&&&&&%@", result);
//                 }
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [MBProgressHUD showError:@"网络不给力"];
         if (failure) {
             failure(error);
             MyLog(@"error --- %@", error);
         }
     }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];//把数据当做JSON来处理
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    
    // 2.发送POST请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showError:@"网络不给力"];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)uploadImageWithPath:(NSString *)url name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int index=0; index<imageList.count; index++) {
            UIImage * image=[imageList objectAtIndex:index];
            NSData * imageData=UIImageJPEGRepresentation(image, 0.5);
            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg/file"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            [MBProgressHUD showError:@"网络请求错误"];
            failure(error);
        }
    }];
}

+ (void)uploadImageWithPath:(NSString *)url indexName:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int index=0; index<imageList.count; index++) {
            NSString * indexName=[NSString stringWithFormat:@"%@%zd",name,index+1];
            UIImage * image=[imageList objectAtIndex:index];
//            NSData * imageData=UIImagePNGRepresentation(image);
            NSData * imageData=UIImageJPEGRepresentation(image, 0.8);
            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index+1];
            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
        }
//        MyLog(@"%@", params);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MyLog(@"op  %@", operation.response);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 * 自己加的
 */

+ (void)uploadImageWithPath:(NSString *)url indexNames:(NSArray *)names imagePathLists:(NSArray *)imageLists params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
//        if ([url rangeOfString:@"userinfo/my_pro_edit"].location != NSNotFound) {
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        }
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int index=0; index< [imageLists[0] count]; index++) {//顶部图片
            NSString * indexName=[NSString stringWithFormat:@"%@%zd",names[0],index+1];
            UIImage * image=[imageLists[0] objectAtIndex:index];
            NSData * imageData=UIImageJPEGRepresentation(image, 0.8);
            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index+1];
            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
        }
        for (int index=0; index< [imageLists[1] count]; index++) {//图文详细图片
            NSString * indexName=[NSString stringWithFormat:@"%@%zd",names[1],index+1];
            UIImage * image=[imageLists[1] objectAtIndex:index];
            NSData * imageData=UIImageJPEGRepresentation(image, 0.8);
            NSString * fileName=[NSString stringWithFormat:@"img%d.jpg",index+1];
            [formData appendPartWithFileData:imageData name:indexName fileName:fileName mimeType:@"image/jpg/file"];
        }
        MyLog(@"%@", params);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        if ([url rangeOfString:@"userinfo/my_pro_edit"].location != NSNotFound) {
//            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            MyLog(@"&&&&&&&&&%@", result);
//        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
