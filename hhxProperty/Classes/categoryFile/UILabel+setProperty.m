//
//  UILabel+setProperty.m
//  RebateMall
//
//  Created by ZE KANG on 16/11/12.
//  Copyright © 2016年 hehaoxian. All rights reserved.
//

#import "UILabel+setProperty.h"

@implementation UILabel (setProperty)



- (void)setProperty:(UIColor *)backgroundColor font:(CGFloat)font textColor:(UIColor *)textColor{
    if (backgroundColor != nil) {
        self.backgroundColor = backgroundColor;
    }
    if (font > 0) {
        self.font = [UIFont systemFontOfSize:font];
    }
    if (textColor != nil) {
        self.textColor = textColor;
    }
    
}



- (void)setProperty:(UIColor *)backgroundColor Bigfont:(CGFloat)bigfont textColor:(UIColor *)textColor{
    if (backgroundColor != nil) {
        self.backgroundColor = backgroundColor;
    }
    if (bigfont > 0) {
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:bigfont];
    }
    if (textColor != nil) {
        self.textColor = textColor;
    }
    
}


- (void)setProperty:(UIColor *)backgroundColor Midfont:(CGFloat)bigfont textColor:(UIColor *)textColor{
    if (backgroundColor != nil) {
        self.backgroundColor = backgroundColor;
    }
    if (bigfont > 0) {
        self.font = [UIFont fontWithName:@"AppleGothic" size:bigfont];
    }
    if (textColor != nil) {
        self.textColor = textColor;
    }
    
}

- (void)setBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor CornerRadius:(CGFloat)cornerRadius{
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    
}



- (UILabel *(^)(NSString *))hhx_text
{
    return ^UILabel *(NSString *text){
        
        self.text = text;
        
        return self;
    };
}

- (UILabel *(^)(UIColor *textColor))hhx_textColor
{
    return ^UILabel *(UIColor *textColor){
        
        self.textColor = textColor;
        
        return self;
    };
}

- (UILabel *(^)(UIColor *))hhx_backgroundColor
{
    return ^UILabel *(UIColor *backgroundColor){
        
        self.backgroundColor = backgroundColor;
        
        return self;
    };
}

- (UILabel *(^)(UIFont *))hhx_font
{
    return ^UILabel *(UIFont *font){
        
        self.font = font;
        
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment))hhx_textAlignment
{
    return ^UILabel *(NSTextAlignment textAlignment){
        
        self.textAlignment = textAlignment;
        
        return self;
    };
}

- (UILabel *(^)(CGRect))hhx_frame
{
    return ^UILabel *(CGRect frame){
        
        self.frame = frame;
        
        return self;
    };
}


#pragma mark - action
- (UILabel *(^)(BOOL))hhx_userInteractionEnabled
{
    return ^UILabel *(BOOL isEnabled){
        
        self.userInteractionEnabled = isEnabled;
        
        return self;
    };
}

@end
