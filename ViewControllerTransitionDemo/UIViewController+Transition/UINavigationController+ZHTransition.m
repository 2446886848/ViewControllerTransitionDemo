//
//  UINavigationController+ZHTransition.m
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/19.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import "UINavigationController+ZHTransition.h"
#import <objc/runtime.h>

@interface ZHPushTransitionBind : NSObject

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) ZHTransitionDataSource *pushDataSource;

- (instancetype)initWithViewController:(UIViewController *)viewController pushDataSource:(ZHTransitionDataSource *)pushDataSource;

+ (instancetype)pushTransitionBindWithViewController:(UIViewController *)viewController pushDataSource:(ZHTransitionDataSource *)pushDataSource;

@end

@implementation ZHPushTransitionBind

- (instancetype)initWithViewController:(UIViewController *)viewController pushDataSource:(ZHTransitionDataSource *)pushDataSource
{
    if (self = [super init]) {
        _viewController = viewController;
        _pushDataSource = pushDataSource;
    }
    return self;
}

+ (instancetype)pushTransitionBindWithViewController:(UIViewController *)viewController pushDataSource:(ZHTransitionDataSource *)pushDataSource
{
    return [[self alloc] initWithViewController:viewController pushDataSource:pushDataSource];
}

@end

@interface ZHPushDelegate : NSObject<UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *pushTransitonBinds;

- (void)addPushDataSource:(ZHTransitionDataSource *)dataSource forViewController:(UIViewController *)viewController;

- (void)removePushDataSourceForViewController:(UIViewController *)viewController;

@end

@implementation ZHPushDelegate

- (void)addPushDataSource:(ZHTransitionDataSource *)pushDataSource forViewController:(UIViewController *)viewController
{
    ZHPushTransitionBind *pushTransitionBind = [ZHPushTransitionBind pushTransitionBindWithViewController:viewController pushDataSource:pushDataSource];
    
    //执行清理操作
    NSMutableArray *garbageBinds = @[].mutableCopy;
    for (ZHPushTransitionBind *bind in [self pushTransitonBinds]) {
        if (!bind.viewController) {
            [garbageBinds addObject:bind];
        }
    }
    [[self pushTransitonBinds] removeObjectsInArray:garbageBinds];
    
    [[self pushTransitonBinds] addObject:pushTransitionBind];
}

- (void)removePushDataSourceForViewController:(UIViewController *)viewController
{
    NSMutableArray *viewControllerBinds = @[].mutableCopy;
    
    for (ZHPushTransitionBind *bind in [self pushTransitonBinds]) {
        if (bind.viewController == viewController) {
            [viewControllerBinds addObject:bind];
        }
    }
    [[self pushTransitonBinds] removeObjectsInArray:viewControllerBinds];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    for (ZHPushTransitionBind *pushTransitionBind in [self pushTransitonBinds]) {
        if (operation == UINavigationControllerOperationPush
             && pushTransitionBind.viewController == toVC && pushTransitionBind.pushDataSource.showTransitionBlock) {
            pushTransitionBind.pushDataSource.transitionType = ZHTransitionTypeShow;
            return pushTransitionBind.pushDataSource;
        }
        else if (operation == UINavigationControllerOperationPop
                 && pushTransitionBind.viewController == fromVC
                 && pushTransitionBind.pushDataSource.dismissTransitionBlock)
        {
            pushTransitionBind.pushDataSource.transitionType = ZHTransitionTypeDismiss;
            return pushTransitionBind.pushDataSource;
        }
    }
    return nil;
}

- (NSMutableArray *)pushTransitonBinds
{
    if (!_pushTransitonBinds) {
        _pushTransitonBinds = @[].mutableCopy;
    }
    return _pushTransitonBinds;
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
