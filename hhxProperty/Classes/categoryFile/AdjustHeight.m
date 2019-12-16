//
//  AdjustHeight.m
//  graduation project
//
//  Created by lanou on 16/3/25.
//  Copyright © 2016年 hehaoxian. All rights reserved.
//

#import "AdjustHeight.h"

@implementation AdjustHeight

+(CGFloat)heigthForString:(NSString *)text size:(CGSize)size font:(CGFloat)font
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    
    CGFloat heigth = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;

    CGFloat ss = [[UIScreen mainScreen] bounds].size.height;
    
    CGFloat height = ceil(heigth) + 1 + (ss == 812.0 ? 667.0/667.0 : ss/667.0) * 10;
    
    return height;
    
}

+(CGFloat)hegihtForHtml5String:(NSString *)text size:(CGSize)size font:(CGFloat)font{
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    CGRect rect = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    CGFloat htmlHight = CGRectGetHeight(rect);
    
    return htmlHight;
    
}



+(CGFloat)WidthForString:(NSString *)text size:(CGSize)size font:(CGFloat)font{
   
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    
    CGFloat width = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
    return width;

}

@end
