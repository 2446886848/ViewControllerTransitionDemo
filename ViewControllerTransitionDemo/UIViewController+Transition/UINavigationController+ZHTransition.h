//
//  UINavigationController+ZHTransition.h
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/19.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+ZHTransition.h"

@interface UINavigationController (ZHTransition)

/**
 *  为UINavigationController增加push转场动画，固定动画的步骤
 *
 *  @param viewController         要处理的控制器
 *  @param pushDuration           显示的时长
 *  @param pushTransitionBlock    显示动画开始时执行的操作
 *  @param pushAnimationBlock     显示动画的内容
 *  @param dismissDuration        消失动画时长
 *  @param dismissTransitionBlock 消失动画开始直行至的操作
 *  @param dismissAnimationBlock  消失动画的内容
 */
- (void)zh_addpushTransitonForViewController:(UIViewController *)viewController pushDuration:(CGFloat)pushDuration pushTransitionBlock:(ZHViewControllerAnimateTransition)pushTransitionBlock pushAnimationBlock:(ZHViewControllerAnimateTransition)pushAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock;

/**
 *  为UINavigationController增加push转场动画，自定义动画的内容
 * 
 *  @param viewController         要处理的控制器
 *  @param pushDuration           显示的时长
 *  @param pushTransitionBlock    显示动画开始时执行的操作
 *  @param dismissDuration        消失动画时长
 *  @param dismissTransitionBlock 消失动画开始直行至的操作
 */
- (void)zh_addpushTransitonForViewController:(UIViewController *)viewController pushDuration:(CGFloat)pushDuration pushTransitionBlock:(ZHViewControllerAnimateTransition)pushTransitionBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock;

@end
