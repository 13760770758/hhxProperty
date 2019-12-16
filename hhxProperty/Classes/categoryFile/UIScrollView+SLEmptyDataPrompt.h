//
//  UIScrollView+SLEmptyDataPrompt.h
//  至尊娱乐
//
//  Created by 蜗牛 on 2017/12/24.
//  Copyright © 2017年 SnailLi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLEmptyDataPromptSource;
@protocol SLEmptyDataPromptDelegate;

#define DZNEmptyDataSetDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

@interface UIScrollView (SLEmptyDataPrompt)

/*
 空数据集数据源
 */
@property (nonatomic, strong)  id <SLEmptyDataPromptSource> EmptyDataPromptSource;
/*
 空数据代理
 */
@property (nonatomic, strong) id <SLEmptyDataPromptDelegate> EmptyDataPromptDelegate;

/*
 空数是否可见
 */
@property (nonatomic, readonly, getter = isEmptyDataPromptVisible) BOOL EmptyDataPromptVisible;

/*
 重新加载空数据集内容接收器。
 讨论调用此方法强制所有数据刷新。调用- reloaddata是相似的，但这只会使空数据集重新加载，而不是整个表视图或集合视图。
 */
-(void)reloadEmptyDataPrompt;

@end


/*
 作为空数据集的数据源的对象。
 数据源必须采用SLEmptyDataPromptSource协议。不保留数据源。所有的数据源方法都是可选的。
 */
@protocol SLEmptyDataPromptSource <NSObject>
@optional

/*
 标题
 如果没有设置属性，则数据集默认使用固定的字体样式。如果您想要一个不同的字体样式，请返回一个带属性的字符串。
 @ param scrollView    一个scrollView子类，通知数据源。
 @ 返回数据集标题、组合字体、文本颜色、文本pararaph样式等的带属性字符串。
 */
-(nullable NSAttributedString *)titleForEmptyDataPrompt:(UIScrollView *)scrollView;


/*
 描述
 如果没有设置属性，则数据集默认使用固定的字体样式。如果您想要一个不同的字体样式，请返回一个带属性的字符串。
 @ param scrollView  一个scrollView子类，通知数据源。
 @ 返回一个属性字符串，用于数据集描述文本、组合字体、文本颜色、文本pararaph样式等。
 */
-(nullable NSAttributedString *)descriptionForEmptyDataPrompt:(UIScrollView *)scrollView;

/*
 图像
 @ param scrollView   一个scrollView子类，通知数据源。
 @ 返回数据集的图像。
 */
-(nullable UIImage *)imageForEmptyDataPrompt:(UIScrollView *)scrollView;


/*
 请求数据源着色的图像数据集。默认是零。
 @ param scrollView一个通知数据源的scrollView子类对象。
 @ 返回一个颜色来着色数据集的图像。
 */
-(nullable UIColor *)imageTintColorForEmptyDataPrompt:(UIScrollView *)scrollView;

/*
 向数据源询问数据集的图像动画。
 @ param scrollView一个显示委托的scrollView子类对象。
 @ return图像动画
 */
-(nullable CAAnimation *)imageAnimationForEmptyDataPrompt:(UIScrollView *)scrollView;

/*
 请求用于指定按钮状态的标题的数据源。
 如果没有设置属性，则数据集默认使用固定的字体样式。如果您想要一个不同的字体样式，请返回一个带属性的字符串。
 @ param scrollView一个通知数据源的scrollView子类对象。
 @ param使用指定标题的状态。在UIControlState中描述了可能的值。
 @返回数据集按钮标题的带属性字符串，组合字体、文本颜色、文本pararaph样式等。
 */
-(nullable NSAttributedString *)buttonTitleForEmptyDataPrompt:(UIScrollView *)scrollView forState:(UIControlState)state;

/*
 请求用于指定按钮状态的图像的数据源。
 这个方法将会覆盖buttonTitleForEmptyDataSet:forState:和现在的图像只没有任何文本。
 @ param scrollView一个通知数据源的scrollView子类对象。
 @ param使用指定标题的状态。在UIControlState中描述了可能的值。
 返回数据集按钮imageview的图像。
 */
- (nullable UIImage *)buttonImageForEmptyDataPrompt:(UIScrollView *)scrollView forState:(UIControlState)state;

/*
 请求数据源用于指定按钮状态的背景图像。
 这个调用没有默认的样式。
 @param scrollView一个scrollView子类，通知数据源。
 使用指定映像的状态。这些值是在UIControlState中描述的。
 @返回数据集按钮标题的带属性字符串，组合字体、文本颜色、文本pararaph样式等。
 */
- (nullable UIImage *)buttonBackgroundImageForEmptyDataPrompt:(UIScrollView *)scrollView forState:(UIControlState)state;

/*
 向数据源询问数据集的背景颜色。默认是清晰的颜色。
 @param scrollView一个通知数据源的scrollView子类对象。
 将颜色返回到数据集背景视图。
 */
