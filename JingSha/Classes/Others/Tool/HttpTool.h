//
//  HttpTool.h
//  TJProperty
//
//  Created by Remmo on 15/6/24.
//  Copyright (c) 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

/**
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
/**
 * get请求
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
/**
 * post请求
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 * post请求，加图片上传
 */
+ (void)postWithPath:(NSString *)path name:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 * post请求，多张图片上传
 */
+ (void)postWithPath:(NSString *)path indexName:(NSString *)name imagePathList:(NSArray *)imageList params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;


/**
 * 自己加的，上传多组图片
 */
+ (void)postWithPath:(NSString *)path indexNames:(NSArray *)names imagePathLists:(NSArray *)imageLists params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;


///**
// *  自己加的(上传多组图片)
// */
//+ (void)uploadImageWithPath:(NSString *)url indexName:(NSString *)name dataPathLists:(NSArray *)dataLists params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

@end
