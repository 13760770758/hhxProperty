//
//  UIButton+manager.m
//  亿球成名
//
//  Created by 蜗牛 on 2018/2/24.
//  Copyright © 2018年 SnailLi. All rights reserved.
//

#import "UIButton+manager.h"

#import <objc/runtime.h>

typedef void(^SL_ButtonEventsBlock)(void);


@interface UIButton ()

/** 事件回调的block */
@property (nonatomic, copy) SL_ButtonEventsBlock SL_buttonEventsBlock;

@end

@implementation UIButton (manager)

//------- 添加属性 -------//

static void *SL_buttonEventsBlockKey = &SL_buttonEventsBlockKey;

- (SL_ButtonEventsBlock)SL_buttonEventsBlock {
    return objc_getAssociatedObject(self, &SL_buttonEventsBlockKey);
}

//- (void)setSL_buttonEventsBlock:(CQ_ButtonEventsBlock)cq_buttonEventsBlock {
//    objc_setAssociatedObject(self, &cq_buttonEventsBlockKey, cq_buttonEventsBlock, OBJC_ASSOCIATION_COPY);
//}

-(void)setSL_buttonEventsBlock:(SL_ButtonEventsBlock)SL_buttonEventsBlock{
    
    objc_setAssociatedObject(self, &SL_buttonEventsBlockKey, SL_buttonEventsBlock, OBJC_ASSOCIATION_COPY);
    
    
}

/**
 给按钮绑定事件回调block
 
 @param block 回调的block
 @param controlEvents 回调block的事件
 */
- (void)SL_addEventHandler:(void (^)(void))block forControlEvents:(UIControlEvents)controlEvents {
    self.SL_buttonEventsBlock = block;
    [self addTarget:self action:@selector(SL_blcokButtonClicked) forControlEvents:controlEvents];
}

// 按钮点击
- (void)SL_blcokButtonClicked {
    !self.SL_buttonEventsBlock ?: self.SL_buttonEventsBlock();
}



@end
