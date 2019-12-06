//
//  UITextView+setProperty.h
//  hhxUsePropert
//
//  Created by hhx on 2018/12/26.
//  Copyright © 2018年 com.hhxUsePropert.bori. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (setProperty)

- (UITextView *(^)(NSString *))hhx_text;

- (UITextView *(^)(UIColor *textColor))hhx_textColor;

- (UITextView *(^)(UIColor *))hhx_backgroundColor;

- (UITextView *(^)(UIFont *))hhx_font;

- (UITextView *(^)(CGRect))hhx_frame;

- (UITextView *(^)(CGFloat))hhx_cornerRadius;

@end

NS_ASSUME_NONNULL_END
