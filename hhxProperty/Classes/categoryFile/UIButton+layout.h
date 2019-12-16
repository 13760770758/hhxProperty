//
//  UIButton+layout.h
//  MIApp
//
//  Created by ZE KANG on 16/9/21.
//  Copyright © 2016年 HongJi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};
@interface UIButton (layout)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;




- (void)setBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor CornerRadius:(CGFloat)cornerRadius;





- (void)setProperty:(UIColor *)backgroundColor title:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font ;



- (UIButton *(^)(NSString *))hhx_setTitle;

- (UIButton *(^)(UIColor *textColor))hhx_textColorBlock;

- (UIButton *(^)(UIColor *))hhx_backGroundColorBlock;

- (UIButton *(^)(UIFont *))hhx_fontBlock;

- (UIButton *(^)(NSTextAlignment))hhx_textAlignmentBlock;

- (UIButton *(^)(NSLineBreakMode))hhx_lineBreakModeBlock;

- (UIButton *(^)(UIViewContentMode))hhx_imageViewModeBlock;

- (UIButton *(^)(CGRect))hhx_frame;

- (UIButton *(^)(UIImage *))hhx_setImageNormalImage;

- (UIButton *(^)(UIImage *))hhx_selectImage;

- (UIButton *(^)(UIImage *))hhx_highlightImage;

- (UIButton *(^)(BOOL))hhx_userInteractionEnabled;

@end
