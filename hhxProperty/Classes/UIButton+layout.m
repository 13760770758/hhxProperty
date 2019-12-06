//
//  UIButton+layout.m
//  MIApp
//
//  Created by ZE KANG on 16/9/21.
//  Copyright © 2016年 HongJi. All rights reserved.
//

#import "UIButton+layout.h"

@implementation UIButton (layout)

- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0; 
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case MKButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case MKButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}



- (void)setBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor CornerRadius:(CGFloat)cornerRadius{
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    
}



- (void)setProperty:(UIColor *)backgroundColor title:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font{
    if (backgroundColor != nil) {
        self.backgroundColor = backgroundColor;
    }
    
    if (title != nil) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    
    if (textColor != nil) {
        [self setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if (font > 0) {
        self.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    
    
    
}



- (UIButton *(^)(NSString *))hhx_setTitle
{
    return ^UIButton *(NSString *text){
        
        [self setTitle:text forState:UIControlStateNormal];
        
        return self;
    };
}

- (UIButton *(^)(UIColor *textColor))hhx_textColorBlock
{
    return ^UIButton *(UIColor *textColor){
        
        [self setTitleColor:textColor forState:UIControlStateNormal];
        
        return self;
    };
}

- (UIButton *(^)(UIColor *))hhx_backGroundColorBlock
{
    return ^UIButton *(UIColor *backgroundColor){
        
        self.backgroundColor = backgroundColor;
        
        return self;
    };
}


- (UIButton *(^)(UIFont *))hhx_fontBlock
{
    return ^UIButton *(UIFont *font){
        
        self.titleLabel.font = font;
        
        return self;
    };
}

- (UIButton *(^)(NSTextAlignment))hhx_textAlignmentBlock
{
    return ^UIButton *(NSTextAlignment textAlignment){
        
        self.titleLabel.textAlignment = textAlignment;
        
        return self;
    };
}

- (UIButton *(^)(NSLineBreakMode))hhx_lineBreakModeBlock
{
    return ^UIButton *(NSLineBreakMode mode){
        
        self.titleLabel.lineBreakMode = mode;
        
        return self;
    };
}

- (UIButton *(^)(UIViewContentMode))hhx_imageViewModeBlock
{
    return ^UIButton *(UIViewContentMode mode){
        
        self.imageView.contentMode = mode;
        
        return self;
    };
}

- (UIButton *(^)(CGRect))hhx_frame
{
    return ^UIButton *(CGRect frame){
        
        self.frame = frame;
        
        return self;
    };
}



- (UIButton *(^)(UIImage *))hhx_setImageNormalImage
{
    return ^UIButton *(UIImage *normalImage){
        
        [self setImage:normalImage forState:UIControlStateNormal];
        
        return self;
    };
}

- (UIButton *(^)(UIImage *))hhx_selectImage
{
    return ^UIButton *(UIImage *selectImage){
        
        [self setImage:selectImage forState:UIControlStateSelected];
        
        return self;
    };
}

- (UIButton *(^)(UIImage *))hhx_highlightImage
{
    return ^UIButton *(UIImage *selectImage){
        
        [self setImage:selectImage forState:UIControlStateHighlighted];
        
        return self;
    };
}

#pragma mark - action
- (UIButton *(^)(BOOL))hhx_userInteractionEnabled
{
    return ^UIButton *(BOOL isEnabled){
        
        self.userInteractionEnabled = isEnabled;
        
        return self;
    };
}


@end
