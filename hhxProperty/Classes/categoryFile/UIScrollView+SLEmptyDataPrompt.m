//
//  UIScrollView+SLEmptyDataPrompt.m
//  至尊娱乐
//
//  Created by 蜗牛 on 2017/12/24.
//  Copyright © 2017年 SnailLi. All rights reserved.
//

#import "UIScrollView+SLEmptyDataPrompt.h"

#import <objc/runtime.h>

@interface UIView (SLConstraintBasedLayoutExtensions)

/*
 与视图同样相关的约束
 */
-(NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;

@end

@interface SLWeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;

- (instancetype)initWithWeakObject:(id)object;

@end

@interface SLEmptyDataPromptView : UIView

@property (nonatomic, readonly) UIView                 *   contentView;    //内容视图
@property (nonatomic, readonly) UILabel                *   titleLabel;     //标题
@property (nonatomic, readonly) UILabel                *   detailLabel;    //描述
@property (nonatomic, readonly) UIImageView            *   imageView;      //图片
@property (nonatomic, readonly) UIButton               *   button;         //按钮
@property (nonatomic, strong)   UIView                 *   customView;     //
@property (nonatomic, strong)   UITapGestureRecognizer *   tapGesture;     //手势

@property (nonatomic, assign)   CGFloat                    verticalOffset; //垂直偏移量
@property (nonatomic, assign)   CGFloat                    verticalSpace;  //垂直空间

@property (nonatomic, assign)   BOOL                       fadeInOnDisplay;//是否淡入展出

/*
 设置约束
 */
- (void)setupConstraints;
/*
 刷新重用
 */
- (void)prepareForReuse;

@end


#pragma mark - UIScrollView+EmptyDataSet

static char const * const kEmptyDataPromptSource   =     "EmptyDataPromptSource";
static char const * const kEmptyDataPromptDelegate =     "EmptyDataPromptDelegate";
static char const * const kEmptyDataPromptView     =     "emptyDataPromptView";

#define kEmptyImageViewAnimationKey @"com.dzn.emptyDataPrompt.imageViewAnimation"

@interface UIScrollView () <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) SLEmptyDataPromptView *emptyDataPromptView;

@end

@implementation UIScrollView (SLEmptyDataPrompt)

#pragma mark - Getters (Public)

- (id<SLEmptyDataPromptSource>)EmptyDataPromptSource{
    
    SLWeakObjectContainer   *  container   =   objc_getAssociatedObject(self, kEmptyDataPromptSource);
    
    return container.weakObject;
}

- (id<SLEmptyDataPromptDelegate>)EmptyDataPromptDelegate{
    
    SLWeakObjectContainer   *  container   =   objc_getAssociatedObject(self, kEmptyDataPromptDelegate);
    
    return container.weakObject;
}

/*
 空数是否可见
 */
-(BOOL)isEmptyDataPromptVisible{
    
    UIView *view = objc_getAssociatedObject(self, kEmptyDataPromptView);
    
    return view ? !view.hidden : NO;
    
}

#pragma mark - Getters (Private)

- (SLEmptyDataPromptView *)emptyDataPromptView{
    SLEmptyDataPromptView  *  view  =  objc_getAssociatedObject(self, kEmptyDataPromptView);
    
    if (!view){
        
        view = [SLEmptyDataPromptView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SL_didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        
        [self setEmptyDataPromptView:view];
    }
    return view;
}

/*
 可以显示空数据的空间（UITableView、UICollectionView、UIScrollView）
 */
- (BOOL)SL_canDisplay{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource conformsToProtocol:@protocol(SLEmptyDataPromptSource)]) {
        
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]]) {
            
            return YES;
            
        }
    }
    
    return NO;
}

- (NSInteger)SL_itemsCount{
    NSInteger items = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView support
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView support
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    
    return items;
}

#pragma mark - Data Source Getters

/*
 标题
 如果没有设置属性，则数据集默认使用固定的字体样式。如果您想要一个不同的字体样式，请返回一个带属性的字符串。
 @ param scrollView    一个scrollView子类，通知数据源。
 @ 返回数据集标题、组合字体、文本颜色、文本pararaph样式等的带属性字符串。
 */