- (nullable UIColor *)backgroundColorForEmptyDataPrompt:(UIScrollView *)scrollView;

/*
 请求数据源用于显示自定义视图，而不是显示默认视图，如标签、图像视图和按钮。默认是零。
 使用此方法可以显示用于加载反馈的活动视图指示器，或用于完整的自定义空数据集。
 返回一个自定义视图将忽略-offsetForEmptyDataSet和-spaceHeightForEmptyDataSet配置。
 将一个scrollView子类对象通知委托。
 @return自定义视图。
 */
- (nullable UIView *)customViewForEmptyDataPrompt:(UIScrollView *)scrollView;

/*
 请求数据源为内容的垂直和水平对齐偏移。默认是CGPointZero。
 将一个scrollView子类对象通知委托。
 @返回垂直和水平对齐的偏移量。
 */
- (CGPoint)offsetForEmptyDataPrompt:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-verticalOffsetForEmptyDataPrompt:);
- (CGFloat)verticalOffsetForEmptyDataPrompt:(UIScrollView *)scrollView;

/*
 询问元素之间的垂直空间的数据源。默认是11分。
 将一个scrollView子类对象通知委托。
 @返回元素之间的空间高度。
 */
- (CGFloat)spaceHeightForEmptyDataPrompt:(UIScrollView *)scrollView;

@end


/*
 作为空数据集的委托的对象。
 委托可以采用SLEmptyDataPromptDelegate协议。委托未被保留。所有委托方法都是可选的。
 所有委托方法都是可选的。使用此委托来接收动作回调。
 */
@protocol SLEmptyDataPromptDelegate <NSObject>
@optional

/*
 请求委托了解空数据集是否应该在显示时淡入。默认是肯定的。
 将一个scrollView子类对象通知委托。
 如果空数据集应该淡入，则返回YES。
 */
- (BOOL)emptyDataPromptShouldFadeIn:(UIScrollView *)scrollView;

/*
 请求委托知道当项目数量大于0时是否仍然显示空数据集。默认是没有
 将一个scrollView子类对象通知委托。
 如果必须强制显示空数据集，则返回YES
 */
- (BOOL)emptyDataPromptShouldBeForcedToDisplay:(UIScrollView *)scrollView;

/*
 请委托了解是否应该呈现和显示空数据集。默认是肯定的。
 将一个scrollView子类对象通知委托。
 如果空数据集应该显示，则返回YES。
 */
- (BOOL)emptyDataPromptShouldDisplay:(UIScrollView *)scrollView;

/*
 请求获得触摸权限的委托。默认是肯定的。
 将一个scrollView子类对象通知委托。
 如果空数据集接收到触摸手势，则返回YES。
 */
- (BOOL)emptyDataPromptShouldAllowTouch:(UIScrollView *)scrollView;

/*
 请求代表滚动权限。默认是不。
 将一个scrollView子类对象通知委托。
 如果允许空数据集是可滚动的，则返回YES。
 */
- (BOOL)emptyDataPromptShouldAllowScroll:(UIScrollView *)scrollView;

/*
 请求图像视图动画权限的委托。默认是不。
 确保从emptyDataPromptShouldAnimateImageView返回一个有效的CAAnimation对象:
 将一个scrollView子类对象通知委托。
 如果空数据集被允许进行动画，则返回YES
 */
- (BOOL)emptyDataPromptShouldAnimateImageView:(UIScrollView *)scrollView;

/*
 告诉委托，空的dataset视图被监听了。
 使用此方法可以对textfield或searchBar进行resignFirstResponder。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)emptyDataPromptDidTapView:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataPrompt:didTapView:);

/*
 告诉委托，操作按钮被选中。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)emptyDataPromptDidTapButton:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataPrompt:didTapButton:);

/*
 告诉委托，空的dataset视图被监听了。
 使用此方法可以对textfield或searchBar进行resignFirstResponder。
 @param scrollView一个scrollView子类通知委托。
 @ param查看用户使用的视图
 */
- (void)emptyDataPrompt:(UIScrollView *)scrollView didTapView:(UIView *)view;

/*
 告诉委托，操作按钮被选中。
 @param scrollView一个scrollView子类通知委托。
 @ param按钮由用户点击的按钮
 */
- (void)emptyDataPrompt:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

/*
 告诉委托将显示空数据集。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)emptyDataPromptWillAppear:(UIScrollView *)scrollView;

/*
 告诉委托所显示的空数据集。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)emptyDataPromptDidAppear:(UIScrollView *)scrollView;

/*
 告诉委托，空数据集将消失。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)emptyDataPromptWillDisappear:(UIScrollView *)scrollView;

/*
 告诉委托，空数据集确实消失了。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)emptyDataPromptDidDisappear:(UIScrollView *)scrollView;






@end

#undef DZNEmptyDataSetDeprecated

NS_ASSUME_NONNULL_END
