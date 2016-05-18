//
//  MyLable.h
//  Test
//
//  Created by 周智勇 on 16/1/8.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MyLable : UILabel

{
@private VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
