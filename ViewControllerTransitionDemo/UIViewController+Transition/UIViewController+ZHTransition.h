//
//  UIViewController+Transition.h
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/19.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHViewControllerAnimateTransition)(id <UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView);

typedef enum : NSUInteger {
    ZHTransitionTypeShow,
    ZHTransitionTypeDismiss,
    ZHTransitionTypeOther,
} ZHTransitionType;

#pragma mark - ZHTransitionDataSource
@interface ZHTransitionDataSource : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) ZHTransitionType transitionType;
@property (nonatomic, assign) CGFloat showDuration;
@property (nonatomic, copy) ZHViewControllerAnimateTransition showTransitionBlock;
@property (nonatomic, copy) ZHViewControllerAnimateTransition showAnimationBlock;

@property (nonatomic, assign) CGFloat dismissDuration;
@property (nonatomic, copy) ZHViewControllerAnimateTransition dismissTransitionBlock;
@property (nonatomic, copy) ZHViewControllerAnimateTransition dismissAnimationBlock;

- (instancetype)initWithShowDuration:(CGFloat)showDuration showTransitionBlock:(ZHViewControllerAnimateTransition)showTransitionBlock showAnimationBlock:(ZHViewControllerAnimateTransition)showAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock;

+ (instancetype)transitonDataSourceWithShowDuration:(CGFloat)showDuration showTransitionBlock:(ZHViewControllerAnimateTransition)showTransitionBlock showAnimationBlock:(ZHViewControllerAnimateTransition)showAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock;

@end

#pragma mark - UIViewController + ZHTransition

@interface UIViewController (ZHTransition)

/**
 *  为viewController增加present转场动画，固定动画的步骤
 *
 *  @param presentDuration           显示的时长
 *  @param presentTransitionBlock    显示动画开始时执行的操作
 *  @param presentAnimationBlock     显示动画的内容
 *  @param dismissDuration        消失动画时长
 *  @param dismissTransitionBlock 消失动画开始直行至的操作
 *  @param dismissAnimationBlock  消失动画的内容
 */
- (void)zh_addPresentTransitonWithDuration:(CGFloat)presentDuration presentTransitionBlock:(ZHViewControllerAnimateTransition)presentTransitionBlock presentAnimationBlock:(ZHViewControllerAnimateTransition)presentAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock;

/**
 *  为viewController增加present转场动画，自定义动画的内容
 *
 *  @param presentDuration           显示的时长
 *  @param presentTransitionBlock    显示动画开始时执行的操作
 *  @param dismissDuration        消失动画时长
 *  @param dismissTransitionBlock 消失动画开始直行至的操作
 */
- (void)zh_addPresentTransitonWithDuration:(CGFloat)presentDuration presentTransitionBlock:(ZHViewControllerAnimateTransition)presentTransitionBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock;

@end
