//
//  RootViewController.m
//  UIWebView
//
//  Created by likai on 16/8/17.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import "RootViewController.h"
#import <PureLayout/PureLayout.h>
#import "H5WebViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.button];
    
    [self.button autoCenterInSuperview];
    [self.button autoSetDimensionsToSize:CGSizeMake(200.0, 45.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jump2H5 {
    H5WebViewController *controller = [[H5WebViewController alloc]init];
    controller.webUrlString = @"http://www.jd.com";
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton newAutoLayoutView];
        [_button setTitle:@"Go" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_button setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [_button addTarget:self action:@selector(jump2H5) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


@end