- (NSAttributedString *)SL_titleLabelString{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(titleForEmptyDataPrompt:)]) {
        
        NSAttributedString *string = [self.EmptyDataPromptSource titleForEmptyDataPrompt:self];
        
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"您必须返回一个有效的NSAttributedString对象，用于- titleForEmptyDataPrompt:");
        
        return string;
    }
    return nil;
}

/*
 描述
 如果没有设置属性，则数据集默认使用固定的字体样式。如果您想要一个不同的字体样式，请返回一个带属性的字符串。
 @ param scrollView  一个scrollView子类，通知数据源。
 @ 返回一个属性字符串，用于数据集描述文本、组合字体、文本颜色、文本pararaph样式等。
 */
- (NSAttributedString *)SL_detailLabelString{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(descriptionForEmptyDataPrompt:)]) {
        
        NSAttributedString *string = [self.EmptyDataPromptSource descriptionForEmptyDataPrompt:self];
        
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"您必须返回一个有效的NSAttributedString对象，用于-descriptionForEmptyDataPrompt:");
        
        return string;
    }
    return nil;
}

/*
 图像
 @ param scrollView   一个scrollView子类，通知数据源。
 @ 返回数据集的图像。
 */
- (UIImage *)SL_image{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(imageForEmptyDataPrompt:)]) {
        
        UIImage *image = [self.EmptyDataPromptSource imageForEmptyDataPrompt:self];
        
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"您必须返回一个有效的UIImage对象 用于-imageForEmptyDataPrompt:");
        
        return image;
    }
    return nil;
}

/*
 向数据源询问数据集的图像动画。
 @ param scrollView一个显示委托的scrollView子类对象。
 @ return图像动画
 */
- (CAAnimation *)SL_imageAnimation{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(imageAnimationForEmptyDataPrompt:)]) {
        
        CAAnimation *imageAnimation = [self.EmptyDataPromptSource imageAnimationForEmptyDataPrompt:self];
        
        if (imageAnimation) NSAssert([imageAnimation isKindOfClass:[CAAnimation class]], @"您必须返回一个有效的CAAnimation对象 用于-imageAnimationForEmptyDataPrompt:");
        
        return imageAnimation;
    }
    return nil;
}

/*
 请求数据源着色的图像数据集。默认是零。
 @ param scrollView一个通知数据源的scrollView子类对象。
 @ 返回一个颜色来着色数据集的图像。
 */
- (UIColor *)SL_imageTintColor{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(imageTintColorForEmptyDataPrompt:)]) {
        
        UIColor *color = [self.EmptyDataPromptSource imageTintColorForEmptyDataPrompt:self];
        
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"您必须返回一个有效的UIColor对象 用于-imageTintColorForEmptyDataPrompt:");
        
        return color;
    }
    return nil;
}

/*
 请求用于指定按钮状态的标题的数据源。
 如果没有设置属性，则数据集默认使用固定的字体样式。如果您想要一个不同的字体样式，请返回一个带属性的字符串。
 @ param scrollView一个通知数据源的scrollView子类对象。
 @ param使用指定标题的状态。在UIControlState中描述了可能的值。
 @返回数据集按钮标题的带属性字符串，组合字体、文本颜色、文本pararaph样式等。
 */
- (NSAttributedString *)SL_buttonTitleForState:(UIControlState)state{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(buttonTitleForEmptyDataPrompt:forState:)]) {
        
        NSAttributedString *string = [self.EmptyDataPromptSource buttonTitleForEmptyDataPrompt:self forState:state];
        
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"您必须返回一个有效的NSAttributedString对象 用于-buttonTitleForEmptyDataPrompt:forState:");
        
        return string;
    }
    return nil;
}

/*
 请求用于指定按钮状态的图像的数据源。
 这个方法将会覆盖buttonTitleForEmptyDataSet:forState:和现在的图像只没有任何文本。
 @ param scrollView一个通知数据源的scrollView子类对象。
 @ param使用指定标题的状态。在UIControlState中描述了可能的值。
 返回数据集按钮imageview的图像。
 */
- (UIImage *)SL_buttonImageForState:(UIControlState)state{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(buttonImageForEmptyDataPrompt:forState:)]) {
        
        UIImage *image = [self.EmptyDataPromptSource buttonImageForEmptyDataPrompt:self forState:state];
        
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"您必须返回一个有效的UIImage对象 用于-buttonImageForEmptyDataPrompt:forState:");
        
        return image;
    }
    return nil;
}

