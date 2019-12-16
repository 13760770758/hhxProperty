//
//  UIImageView+BorderCorner.m
//  Management
//
//  Created by hhx on 2018/9/19.
//  Copyright © 2018年 forr. All rights reserved.
//

#import "UIImageView+BorderCorner.h"

@implementation UIImageView (BorderCorner)

- (void)setOrigalImageView{
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
}

- (void)setBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor CornerRadius:(CGFloat)cornerRadius{
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    
}

@end
