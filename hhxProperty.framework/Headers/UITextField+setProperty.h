//
//  UITextField+setProperty.h
//  hhxUsePropert
//
//  Created by hhx on 2018/12/26.
//  Copyright © 2018年 com.hhxUsePropert.bori. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (setProperty)

/*
 UITextField添加属性
 @ mode                视图模式
 @ font                字体大小
 @ color               字体颜色
 @ type                键盘类型
 @ placeholder         占位符
 */
- (void)clearButtonMode:(UITextFieldViewMode)mode andFont:(float)font andTextColor:(NSString*)color andKeyboardType:(UIKeyboardType)type andPlaceholder:(NSString*)placeholder andTextPlaceholderColor:(NSString*)placeholderColor andPlaceFont:(float)placefont;

- (UITextField *(^)(NSString *))hhx_text;

- (UITextField *(^)(NSString *))hhx_placeholder;

- (UITextField *(^)(UIColor *textColor))hhx_textColor;

- (UITextField *(^)(UIColor *))hhx_backgroundColor;

- (UITextField *(^)(UIFont *))hhx_font;

- (UITextField *(^)(NSTextAlignment))hhx_textAlignment;

- (UITextField *(^)(UITextFieldViewMode))hhx_clearButtonMode;

- (UITextField *(^)(CGRect))hhx_frame;

- (UITextField *(^)(UITextFieldViewMode))hhx_leftViewMode;

- (UITextField *(^)(UITextFieldViewMode))hhx_rightViewMode;

- (UITextField *(^)(UIView *))hhx_leftView;

- (UITextField *(^)(UIView *))hhx_rightView;

- (UITextField *(^)(CGFloat))hhx_cornerRadius;

@end

NS_ASSUME_NONNULL_END
