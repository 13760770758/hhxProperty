//
//  AdjustHeight.h
//  graduation project
//
//  Created by lanou on 16/3/25.
//  Copyright © 2016年 hehaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AdjustHeight : NSObject

+(CGFloat)heigthForString:(NSString *)text size:(CGSize)size font:(CGFloat)font;

+(CGFloat)hegihtForHtml5String:(NSString *)text size:(CGSize)size font:(CGFloat)font;

+(CGFloat)WidthForString:(NSString *)text size:(CGSize)size font:(CGFloat)font;
@end
