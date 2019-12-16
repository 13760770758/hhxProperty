//
//  UITextView+setProperty.m
//  hhxUsePropert
//
//  Created by hhx on 2018/12/26.
//  Copyright © 2018年 com.hhxUsePropert.bori. All rights reserved.
//

#import "UITextView+setProperty.h"

@implementation UITextView (setProperty)

- (UITextView *(^)(NSString *))hhx_text
{
    return ^UITextView *(NSString *text){
        
        self.text = text;
        
        return self;
    };
}


- (UITextView *(^)(UIColor *textColor))hhx_textColor
{
    return ^UITextView *(UIColor *textColor){
        
        self.textColor = textColor;
        
        return self;
    };
}

- (UITextView *(^)(UIColor *))hhx_backgroundColor
{
    return ^UITextView *(UIColor *backgroundColor){
        
        self.backgroundColor = backgroundColor;
        
        return self;
    };
}

- (UITextView *(^)(UIFont *))hhx_font
{
    return ^UITextView *(UIFont *font){
        
        self.font = font;
        
        return self;
    };
}


- (UITextView *(^)(CGRect))hhx_frame
{
    return ^UITextView *(CGRect frame){
        
        self.frame = frame;
        
        return self;
    };
}


- (UITextView *(^)(CGFloat))hhx_cornerRadius
{
    return ^UITextView *(CGFloat cornerRadius){
        
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        
        return self;
    };
}


@end
