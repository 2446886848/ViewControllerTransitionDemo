//
//  UIViewController+Transition.m
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/19.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import "UIViewController+ZHTransition.h"
#import <objc/runtime.h>

#pragma mark - ZHTransitionDataSource

@implementation ZHTransitionDataSource

- (instancetype)initWithShowDuration:(CGFloat)showDuration showTransitionBlock:(ZHViewControllerAnimateTransition)showTransitionBlock showAnimationBlock:(ZHViewControllerAnimateTransition)showAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock
{
    if (self = [super init]) {
        if (showDuration <= 0) {
            showDuration = [CATransaction animationDuration];
        }
        if (dismissDuration <= 0) {
            dismissDuration = [CATransaction animationDuration];
        }
        
        _showDuration = showDuration;
        _showTransitionBlock = [showTransitionBlock copy];
        _showAnimationBlock = [showAnimationBlock copy];
        _dismissDuration = dismissDuration;
        _dismissTransitionBlock = [dismissTransitionBlock copy];
        _dismissAnimationBlock = [dismissAnimationBlock copy];
    }
    return self;
}

+ (instancetype)transitonDataSourceWithShowDuration:(CGFloat)showDuration showTransitionBlock:(ZHViewControllerAnimateTransition)showTransitionBlock showAnimationBlock:(ZHViewControllerAnimateTransition)showAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock
{
    return [[self alloc] initWithShowDuration:showDuration showTransitionBlock:showTransitionBlock showAnimationBlock:showAnimationBlock dismissWithDuration:dismissDuration dismissTransitionBlock:dismissTransitionBlock dismissAnimationBlock:dismissAnimationBlock];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.transitionType) {
        case ZHTransitionTypeShow:
            return self.showDuration;
            break;
        case ZHTransitionTypeDismiss:
            return self.dismissDuration;
            break;
        default:
            break;
    }
    return 0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView = nil;
    UIView *toView = nil;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    
    if (!fromView) {
        fromView = fromVc.view;
    }
    
    if (!toView) {
        toView = toVc.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromVc];
    toView.frame = [transitionContext finalFrameForViewController:toVc];
    
    ZHViewControllerAnimateTransition transitionBlock = nil;
    ZHViewControllerAnimateTransition animationBlock = nil;
    CGFloat duration = 0;
    
    switch (self.transitionType) {
        case ZHTransitionTypeShow:
        {
            transitionBlock = [self.showTransitionBlock copy];;
            animationBlock = [self.showAnimationBlock copy];
            duration = self.showDuration;
        }
            break;
        case ZHTransitionTypeDismiss:
        {
            transitionBlock = [self.dismissTransitionBlock copy];;
            animationBlock = [self.dismissAnimationBlock copy];
            duration = self.dismissDuration;
        }
            break;
        default:
            break;
    }
    
    if (transitionBlock) {
        transitionBlock(transitionContext, containerView, fromVc, fromView, toVc, toView);
        if (animationBlock) {
            [UIView animateWithDuration:duration animations:^{
                animationBlock(transitionContext, containerView, fromVc, fromView, toVc, toView);
            } completion:^(BOOL finished) {
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                [transitionContext completeTransition:!wasCancelled];
            }];
        }
    }
}

@end

#pragma mark - ZHTransitionDelegate
@interface ZHTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ZHTransitionDataSource *transitionDataSource;

@end

#pragma mark - ZHTransitionDelegate

@implementation ZHTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transitionDataSource.transitionType = ZHTransitionTypeShow;
    if (!self.transitionDataSource.showTransitionBlock) {
        return nil;
    }
    return self.transitionDataSource;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionDataSource.transitionType = ZHTransitionTypeDismiss;
    if (!self.transitionDataSource.dismissTransitionBlock) {
        return nil;
    }
    return self.transitionDataSource;
}

@end

#pragma mark - UIViewController + ZHTransition

@implementation UIViewController (ZHTransition)

- (void)zh_addPresentTransitonWithDuration:(CGFloat)presentDuration presentTransitionBlock:(ZHViewControllerAnimateTransition)presentTransitionBlock presentAnimationBlock:(ZHViewControllerAnimateTransition)presentAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock
{
    ZHTransitionDelegate *transitionDelegate = [[ZHTransitionDelegate alloc] init];
    transitionDelegate.transitionDataSource = [ZHTransitionDataSource transitonDataSourceWithShowDuration:presentDuration showTransitionBlock:presentTransitionBlock showAnimationBlock:presentAnimationBlock dismissWithDuration:dismissDuration dismissTransitionBlock:dismissTransitionBlock dismissAnimationBlock:dismissAnimationBlock];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self setCustomTransitioningDelegate:transitionDelegate];
    self.transitioningDelegate = transitionDelegate;
}

- (void)zh_addPresentTransitonWithDuration:(CGFloat)presentDuration presentTransitionBlock:(ZHViewControllerAnimateTransition)presentTransitionBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock
{
    [self zh_addPresentTransitonWithDuration:presentDuration presentTransitionBlock:presentTransitionBlock presentAnimationBlock:nil dismissWithDuration:dismissDuration dismissTransitionBlock:dismissTransitionBlock dismissAnimationBlock:nil];
}

- (void)setCustomTransitioningDelegate:(ZHTransitionDelegate *)customTransitionDelegate
{
    objc_setAssociatedObject(self, @selector(customTransitionDelegate), customTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZHTransitionDelegate *)customTransitionDelegate
{
    return objc_getAssociatedObject(self, @selector(customTransitionDelegate));
}

@end
