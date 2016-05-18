//
//  LookBottomView.m
//  新闻
//
//  Created by Think_lion on 15/5/19.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "XWDetailBottomView.h"
#import "SingleTon.h"
#import "XWLoginController.h"
#define MarginX 10

@interface XWDetailBottomView ()
//@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,weak) UIButton *btn;

@end

@implementation XWDetailBottomView

-(NSMutableArray *)buttons
{
    if(_buttons==nil){
        _buttons=[NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor whiteColor];
        //1.添加子控件
        [self setupFirst];
        
    }
    return self;
}
//添加子空间
-(void)setupFirst
{
    //1.添加一条线
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.4)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line];
    //2.添加评论按钮
    [self addCommentBtn];
    //3.添加转发按钮
//    [self addButtonWithImage:@"icon_bottom_star"  selectedImage:@"icon_star_full" tag:DetailCollectionType];
        [self addButtonWithImage:@"icon_bottom_star"  selectedImage:@"icon_star_full" tag:DetailCollectionType];
    [self addButtonWithImage:@"tab-share"  selectedImage:nil tag:DetailLikeType];
}
//添加评论按钮
-(void)addCommentBtn
{
    UIButton *btn=[[UIButton alloc]init];
    btn.tag=DetailCommentType;
    [btn setTitle:@"写评论..." forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    btn.contentMode=UIViewContentModeLeft;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"night_video_comment_pen"] forState:UIControlStateNormal];
    btn.contentEdgeInsets=UIEdgeInsetsMake(0, 12, 0, 0);
    btn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    // 设置高亮的时候不要让图标变色
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置按钮的内容左对齐
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btn setBackgroundImage:[UIImage resizedImage:@"duanzi_button_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizedImage:@"night_choose_city_highlight"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.btn=btn;
}

-(void)addButtonWithImage:(NSString*)image  selectedImage:(NSString*)selectedImage tag:(DetailButtonType)tag
{
  
    UIButton *btn=[[UIButton alloc]init];
     btn.tag=tag;
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage resizedImage:image] forState:UIControlStateNormal];
    if(selectedImage.length>0){
        [btn setImage:[UIImage resizedImage:selectedImage] forState:UIControlStateSelected];;
    }
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:btn];
#warning 收藏的星星暂时关闭
    if (btn.tag == DetailCollectionType) {
//        btn.userInteractionEnabled = NO;
    }
}

#pragma mark 按钮的点击事件
-(void)btnClick:(UIButton*)sender
{
        if ([self.delegate respondsToSelector:@selector(detailBottom:tag:)]) {
            [self.delegate detailBottom:self tag:sender.tag];
        }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //布局跟帖按钮
    CGFloat commentX=MarginX;
    CGFloat commentY=5;
    CGFloat commentH=self.height-10;
    CGFloat commentW=self.width*0.7;
    self.btn.frame=CGRectMake(commentX, commentY, commentW, commentH);
    
    CGFloat shareX=commentW+10+MarginX;
    CGFloat shareY=5;
    CGFloat shareW=30;
    CGFloat shareH=30;
    UIButton *button1=self.buttons[0];
    button1.frame=CGRectMake(shareX, shareY, shareW, shareH);
    
    CGFloat saveW=30;
    CGFloat saveH=30;
    CGFloat saveX=CGRectGetMaxX(button1.frame)+10;
    CGFloat saveY=5;
    UIButton *button2=self.buttons[1];
    button2.frame=CGRectMake(saveX, saveY, saveW, saveH);
}



@end