/*
 请求数据源用于指定按钮状态的背景图像。
 这个调用没有默认的样式。
 @param scrollView一个scrollView子类，通知数据源。
 使用指定映像的状态。这些值是在UIControlState中描述的。
 @返回数据集按钮标题的带属性字符串，组合字体、文本颜色、文本pararaph样式等。
 */
- (UIImage *)SL_buttonBackgroundImageForState:(UIControlState)state{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(buttonBackgroundImageForEmptyDataPrompt:forState:)]) {
        
        UIImage *image = [self.EmptyDataPromptSource buttonBackgroundImageForEmptyDataPrompt:self forState:state];
        
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"您必须返回一个有效的UIImage对象 用于-buttonBackgroundImageForEmptyDataPrompt:forState:");
        
        return image;
    }
    return nil;
}

/*
 向数据源询问数据集的背景颜色。默认是清晰的颜色。
 @param scrollView一个通知数据源的scrollView子类对象。
 将颜色返回到数据集背景视图。
 */
- (UIColor *)SL_dataSetBackgroundColor{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(backgroundColorForEmptyDataPrompt:)]) {
        
        UIColor *color = [self.EmptyDataPromptSource backgroundColorForEmptyDataPrompt:self];
        
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"您必须返回一个有效的UIColor对象 用于-backgroundColorForEmptyDataPrompt:");
        
        return color;
    }
    return [UIColor clearColor];
}

/*
 请求数据源用于显示自定义视图，而不是显示默认视图，如标签、图像视图和按钮。默认是零。
 使用此方法可以显示用于加载反馈的活动视图指示器，或用于完整的自定义空数据集。
 返回一个自定义视图将忽略-offsetForEmptyDataSet和-spaceHeightForEmptyDataSet配置。
 将一个scrollView子类对象通知委托。
 @return自定义视图。
 */
- (UIView *)SL_customView{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(customViewForEmptyDataPrompt:)]) {
        
        UIView *view = [self.EmptyDataPromptSource customViewForEmptyDataPrompt:self];
        
        if (view) NSAssert([view isKindOfClass:[UIView class]], @"您必须返回一个有效的UIView对象 用于-customViewForEmptyDataPrompt:");
        
        return view;
    }
    return nil;
}

/*
 请求数据源为内容的垂直和水平对齐偏移。默认是CGPointZero。
 将一个scrollView子类对象通知委托。
 @返回垂直和水平对齐的偏移量。
 */
- (CGFloat)SL_verticalOffset{
    CGFloat offset = 0.0;
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(verticalOffsetForEmptyDataPrompt:)]) {
        
        offset = [self.EmptyDataPromptSource verticalOffsetForEmptyDataPrompt:self];
        
    }
    return offset;
}

/*
 询问元素之间的垂直空间的数据源。默认是11分。
 将一个scrollView子类对象通知委托。
 @返回元素之间的空间高度。
 */
- (CGFloat)SL_verticalSpace{
    
    if (self.EmptyDataPromptSource && [self.EmptyDataPromptSource respondsToSelector:@selector(spaceHeightForEmptyDataPrompt:)]) {
        
        return [self.EmptyDataPromptSource spaceHeightForEmptyDataPrompt:self];
        
    }
    return 0.0;
}

#pragma mark - Delegate Getters & Events (Private)

/*
 请求委托了解空数据集是否应该在显示时淡入。默认是肯定的。
 将一个scrollView子类对象通知委托。
 如果空数据集应该淡入，则返回YES。
 */
- (BOOL)SL_shouldFadeIn {
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptShouldFadeIn:)]) {
        
        return [self.EmptyDataPromptDelegate emptyDataPromptShouldFadeIn:self];
    }
    return YES;
}

/*
 请委托了解是否应该呈现和显示空数据集。默认是肯定的。
 将一个scrollView子类对象通知委托。
 如果空数据集应该显示，则返回YES。
 */
- (BOOL)SL_shouldDisplay{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptShouldDisplay:)]) {
        
        return [self.EmptyDataPromptDelegate emptyDataPromptShouldDisplay:self];
    }
    return YES;
}

