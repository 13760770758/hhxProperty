//
//  UITextField+manager.h
//  亿球成名
//
//  Created by   on 2018/2/27.
//  Copyright © 2018年 SnailLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (manager)
/*
 UITextField添加属性
 @ mode                视图模式
 @ font                字体大小
 @ color               字体颜色
 @ type                键盘类型
 @ placeholder         占位符
 */
-(void)clearButtonMode:(UITextFieldViewMode)mode andFont:(float)font andTextColor:(NSString *)color andKeyboardType:(UIKeyboardType)type andPlaceholder:(NSString *)placeholder andTextPlaceholderColor:(NSString *)placeholderColor andPlaceFont:(float)placefont;



@end
