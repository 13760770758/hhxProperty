//
//  UIView+Expand.m
//  ChatDemo-UI2.0
//
//  Created by wquzhongrensan on 15/5/24.
//  Copyright (c) 2015年 wquzhongrensan. All rights reserved.
//

#import "UIView+Expand.h"

@implementation UIView (Expand)

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

- (CGFloat)getEndXwith:(CGFloat)extraX{
    return self.frame.origin.x+self.frame.size.width+extraX;
}

- (CGFloat)getEndYwith:(CGFloat)extraY{
    return self.frame.origin.y+self.frame.size.height+extraY;
}


- (CGFloat)maxXOfFrame{
    return CGRectGetMaxX(self.frame);
}



- (UIView *(^)(UIColor *))hhx_backgroundColor
{
    return ^UIView *(UIColor *backgroundColor){
        
        self.backgroundColor = backgroundColor;
        
        return self;
    };
}


- (UIView *(^)(CGRect))hhx_frame
{
    return ^UIView *(CGRect frame){
        
        self.frame = frame;
        
        return self;
    };
}


#pragma mark - action
- (UIView *(^)(BOOL))hhx_userInteractionEnabled
{
    return ^UIView *(BOOL isEnabled){
        
        self.userInteractionEnabled = isEnabled;
        
        return self;
    };
}


@end