/*
 请求委托知道当项目数量大于0时是否仍然显示空数据集。默认是没有
 将一个scrollView子类对象通知委托。
 如果必须强制显示空数据集，则返回YES
 */
- (BOOL)SL_shouldBeForcedToDisplay{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptShouldBeForcedToDisplay:)]) {
        
        return [self.EmptyDataPromptDelegate emptyDataPromptShouldBeForcedToDisplay:self];
        
    }
    return NO;
}

/*
 请求获得触摸权限的委托。默认是肯定的。
 将一个scrollView子类对象通知委托。
 如果空数据集接收到触摸手势，则返回YES。
 */
- (BOOL)SL_isTouchAllowed{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptShouldAllowTouch:)]) {
        
        return [self.EmptyDataPromptDelegate emptyDataPromptShouldAllowTouch:self];
    }
    return YES;
}

/*
 请求代表滚动权限。默认是不。
 将一个scrollView子类对象通知委托。
 如果允许空数据集是可滚动的，则返回YES。
 */
- (BOOL)SL_isScrollAllowed{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptShouldAllowScroll:)]) {
        
        return [self.EmptyDataPromptDelegate emptyDataPromptShouldAllowScroll:self];
        
    }
    return NO;
}

/*
 请求图像视图动画权限的委托。默认是不。
 确保从emptyDataPromptShouldAnimateImageView返回一个有效的CAAnimation对象:
 将一个scrollView子类对象通知委托。
 如果空数据集被允许进行动画，则返回YES
 */
- (BOOL)SL_isImageViewAnimateAllowed{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptShouldAnimateImageView:)]) {
        
        return [self.EmptyDataPromptDelegate emptyDataPromptShouldAnimateImageView:self];
    }
    return NO;
}

/*
 告诉委托将显示空数据集。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)SL_willAppear{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptWillAppear:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPromptWillAppear:self];
    }
}

/*
 告诉委托所显示的空数据集。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)SL_didAppear{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptDidAppear:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPromptDidAppear:self];
    }
}

/*
 告诉委托，空数据集将消失。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)SL_willDisappear{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptWillDisappear:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPromptWillDisappear:self];
    }
}


/*
 告诉委托，空数据集确实消失了。
 @param scrollView一个scrollView子类通知委托。
 */
- (void)SL_didDisappear{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptDidDisappear:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPromptDidDisappear:self];
    }
}

/*
 告诉委托，空的dataset视图被监听了。
 使用此方法可以对textfield或searchBar进行resignFirstResponder。
 @param scrollView一个scrollView子类通知委托。
 @ param查看用户使用的视图
 */
- (void)SL_didTapContentView:(id)sender{
    
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPrompt:didTapView:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPrompt:self didTapView:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptDidTapView:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPromptDidTapView:self];
    }
#pragma clang diagnostic pop
}

- (void)SL_didTapDataButton:(id)sender
{
    if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPrompt:didTapButton:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPrompt:self didTapButton:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (self.EmptyDataPromptDelegate && [self.EmptyDataPromptDelegate respondsToSelector:@selector(emptyDataPromptDidTapButton:)]) {
        
        [self.EmptyDataPromptDelegate emptyDataPromptDidTapButton:self];
    }
#pragma clang diagnostic pop
}


#pragma mark - Setters (Public)


