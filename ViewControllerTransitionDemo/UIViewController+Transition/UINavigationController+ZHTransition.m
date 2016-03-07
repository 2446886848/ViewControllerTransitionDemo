//
//  UINavigationController+ZHTransition.m
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/19.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import "UINavigationController+ZHTransition.h"
#import <objc/runtime.h>

@interface ZHPushDelegate : NSObject<UINavigationControllerDelegate>

@property (nonatomic, strong) NSMapTable *pushTransitonMapTable;

- (void)addPushDataSource:(ZHTransitionDataSource *)dataSource forViewController:(UIViewController *)viewController;

- (void)removePushDataSourceForViewController:(UIViewController *)viewController;

@end

@implementation ZHPushDelegate

- (void)addPushDataSource:(ZHTransitionDataSource *)pushDataSource forViewController:(UIViewController *)viewController
{
    [self.pushTransitonMapTable setObject:pushDataSource forKey:viewController];
}

- (void)removePushDataSourceForViewController:(UIViewController *)viewController
{
    [self.pushTransitonMapTable removeObjectForKey:viewController];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    ZHTransitionDataSource *dataSource = nil;
    
    if (operation == UINavigationControllerOperationPush)
    {
        dataSource = [self.pushTransitonMapTable objectForKey:toVC];
        if (dataSource && dataSource.showTransitionBlock) {
            dataSource.transitionType = ZHTransitionTypeShow;
            return dataSource;
        }
    }
    else if (operation == UINavigationControllerOperationPop)
    {
        dataSource = [self.pushTransitonMapTable objectForKey:fromVC];
        if (dataSource && dataSource.dismissTransitionBlock) {
            dataSource.transitionType = ZHTransitionTypeDismiss;
            return dataSource;
        }
    }
    return nil;
}

- (NSMapTable *)pushTransitonMapTable
{
    if (!_pushTransitonMapTable) {
        _pushTransitonMapTable = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _pushTransitonMapTable;
}

@end

@implementation UINavigationController (ZHTransition)

- (void)zh_addPushTransitonForViewController:(UIViewController *)viewController pushDuration:(CGFloat)pushDuration pushTransitionBlock:(ZHViewControllerAnimateTransition)pushTransitionBlock pushAnimationBlock:(ZHViewControllerAnimateTransition)pushAnimationBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock dismissAnimationBlock:(ZHViewControllerAnimateTransition)dismissAnimationBlock
{
    ZHPushDelegate *pushDelegate = [self pushDelegate];
    ZHTransitionDataSource *pushDataSource = [ZHTransitionDataSource transitonDataSourceWithShowDuration:pushDuration showTransitionBlock:pushTransitionBlock showAnimationBlock:pushAnimationBlock dismissWithDuration:dismissDuration dismissTransitionBlock:dismissTransitionBlock dismissAnimationBlock:dismissAnimationBlock];
    
    [pushDelegate addPushDataSource:pushDataSource forViewController:viewController];
    self.delegate = pushDelegate;
}

- (void)zh_addPushTransitonForViewController:(UIViewController *)viewController pushDuration:(CGFloat)pushDuration pushTransitionBlock:(ZHViewControllerAnimateTransition)pushTransitionBlock dismissWithDuration:(CGFloat)dismissDuration dismissTransitionBlock:(ZHViewControllerAnimateTransition)dismissTransitionBlock
{
    [self zh_addPushTransitonForViewController:viewController pushDuration:pushDuration pushTransitionBlock:pushTransitionBlock pushAnimationBlock:nil dismissWithDuration:dismissDuration dismissTransitionBlock:dismissTransitionBlock dismissAnimationBlock:nil];
}

- (void)zh_removePushTransitonForViewController:(UIViewController *)viewController
{
    [[self pushDelegate] removePushDataSourceForViewController:viewController];
}

- (void)setPushDelegate:(ZHPushDelegate *)pushDelegate
{
    objc_setAssociatedObject(self, @selector(pushDelegate), pushDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZHPushDelegate *)pushDelegate
{
    ZHPushDelegate *pushDelegate = objc_getAssociatedObject(self, @selector(pushDelegate));
    if (!pushDelegate) {
        pushDelegate = [[ZHPushDelegate alloc] init];
        [self setPushDelegate:pushDelegate];
    }
    return pushDelegate;
}

@end
