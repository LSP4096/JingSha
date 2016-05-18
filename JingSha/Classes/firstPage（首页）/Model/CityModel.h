//
//  CityModel.h
//  JingSha
//
//  Created by 周智勇 on 15/12/16.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign, getter=isChecked) BOOL checked;

@end
