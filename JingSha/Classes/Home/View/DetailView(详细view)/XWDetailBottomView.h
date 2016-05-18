//
//  LookBottomView.h
//  新闻
//
//  Created by Think_lion on 15/5/19.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>

//此view的高度
#define DetailBottomH  40

typedef enum
{
    DetailCommentType,
    DetailCollectionType,
    DetailLikeType
}DetailButtonType;

@class XWDetailBottomView;
@protocol XWDetailBottomDelegate <NSObject>

@optional
-(void)detailBottom:(XWDetailBottomView*)detailView tag:(DetailButtonType)tag;

@end

@interface XWDetailBottomView : UIView

//
@property (nonatomic,strong) NSMutableArray *buttons;
//
@property (nonatomic,weak) id<XWDetailBottomDelegate> delegate;

@end
