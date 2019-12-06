//
//  UILabel+setProperty.h
//  RebateMall
//
//  Created by ZE KANG on 16/11/12.
//  Copyright © 2016年 hehaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (setProperty)

- (void)setProperty:(UIColor *)backgroundColor font:(CGFloat)font textColor:(UIColor *)textColor;

- (void)setProperty:(UIColor *)backgroundColor Bigfont:(CGFloat)bigfont textColor:(UIColor *)textColor;

- (void)setProperty:(UIColor *)backgroundColor Midfont:(CGFloat)bigfont textColor:(UIColor *)textColor;

- (void)setBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor CornerRadius:(CGFloat)cornerRadius;

- (UILabel *(^)(NSString *))hhx_text;

- (UILabel *(^)(UIColor *textColor))hhx_textColor;

- (UILabel *(^)(UIColor *))hhx_backgroundColor;

- (UILabel *(^)(UIFont *))hhx_font;

- (UILabel *(^)(NSTextAlignment))hhx_textAlignment;

- (UILabel *(^)(CGRect))hhx_frame;

- (UILabel *(^)(BOOL))hhx_userInteractionEnabled;

@end
