//
//  TableHeaderView.m
//  JingSha
//
//  Created by 周智勇 on 15/12/18.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "TableHeaderView.h"

@interface TableHeaderView ()//<UIActionSheetDelegate>

@property (nonatomic, assign)CGFloat orginX;
@property (nonatomic ,strong)UIButton *deleteBtn;

@end

@implementation TableHeaderView

- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.orginX =(kUIScreenWidth/4 - 40)/2;
        [self addSubview:self.picImageView1];
        [self addSubview:self.picImageView2];
        [self addSubview:self.picImageView3];
        [self addSubview:self.picImageView4];
        [self addSubview:self.cameraBut];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Request_back"]];
        self.count = 0;
        [self configerTapGesture];
    }
    return self;
}
- (UITapGestureRecognizer *)configerTapGesture{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped)];
    return tapGesture;
}

- (UIButton *)configerDeleteBut{
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(30, 0, 10, 10);
    _deleteBtn.layer.masksToBounds = YES;
    _deleteBtn.layer.cornerRadius = 5;
    [_deleteBtn setImage:[UIImage imageNamed:@"Request_cancle2"] forState:UIControlStateNormal];
    _deleteBtn.hidden = YES;
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return _deleteBtn;
}
#pragma mark -- 
- (UIButton *)cameraBut{
    if (!_cameraBut) {
        self.cameraBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraBut.frame = CGRectMake(kUIScreenWidth/2 - 35, 20, 70, 70);
        _cameraBut.layer.masksToBounds = YES;
        _cameraBut.layer.cornerRadius = 35;
        [_cameraBut setImage:[UIImage imageNamed:@"Request_camaer"] forState:UIControlStateNormal];
        [_cameraBut addTarget:self action:@selector(cameraButClick:) forControlEvents:UIControlEventTouchUpInside];
        _cameraBut.tag = 3000;
    }
    return _cameraBut;
}

-(UIImageView *)picImageView1{
    if (!_picImageView1) {
        self.picImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.orginX, 110, 40, 40)];
        self.picImageView1.image = [UIImage imageNamed:@"Request_pic2"];
        self.picImageView1.userInteractionEnabled = YES;
        [self.picImageView1 addSubview:[self configerDeleteBut]];
        [self.picImageView1 addGestureRecognizer:[self configerTapGesture]];
        self.picImageView1.tag = 4000;
    }
    return _picImageView1;
}
-(UIImageView *)picImageView2{
    if (!_picImageView2) {
        self.picImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/4 + self.orginX, 110, 40, 40)];
        self.picImageView2.image = [UIImage imageNamed:@"Request_pic2"];
        self.picImageView2.userInteractionEnabled = YES;
        [self.picImageView2 addSubview:[self configerDeleteBut]];
        [self.picImageView2 addGestureRecognizer:[self configerTapGesture]];
        self.picImageView2.tag = 4001;
    }
    return _picImageView2;
}
-(UIImageView *)picImageView3{
    if (!_picImageView3) {
        self.picImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/4 * 2 + self.orginX, 110, 40, 40)];
        self.picImageView3.image = [UIImage imageNamed:@"Request_pic2"];
        self.picImageView3.userInteractionEnabled = YES;
        [self.picImageView3 addSubview:[self configerDeleteBut]];
        [self.picImageView3 addGestureRecognizer:[self configerTapGesture]];
        self.picImageView3.tag = 4002;
    }
    return _picImageView3;
}
-(UIImageView *)picImageView4{
    if (!_picImageView4) {
        self.picImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/4 * 3+ self.orginX, 110, 40, 40)];
        self.picImageView4.image = [UIImage imageNamed:@"Request_pic2"];
        self.picImageView4.userInteractionEnabled = YES;
        [self.picImageView4 addSubview:[self configerDeleteBut]];
        [self.picImageView4 addGestureRecognizer:[self configerTapGesture]];
        self.picImageView4.tag = 4003;
    }
    return _picImageView4;
}
#pragma mark --

- (void)cameraButClick:(UIButton *)sender{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraBtnClicked:canCamera:)]) {
        if (sender.tag == 3000) {
            
            [self.delegate cameraBtnClicked:self canCamera:YES];
        }else{
            [self.delegate cameraBtnClicked:self canCamera:NO];
        }
    }
}
- (void)deleteBtnClick:(UIButton *)sender{
    UIImageView * imageView = (UIImageView *)sender.superview;
    imageView.image = [UIImage imageNamed:@"Request_pic2"];
    sender.hidden = YES;
    self.cameraBut.userInteractionEnabled = YES;
    self.count -= 1;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBut:)]) {
        [self.delegate deleteBut:imageView];
    }
}

- (void)imageViewTaped{
    [self cameraButClick:nil];
}

@end
