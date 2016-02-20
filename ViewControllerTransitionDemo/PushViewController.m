//
//  PushViewController.m
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/20.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import "PushViewController.h"
#import "SecondViewController.h"
#import "UINavigationController+ZHTransition.h"

@interface PushViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PushViewController


#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
     [self.view addSubview:self.tableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
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
        cell.textLabel.text = @"正常Push";
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
        [self normalPresention];
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
- (void)normalPresention
{
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVc animated:YES];
}
- (void)fadePresention
{
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    
    [self.navigationController zh_addpushTransitonForViewController:secondVc pushDuration:1.0 pushTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        containerView.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:toView];
        fromView.alpha = 1.0;
        toView.alpha = 0.0;
    } pushAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        fromView.alpha = 0.0;
        toView.alpha = 1.0;
    } dismissWithDuration:1.0 dismissTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        [containerView addSubview:toView];
        fromView.alpha = 1.0;
        toView.alpha = 0.0;
    } dismissAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        fromView.alpha = 0.0;
        toView.alpha = 1.0;
    }];
    [self.navigationController pushViewController:secondVc animated:YES];
}
- (void)flipPresention
{
    SecondViewController *secondVc = [[SecondViewController alloc] init];
    
    __block UIColor *superViewBackgroundColor = nil;
    [self.navigationController zh_addpushTransitonForViewController:secondVc pushDuration:1.0 pushTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        
        //保留旧的背景色
        superViewBackgroundColor = [containerView superview].backgroundColor;
        [containerView superview].backgroundColor = [UIColor whiteColor];
        [UIView transitionFromView:fromView toView:toView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            
            [containerView superview].backgroundColor = superViewBackgroundColor;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } dismissWithDuration:1.0 dismissTransitionBlock:^(id<UIViewControllerContextTransitioning> transitionContext, UIView *containerView, UIViewController *fromVc, UIView *fromView, UIViewController *toVc, UIView *toView) {
        
        //保留旧的背景色
        superViewBackgroundColor = [containerView superview].backgroundColor;
        [containerView superview].backgroundColor = [UIColor whiteColor];
        
        [UIView transitionFromView:fromView toView:toView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            
            [containerView superview].backgroundColor = superViewBackgroundColor;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
    [self.navigationController pushViewController:secondVc animated:YES];
}


#pragma mark - event and notification

- (void)backButtonClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

@end
