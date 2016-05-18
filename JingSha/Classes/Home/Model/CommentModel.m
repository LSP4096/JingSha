//
//  CommentModel.m
//  
//
//  Created by bocweb on 15/11/13.
//
//

#import "CommentModel.h"

@implementation CommentModel
- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (id)commentModelWithDic:(NSDictionary *)dic {
    return [[CommentModel alloc] initWithDic:dic];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
