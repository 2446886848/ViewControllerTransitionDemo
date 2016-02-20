//
//  ViewController.m
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/19.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import "PresentViewController.h"
#import "SecondViewController.h"
#import "UIViewController+ZHTransition.h"

@interface PresentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PresentViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
#pragma mark - tabledelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"界面缩放";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"界面渐变";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"界面翻转";
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    }
    cell.imageView.image = [UIImage imageNamed:@"1.jpg"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self scalePresention];
    }
    else if(indexPath.row == 1)
    {
        [self fadePresention];
    }
    else if (indexPath.row == 2)
    {
        [self flipPresention];
    }
}

#pragma mark - private method
- (UIImageView *)selectedImageView
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    if (cell) {
        return cell.imageView;
    }
    return nil;
}

- (void)scalePresention
{
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    
    CGFloat presentDuration = 1.0;
    CGFloat dismissDuration = 1.0;
    [secondVc zh_addPresentTransitonWithDuration:presentDuration presentTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        
        [containerView addSubview:toView];
        
        //备注：系统默认处理方式的fromVc为导航控制器
        fromVc = [(UINavigationController *)fromVc topViewController];
        fromView = fromVc.view;
        
        UIImageView *fromImageView = [(PresentViewController *)fromVc selectedImageView];
        UIView *fromImageSnapshotView = [fromImageView snapshotViewAfterScreenUpdates:NO];
        
        fromImageSnapshotView.frame = [containerView convertRect:fromImageView.frame fromView:fromImageView.superview];
        [containerView addSubview:fromImageSnapshotView];
        
        UIImageView *toImageView = [(SecondViewController *)toVc imageView];
        
        fromView.alpha = 1.0f;
        toView.alpha = 0.0f;
        fromImageView.hidden = YES;
        toImageView.hidden = YES;
        
        [UIView animateWithDuration:presentDuration animations:^{
            fromImageSnapshotView.frame = [containerView convertRect:toImageView.frame fromView:toImageView.superview];
            fromView.alpha = 0.0;
            toView.alpha = 1.0;
        } completion:^(BOOL finished) {
            fromView.alpha = 1.0;
            fromImageView.hidden = NO;
            toImageView.hidden = NO;
            [fromImageSnapshotView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } dismissWithDuration:dismissDuration dismissTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        
        [containerView addSubview:toView];
        
        UIImageView *selectedImageView = [(PresentViewController *)[(UINavigationController *)toVc topViewController] selectedImageView];
        
        UIImageView *fromImageView = [(SecondViewController *)fromVc imageView];
        UIView *fromSnapshotView = [fromImageView snapshotViewAfterScreenUpdates:NO];
        
        fromSnapshotView.frame = [containerView convertRect:fromImageView.frame toView:fromImageView.superview];
        [containerView addSubview:fromSnapshotView];
        
        fromImageView.hidden = YES;
        selectedImageView.hidden = YES;
        fromView.alpha = 1.0;
        toView.alpha = 0.0;
        [UIView animateWithDuration:dismissDuration animations:^{
            fromView.alpha = 0;
            toView.alpha = 1.0;
            fromSnapshotView.frame = [containerView convertRect:selectedImageView.frame fromView:selectedImageView.superview];;
        } completion:^(BOOL finished) {
            fromImageView.hidden = NO;
            selectedImageView.hidden = NO;
            [fromSnapshotView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
    
    [self presentViewController:secondVc animated:YES completion:nil];
}

- (void)fadePresention
{
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    CGFloat presentDuration = 1.0;
    CGFloat dismissDuration = 1.0;
    
    [secondVc zh_addPresentTransitonWithDuration:presentDuration presentTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        [containerView addSubview:toView];
        
        fromView.alpha = 1.0;
        toView.alpha = 0.0;
    } presentAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        fromView.alpha = 0;
        toView.alpha = 1.0;
    } dismissWithDuration:dismissDuration dismissTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        [containerView addSubview:toView];
        fromView.alpha = 1.0;
        toView.alpha = 0;
    } dismissAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        fromView.alpha = 0.0;
        toView.alpha = 1.0;
    }];
    
    [self presentViewController:secondVc animated:YES completion:nil];
}

- (void)flipPresention
{
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    CGFloat presentDuration = 2.0;
    CGFloat dismissDuration = 1.0;
    
    [secondVc zh_addPresentTransitonWithDuration:presentDuration presentTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        
        [containerView addSubview:toView];
        
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, NO, [UIScreen mainScreen].scale);
        [fromView drawViewHierarchyInRect:fromView.bounds afterScreenUpdates:NO];
        UIImage *fromViewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(toView.bounds.size, NO, [UIScreen mainScreen].scale);
        [toView drawViewHierarchyInRect:toView.bounds afterScreenUpdates:YES];
        UIImage *toViewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        fromView.hidden = YES;
        toView.hidden = YES;
        containerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *flipImageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        flipImageView.image = fromViewImage;
        [containerView addSubview:flipImageView];

        CGFloat dispatchAfterTime = 0.01;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchAfterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:flipImageView duration:presentDuration - dispatchAfterTime options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                flipImageView.image = toViewImage;
            } completion:^(BOOL finished) {
                [flipImageView removeFromSuperview];
                fromView.hidden = NO;
                toView.hidden = NO;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        });
    } dismissWithDuration:dismissDuration dismissTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        
        [containerView addSubview:toView];
        
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, NO, [UIScreen mainScreen].scale);
        [fromView drawViewHierarchyInRect:fromView.bounds afterScreenUpdates:NO];
        UIImage *fromViewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(toView.bounds.size, NO, [UIScreen mainScreen].scale);
        [toView drawViewHierarchyInRect:toView.bounds afterScreenUpdates:YES];
        UIImage *toViewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        fromView.hidden = YES;
        toView.hidden = YES;
        containerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *flipImageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        flipImageView.image = fromViewImage;
        [containerView addSubview:flipImageView];
        
        CGFloat dispatchAfterTime = 0.01;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchAfterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:flipImageView duration:presentDuration - dispatchAfterTime options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                flipImageView.image = toViewImage;
            } completion:^(BOOL finished) {
                [flipImageView removeFromSuperview];
                fromView.hidden = NO;
                toView.hidden = NO;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        });
    }];
    
    [self presentViewController:secondVc animated:YES completion:nil];
}

#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark - private mehod

- (void)backButtonClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
