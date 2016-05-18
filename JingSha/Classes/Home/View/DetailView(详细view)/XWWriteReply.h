//
//  WriteReply.h
//  新闻
//
//  Created by Think_lion on 15/5/20.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    CancelButton,
    SendButton,
}SendButtonType;

@class XWWriteReply;

@protocol XWWriteReplyDelegate <NSObject>

@optional
-(void)writeReply:(XWWriteReply*)write buttonTag:(SendButtonType)tag;

@end

@interface XWWriteReply : UIView
//输入框
@property (nonatomic,weak) UITextView *textView;  //文本框
@property (nonatomic,weak) UIButton *send;
@property (nonatomic,weak)  UILabel *lightLabel;
@property (nonatomic,weak) UILabel *writeLabel;

@property (nonatomic,weak) id<XWWriteReplyDelegate> delegate;

@end
