//
//  UIView+Expand.h
//  ChatDemo-UI2.0
//
//  Created by wquzhongrensan on 15/5/24.
//  Copyright (c) 2015年 wquzhongrensan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Expand)

- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setOrigin:(CGPoint)origin;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setSize:(CGSize)size;
- (CGFloat)getEndXwith:(CGFloat)extraX;
- (CGFloat)getEndYwith:(CGFloat)extraY;
- (CGFloat)maxXOfFrame;


- (UIView *(^)(UIColor *))hhx_backgroundColor;

- (UIView *(^)(CGRect))hhx_frame;

- (UIView *(^)(BOOL))hhx_userInteractionEnabled;

@end
