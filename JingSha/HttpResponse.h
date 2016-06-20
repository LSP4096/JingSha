//
//  HttpResponse.h
//  JingSha
//
//  Created by 苹果电脑 on 6/16/16.
//  Copyright © 2016 bocweb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HttpResponse : JSONModel
@property (nonatomic, strong) NSString<Optional> *msg; // ok/no
@property (nonatomic, strong) NSString<Optional> *return_code; // 0表示请求正确 
@property (nonatomic, strong) NSString<Optional> *data; //数据

@end