- (void)setEmptyDataPromptSource:(id<SLEmptyDataPromptSource>)datasource{
    
    /*
     可以显示空数据的空间（UITableView、UICollectionView、UIScrollView）
     */
    if (!datasource || ![self SL_canDisplay]) {
        
        [self SL_invalidate];
        
    }
    
    objc_setAssociatedObject(self, kEmptyDataPromptSource, [[SLWeakObjectContainer alloc] initWithWeakObject:datasource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 我们为将- SL_reloaddata实现注入到本机- reloaddata实现中，添加了一些方法
    [self swizzleIfPossible:@selector(reloadData)];
    
    // 唯一的UITableView，我们也注入 -SL_reloaddata to -endUpdates
    if ([self isKindOfClass:[UITableView class]]) {
        [self swizzleIfPossible:@selector(endUpdates)];
    }
}


- (void)setEmptyDataPromptDelegate:(id<SLEmptyDataPromptDelegate>)delegate{
    
    if (!delegate) {
        
        [self SL_invalidate];
    }
    
    objc_setAssociatedObject(self, kEmptyDataPromptDelegate, [[SLWeakObjectContainer alloc] initWithWeakObject:delegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Setters (Private)

- (void)setEmptyDataPromptView:(SLEmptyDataPromptView *)view{
    
    objc_setAssociatedObject(self, kEmptyDataPromptView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Reload APIs (Public)

- (void)reloadEmptyDataPrompt{
    
    [self SL_reloadEmptyDataPrompt];
}


#pragma mark - Reload APIs (Private)

- (void)SL_reloadEmptyDataPrompt{
    
    if (![self SL_canDisplay]) {
        return;
    }
    
    if (([self SL_shouldDisplay] && [self SL_itemsCount] == 0) || [self SL_shouldBeForcedToDisplay]){
        // Notifies that the empty dataset view will appear
        [self SL_willAppear];
        
        SLEmptyDataPromptView *view = self.emptyDataPromptView;
        
        // Configure empty dataset fade in display
        view.fadeInOnDisplay = [self SL_shouldFadeIn];
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }
            else {
                [self addSubview:view];
            }
        }
        
        // Removing view resetting the view and its constraints it very important to guarantee a good state
        [view prepareForReuse];
        
        UIView *customView = [self SL_customView];
        
        // If a non-nil custom view is available, let's configure it instead
        if (customView) {
            view.customView = customView;
        }
        else {
            // Get the data from the data source
            NSAttributedString *titleLabelString = [self SL_titleLabelString];
            NSAttributedString *detailLabelString = [self SL_detailLabelString];
            
            UIImage *buttonImage = [self SL_buttonImageForState:UIControlStateNormal];
            NSAttributedString *buttonTitle = [self SL_buttonTitleForState:UIControlStateNormal];
            
            UIImage *image = [self SL_image];
            UIColor *imageTintColor = [self SL_imageTintColor];
            UIImageRenderingMode renderingMode = imageTintColor ? UIImageRenderingModeAlwaysTemplate : UIImageRenderingModeAlwaysOriginal;
            
            view.verticalSpace = [self SL_verticalSpace];
            
            // Configure Image
            if (image) {
                if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
                    view.imageView.image = [image imageWithRenderingMode:renderingMode];
                    view.imageView.tintColor = imageTintColor;
                }
                else {
                    // iOS 6 fallback: insert code to convert imaged if needed
                    view.imageView.image = image;
                }
            }
            
            // Configure title label
            if (titleLabelString) {
                view.titleLabel.attributedText = titleLabelString;
            }
            
            // Configure detail label
            if (detailLabelString) {
                view.detailLabel.attributedText = detailLabelString;
            }
            
            // Configure button
            if (buttonImage) {
                [view.button setImage:buttonImage forState:UIControlStateNormal];
                [view.button setImage:[self SL_buttonImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
            else if (buttonTitle) {
                [view.button setAttributedTitle:buttonTitle forState:UIControlStateNormal];
                [view.button setAttributedTitle:[self SL_buttonTitleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
                [view.button setBackgroundImage:[self SL_buttonBackgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
                [view.button setBackgroundImage:[self SL_buttonBackgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
        }
        
        // Configure offset
        view.verticalOffset = [self SL_verticalOffset];
        
        // Configure the empty dataset view
        view.backgroundColor = [self SL_dataSetBackgroundColor];
        view.hidden = NO;
        view.clipsToBounds = YES;
        
        // Configure empty dataset userInteraction permission
        view.userInteractionEnabled = [self SL_isTouchAllowed];
        
        [view setupConstraints];
        
        [UIView performWithoutAnimation:^{
            [view layoutIfNeeded];
        }];
        
        // Configure scroll permission
        self.scrollEnabled = [self SL_isScrollAllowed];
        
        // Configure image view animation
        if ([self SL_isImageViewAnimateAllowed])
        {
            CAAnimation *animation = [self SL_imageAnimation];
            
            if (animation) {
                [self.emptyDataPromptView.imageView.layer addAnimation:animation forKey:kEmptyImageViewAnimationKey];
            }
        }
        else if ([self.emptyDataPromptView.imageView.layer animationForKey:kEmptyImageViewAnimationKey]) {
            [self.emptyDataPromptView.imageView.layer removeAnimationForKey:kEmptyImageViewAnimationKey];
        }
        
        // Notifies that the empty dataset view did appear
        [self SL_didAppear];
    }
    else if (self.isEmptyDataPromptVisible) {
        [self SL_invalidate];
    }
}


- (void)SL_invalidate{
    // Notifies that the empty dataset view will disappear
    [self SL_willDisappear];
    
    if (self.emptyDataPromptView) {
        [self.emptyDataPromptView prepareForReuse];
        [self.emptyDataPromptView removeFromSuperview];
        
        [self setEmptyDataPromptView:nil];
    }
    
    self.scrollEnabled = YES;
    
    // Notifies that the empty dataset view did disappear
    [self SL_didDisappear];
}


#pragma mark - Method Swizzling

static NSMutableDictionary   *             _impLookupTable;
static NSString              *    const    SLSwizzleInfoPointerKey  =  @"pointer";
static NSString              *    const    SLSwizzleInfoOwnerKey    =  @"owner";
static NSString              *    const    SLSwizzleInfoSelectorKey =  @"selector";

// Based on Bryce Buchanan's swizzling technique http://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
// And Juzzin's ideas https://github.com/juzzin/JUSEmptyViewController

void SL_original_implementation(id self, SEL _cmd){
    
    // Fetch original implementation from lookup table
    
    Class baseClass = SL_baseClassToSwizzleForTarget(self);
    NSString *key = SL_implementationKey(baseClass, _cmd);
    
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:SLSwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // We then inject the additional implementation for reloading the empty dataset
    // Doing it before calling the original implementation does update the 'isEmptyDataSetVisible' flag on time.
    [self SL_reloadEmptyDataPrompt];
    
    // If found, call original implementation
    if (impPointer) {
        
        ((void(*)(id,SEL))impPointer)(self,_cmd);
    }
}

NSString *SL_implementationKey(Class class, SEL selector){
    
    if (!class || !selector) {
        return nil;
    }
    
    NSString *className = NSStringFromClass([class class]);
    
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}

Class SL_baseClassToSwizzleForTarget(id target){
    if ([target isKindOfClass:[UITableView class]]) {
        return [UITableView class];
    }
    else if ([target isKindOfClass:[UICollectionView class]]) {
        return [UICollectionView class];
    }
    else if ([target isKindOfClass:[UIScrollView class]]) {
        return [UIScrollView class];
    }
    
    return nil;
}


- (void)swizzleIfPossible:(SEL)selector{
    // Check if the target responds to selector
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    // Create the lookup table
    if (!_impLookupTable) {
        
        _impLookupTable = [[NSMutableDictionary alloc] initWithCapacity:3]; // 3 represent the supported base classes
    }
    
    // We make sure that setImplementation is called once per class kind, UITableView or UICollectionView.
    for (NSDictionary *info in [_impLookupTable allValues]) {
        Class class = [info objectForKey:SLSwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:SLSwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    Class baseClass = SL_baseClassToSwizzleForTarget(self);
    NSString *key = SL_implementationKey(baseClass, selector);
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:SLSwizzleInfoPointerKey];
    
    // If the implementation for this class already exist, skip!!
    if (impValue || !key || !baseClass) {
        return;
    }
    
    // Swizzle by injecting additional implementation
    Method method = class_getInstanceMethod(baseClass, selector);
    IMP dzn_newImplementation = method_setImplementation(method, (IMP)SL_original_implementation);
    
    // Store the new implementation in the lookup table
    NSDictionary *swizzledInfo = @{SLSwizzleInfoOwnerKey: baseClass,
                                   SLSwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   SLSwizzleInfoPointerKey: [NSValue valueWithPointer:dzn_newImplementation]};
    
    [_impLookupTable setObject:swizzledInfo forKey:key];
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer.view isEqual:self.emptyDataPromptView]) {
        
        return [self SL_isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    UIGestureRecognizer *tapGesture = self.emptyDataPromptView.tapGesture;
    
    if ([gestureRecognizer isEqual:tapGesture] || [otherGestureRecognizer isEqual:tapGesture]) {
        
        return YES;
    }
    
    // defer to emptyDataSetDelegate's implementation if available
    if ( (self.EmptyDataPromptDelegate != (id)self) && [self.EmptyDataPromptDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [(id)self.EmptyDataPromptDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    
    return NO;
}

@end

#pragma mark - DZNEmptyDataSetView

@interface SLEmptyDataPromptView ()
@end

@implementation SLEmptyDataPromptView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

#pragma mark - Initialization Methods

- (instancetype)init
{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    CGRect superviewBounds = self.superview.bounds;
    self.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(superviewBounds), CGRectGetHeight(superviewBounds));
    
    void(^fadeInBlock)(void) = ^{self.contentView.alpha = 1.0;};
    
    if (self.fadeInOnDisplay) {
        [UIView animateWithDuration:0.25
                         animations:fadeInBlock
                         completion:NULL];
    }
    else {
        fadeInBlock();
    }
}


#pragma mark - Getters

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"empty set background image";
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
        
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        
        _detailLabel.font = [UIFont systemFontOfSize:17.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"empty set detail label";
        
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.backgroundColor = [UIColor clearColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"empty set button";
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_button];
    }
    return _button;
}

- (BOOL)canShowImage
{
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle
{
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail
{
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton
{
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil);
    }
    return NO;
}


#pragma mark - Setters

- (void)setCustomView:(UIView *)view
{
    if (!view) {
        return;
    }
    
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    SEL selector = NSSelectorFromString(@"SL_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}

- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

- (void)prepareForReuse
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
    
    [self removeAllConstraints];
}


#pragma mark - Auto-Layout Configuration

- (void)setupConstraints
{
    // First, configure the content view constaints
    // The content view must alway be centered to its superview
    NSLayoutConstraint *centerXConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *centerYConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY];
    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
    
    // When a custom offset is available, we adjust the vertical constraints' constants
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerYConstraint.constant = self.verticalOffset;
    }
    
    // If applicable, set the custom view's constraints
    if (_customView) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
    }
    else {
        CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat padding = roundf(width/16.0);
        CGFloat verticalSpace = self.verticalSpace ? : 11.0; // Default is 11 pts
        
        NSMutableArray *subviewStrings = [NSMutableArray array];
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        NSDictionary *metrics = @{@"padding": @(padding)};
        
        // Assign the image view's horizontal constraints
        if (_imageView.superview) {
            
            [subviewStrings addObject:@"imageView"];
            views[[subviewStrings lastObject]] = _imageView;
            
            [self.contentView addConstraint:[self.contentView equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }
        
        // Assign the title label's horizontal constraints
        if ([self canShowTitle]) {
            
            [subviewStrings addObject:@"titleLabel"];
            views[[subviewStrings lastObject]] = _titleLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        // Assign the detail label's horizontal constraints
        if ([self canShowDetail]) {
            
            [subviewStrings addObject:@"detailLabel"];
            views[[subviewStrings lastObject]] = _detailLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        // Assign the button's horizontal constraints
        if ([self canShowButton]) {
            
            [subviewStrings addObject:@"button"];
            views[[subviewStrings lastObject]] = _button;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[button(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_button removeFromSuperview];
            _button = nil;
        }
        
        
        NSMutableString *verticalFormat = [NSMutableString new];
        
        // Build a dynamic string format for the vertical constraints, adding a margin between each element. Default is 11 pts.
        for (int i = 0; i < subviewStrings.count; i++) {
            
            NSString *string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];
            
            if (i < subviewStrings.count-1) {
                [verticalFormat appendFormat:@"-(%.f@750)-", verticalSpace];
            }
        }
        
        // Assign the vertical constraints to the content view
        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                     options:0 metrics:metrics views:views]];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // Return any UIControl instance such as buttons, segmented controls, switches, etc.
    if ([hitView isKindOfClass:[UIControl class]]) {
        return hitView;
    }
    
    // Return either the contentView or customView
    if ([hitView isEqual:_contentView] || [hitView isEqual:_customView]) {
        return hitView;
    }
    
    return nil;
}

@end

#pragma mark - UIView+DZNConstraintBasedLayoutExtensions

@implementation UIView (DZNConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end

#pragma mark - DZNWeakObjectContainer

@implementation SLWeakObjectContainer

- (instancetype)initWithWeakObject:(id)object
{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end


