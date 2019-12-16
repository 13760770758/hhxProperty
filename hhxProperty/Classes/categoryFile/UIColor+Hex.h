//
//  UIColor+Hex.h
//  Management
//
//  Created by hhx on 2018/9/5.
//  Copyright © 2018年 forr. All rights reserved.
//

#import <UIKit/UIKit.h>


#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface UIColor (Hex)

+ (UIColor *)colorWithHexStrings:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexStrings:(NSString *)color alpha:(CGFloat)alpha;

@end



