//
//  UITextField+setProperty.m
//  hhxUsePropert
//
//  Created by hhx on 2018/12/26.
//  Copyright © 2018年 com.hhxUsePropert.bori. All rights reserved.
//

#import "UITextField+setProperty.h"
#import "UIColor+Hex.h"

@implementation UITextField (setProperty)

/*
 UITextField添加属性
 @ mode                视图模式
 @ font                字体大小
 @ color               字体颜色
 @ type                键盘类型
 @ placeholder         占位符
 */
- (void)clearButtonMode:(UITextFieldViewMode)mode andFont:(float)font andTextColor:(NSString*)color andKeyboardType:(UIKeyboardType)type andPlaceholder:(NSString*)placeholder andTextPlaceholderColor:(NSString*)placeholderColor andPlaceFont:(float)placefont
{

    self.font = [UIFont systemFontOfSize:font];
    self.textColor = [UIColor colorWithHexStrings:color];
    self.clearButtonMode = mode;
    self.keyboardType = type;
    self.placeholder = placeholder;

    NSMutableAttributedString* placeholderAttr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeholderAttr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexStrings:placeholderColor]
                            range:NSMakeRange(0, placeholder.length)];
    [placeholderAttr addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:placefont]
                            range:NSMakeRange(0, placeholder.length)];
    self.attributedPlaceholder = placeholderAttr;
}

- (UITextField *(^)(NSString *))hhx_text
{
    return ^UITextField *(NSString *text){
        
        self.text = text;
        
        return self;
    };
}

- (UITextField *(^)(NSString *))hhx_placeholder
{
    return ^UITextField *(NSString *placeholder){
        
        self.placeholder = placeholder;
        
        return self;
    };
}

- (UITextField *(^)(UIColor *textColor))hhx_textColor
{
    return ^UITextField *(UIColor *textColor){
        
        self.textColor = textColor;
        
        return self;
    };
}

- (UITextField *(^)(UIColor *))hhx_backgroundColor
{
    return ^UITextField *(UIColor *backgroundColor){
        
        self.backgroundColor = backgroundColor;
        
        return self;
    };
}

- (UITextField *(^)(UIFont *))hhx_font
{
    return ^UITextField *(UIFont *font){
        
        self.font = font;
        
        return self;
    };
}

- (UITextField *(^)(NSTextAlignment))hhx_textAlignment
{
    return ^UITextField *(NSTextAlignment textAlignment){
        
        self.textAlignment = textAlignment;
        
        return self;
    };
}

- (UITextField *(^)(UITextFieldViewMode))hhx_clearButtonMode
{
    return ^UITextField *(UITextFieldViewMode mode){
        
        self.clearButtonMode = mode;
        
        return self;
    };
}

- (UITextField *(^)(CGRect))hhx_frame
{
    return ^UITextField *(CGRect frame){
        
        self.frame = frame;
        
        return self;
    };
}

- (UITextField *(^)(UITextFieldViewMode))hhx_leftViewMode
{
    return ^UITextField *(UITextFieldViewMode mode){
        
        self.leftViewMode = mode;
        
        return self;
    };
}

- (UITextField *(^)(UITextFieldViewMode))hhx_rightViewMode
{
    return ^UITextField *(UITextFieldViewMode mode){
        
        self.rightViewMode = mode;
        
        return self;
    };
}

- (UITextField *(^)(UIView *))hhx_leftView
{
    return ^UITextField *(UIView *leftView){
        
        self.leftView = leftView;
        
        return self;
    };
}

- (UITextField *(^)(UIView *))hhx_rightView
{
    return ^UITextField *(UIView *rightView){
        
        self.rightView = rightView;
        
        return self;
    };
}

- (UITextField *(^)(CGFloat))hhx_cornerRadius
{
    return ^UITextField *(CGFloat cornerRadius){
        
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        
        return self;
    };
}

@end
