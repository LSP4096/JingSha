//
//  CommentModel.h
//  
//
//  Created by bocweb on 15/11/13.
//
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
///评论的id
@property (nonatomic, copy) NSString *pid;
///内容
@property (nonatomic, copy) NSString *title;
///赞的数量
@property (nonatomic, copy) NSString *zan;
///用户名
@property (nonatomic, copy) NSString *username;
///时间
@property (nonatomic, copy) NSString *time;
///用户头像
@property (nonatomic, copy) NSString *photo;

- (id)initWithDic:(NSDictionary *)dic;
+ (id)commentModelWithDic:(NSDictionary *)dic;


@end
