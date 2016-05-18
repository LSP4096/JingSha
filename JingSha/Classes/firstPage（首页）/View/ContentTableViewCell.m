//
//  ContentTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 16/1/19.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "ContentTableViewCell.h"

@interface ContentTableViewCell ()<UITextViewDelegate>


@end

@implementation ContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textview.delegate = self;
}

- (void)textViewDidChange:(MyTextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewChanged:)]) {
        [self.delegate textViewChanged:textView];
    }
}

@end
