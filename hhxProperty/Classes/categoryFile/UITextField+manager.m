//
//  UITextField+manager.m
//  亿球成名
//
//  Created by   on 2018/2/27.
//  Copyright © 2018年 SnailLi. All rights reserved.
//

#import "UITextField+manager.h"
#import "UIColor+Hex.h"

NSString const *reStringKey = @"UIBarButtonItem_badgeKey";
@implementation UITextField (manager)

/*
 UITextField添加属性
 @ mode                视图模式
 @ font                字体大小
 @ color               字体颜色
 @ type                键盘类型
 @ placeholder         占位符
 */
-(void)clearButtonMode:(UITextFieldViewMode)mode andFont:(float)font andTextColor:(NSString *)color andKeyboardType:(UIKeyboardType)type andPlaceholder:(NSString *)placeholder andTextPlaceholderColor:(NSString *)placeholderColor andPlaceFont:(float)placefont{
    
    self.font=[UIFont systemFontOfSize:font];
    self.textColor=[UIColor colorWithHexStrings:color];
    self.clearButtonMode=mode;
    self.keyboardType=type;
    self.placeholder=placeholder;
    
    NSMutableAttributedString *placeholderAttr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeholderAttr addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithHexStrings:placeholderColor]
                     range:NSMakeRange(0, placeholder.length)];
    [placeholderAttr addAttribute:NSFontAttributeName
                     value:[UIFont boldSystemFontOfSize:placefont]
                     range:NSMakeRange(0, placeholder.length)];
    self.attributedPlaceholder = placeholderAttr;
   
}

@end
