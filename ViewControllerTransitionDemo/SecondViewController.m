//
//  SecondViewController.m
//  ViewControllerTransitionDemo
//
//  Created by 吴志和 on 16/2/19.
//  Copyright © 2016年 wuzhihe. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(150, CGRectGetMaxY(self.imageView.frame) + 10, 100, 50);
    [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
}

#pragma mark - getter and setter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
        _imageView.image = [UIImage imageNamed:@"1.jpg"];
    }
    return _imageView;
}

#pragma mark - event

- (void)dismissButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
