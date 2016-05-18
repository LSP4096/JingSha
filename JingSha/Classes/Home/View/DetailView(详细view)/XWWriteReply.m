//
//  WriteReply.m
//  新闻
//
//  Created by Think_lion on 15/5/20.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "XWWriteReply.h"

@implementation XWWriteReply

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=RGBColor(235, 235, 235);
        self.width=kUIScreenWidth;  //屏幕的宽度
        self.height=120;  //高度
        //1.添加子空间
        [self setupFirst];
        
    }
    return self;
}
//添加子空间
-(void)setupFirst
{
    //1添加取消按钮
    UIButton *cancel=[self createButton:@"取消" disabeColor:nil];
    cancel.tag=CancelButton; //枚举
    cancel.frame=CGRectMake(10, 10, 40, 25);
    [cancel addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //2.添加发送按钮
    UIButton *send=[self createButton:@"发送" disabeColor:[UIColor lightGrayColor]];
    [send setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    send.tag=SendButton;
    send.frame=CGRectMake(self.width-30-10, 10, 40, 25);
     [send addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.send=send;
    
    //3.添加label
    UILabel *label=[[UILabel alloc]init];
    label.text=@"写评论";
    label.font=[UIFont systemFontOfSize:18];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.frame=CGRectMake((self.width-100)*0.5, 5, 100, 30);
    [self addSubview:label];
    self.writeLabel=label;
    //4. 提醒label
    UILabel *lightLabel=[[UILabel alloc]init];
    lightLabel.hidden=YES; 
    lightLabel.text=@"在写几句吧!";
    lightLabel.font=[UIFont systemFontOfSize:15];
    lightLabel.textColor=[UIColor redColor];
    lightLabel.textAlignment=NSTextAlignmentCenter;
    lightLabel.frame=CGRectMake((self.width-150)*0.5, 5, 150, 30);
    [self addSubview:lightLabel];
    self.lightLabel=lightLabel;
    
    //5.添加输入框
    UITextView *textView=[[UITextView alloc]init];
    textView.font=[UIFont systemFontOfSize:15];
    textView.textColor=[UIColor blackColor];
    textView.frame=CGRectMake(10, 40, self.width-20, 60);
    [self addSubview:textView];
    self.textView=textView;
    
}

-(UIButton*)createButton:(NSString*)title  disabeColor:(UIColor*)color
{
    UIButton *btn=[[UIButton alloc]init];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateDisabled];
    [self addSubview:btn];
    return btn;
}
//取消按钮点击的方法
-(void)buttonClick:(UIButton*)sender
{
    if([self.delegate respondsToSelector:@selector(writeReply:buttonTag:)]){
        [self.delegate writeReply:self buttonTag:sender.tag];
    }
}

@end
