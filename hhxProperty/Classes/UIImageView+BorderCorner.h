//
//  UIImageView+BorderCorner.h
//  Management
//
//  Created by hhx on 2018/9/19.
//  Copyright © 2018年 forr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BorderCorner)

/**
 *  圆角
 */
- (void)setBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor CornerRadius:(CGFloat)cornerRadius;

/**
 *  设置源图片
 */
- (void)setOrigalImageView;

@end
