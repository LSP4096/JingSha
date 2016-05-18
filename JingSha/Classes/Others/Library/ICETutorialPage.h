//
//  ICETutorialPage.h
//  TestDemo
//
//  Created by 李里 on 14-8-20.
//  Copyright (c) 2014年  李里 www.lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ICETutorialLabelStyle : NSObject {
    NSString *_text;
    UIFont *_font;
    UIColor *_textColor;
    NSUInteger _linesNumber;
    NSUInteger _offset;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSUInteger linesNumber;
@property (nonatomic, assign) NSUInteger offset;

// Init.
- (id)initWithText:(NSString *)text;
- (id)initWithText:(NSString *)text
              font:(UIFont *)font
         textColor:(UIColor *)color;
@end

@interface ICETutorialPage : NSObject {
    ICETutorialLabelStyle *_subTitle;
    ICETutorialLabelStyle *_description;
    NSString *_pictureName;
}

@property (nonatomic, strong) ICETutorialLabelStyle *subTitle;
@property (nonatomic, strong) ICETutorialLabelStyle *description;
@property (nonatomic, copy) NSString *pictureName;

// Init.
- (id)initWithSubTitle:(NSString *)subTitle
           description:(NSString *)description
           pictureName:(NSString *)pictureName;

- (void)setSubTitleStyle:(ICETutorialLabelStyle *)style;
- (void)setDescription:(ICETutorialLabelStyle *)style;

@end

