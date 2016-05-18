//
//  AlwaysCityTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/1/26.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "AlwaysCityTableViewCell.h"
#import "AlwayModel.h"
@interface AlwaysCityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *buttton1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

@property (nonatomic, strong)UIButton * but;

@end
@implementation AlwaysCityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setArray:(NSMutableArray *)array{
    _array = array;
    for (int i = 0; i < array.count; i++) {
        AlwayModel * model = _array[i];
        if (i == 0) {
            [self.buttton1 setTitle:model.title forState:UIControlStateNormal];
            self.buttton1.hidden = NO;
            [self.buttton1 addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            self.buttton1.tag = 2000;
            if (!model.isSelected) {
                self.buttton1.layer.borderWidth = 0;
                self.buttton1.layer.borderColor = nil;
            }
        }
        if (i == 1) {
            [self.button2 setTitle:model.title forState:UIControlStateNormal];
            self.button2.hidden = NO;
            [self.button2 addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            self.button2.tag = 2001;
            if (!model.isSelected) {
                self.button2.layer.borderWidth = 0;
                self.button2.layer.borderColor = nil;
            }
        }
        if (i == 2) {
            [self.button3 setTitle:model.title forState:UIControlStateNormal];
            self.button3.hidden = NO;
            [self.button3 addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            self.button3.tag = 2002;
            if (!model.isSelected) {
                self.button3.layer.borderWidth = 0;
                self.button3.layer.borderColor = nil;
            }
        }
        if (i == 3) {
            [self.button4 setTitle:model.title forState:UIControlStateNormal];
            self.button4.hidden = NO;
            [self.button4 addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
            self.button4.tag = 2003;
            if (!model.isSelected) {
                self.button4.layer.borderWidth = 0;
                self.button4.layer.borderColor = nil;
            }
        }
    }
}

- (void)buttonclicked:(UIButton *)sender {
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = RGBColor(255,132,0).CGColor;
    
    self.but.layer.borderColor = nil;
    self.but.layer.borderWidth = 0;
    
    self.but = sender;
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alwaycityClicked:cell:)]) {
        [self.delegate alwaycityClicked:sender cell:self];
    }
}

@end
