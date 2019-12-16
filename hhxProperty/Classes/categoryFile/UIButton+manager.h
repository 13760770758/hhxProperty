//
//  UIButton+manager.h
//  亿球成名
//
//  Created by 蜗牛 on 2018/2/24.
//  Copyright © 2018年 SnailLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (manager)

/**
 给按钮绑定事件回调block
 
 @param block 回调的block
 @param controlEvents 回调block的事件
 */
- (void)SL_addEventHandler:(void(^)(void))block forControlEvents:(UIControlEvents)controlEvents;



@end
