//
//  H5WebViewController.m
//  UIWebView
//
//  Created by likai on 16/8/15.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import "H5WebViewController.h"
#import "H5TopBarView.h"
#import <PureLayout/PureLayout.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>


@interface H5WebViewController ()<H5TopBarViewDelegate, UIWebViewDelegate, NJKWebViewProgressDelegate, UIScrollViewDelegate>
{
    BOOL isBackButtonPressed_;
}

@property (nonatomic, strong) UIWebView *h5WebView;

@property (nonatomic, strong) H5TopBarView *h5TopBarView;

@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;

@property (nonatomic, strong) NSURL *currentUrl;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation H5WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customViewInit];
    
    //加载H5
    [self sendWebViewRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    self.progressView.hidden = NO;
    [self.progressView setProgress:progress animated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url  = [request.URL description];
    NSString *path = [request URL].path;
    NSString *host = [request URL].host;
    NSString *schema = [request URL].scheme;
    NSString *pathExtension = [request URL].pathExtension;
    NSLog(@"url:%@\nschema:%@\nhost:%@\npath:%@\npathExtension:%@", url, schema, host, path, pathExtension);
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self setTopBarData];
}

#pragma mark - H5TopBarViewDelegate

- (void)h5TopBarView:(H5TopBarView *)h5TopBarView buttonTapActionTapType:(H5TopBarTapEvents)tapEvent {
    switch (tapEvent) {
        case H5TopBarTapEventsBack://返回
        {
            if ([self.h5WebView canGoBack]) {
                [self.h5WebView goBack];
                isBackButtonPressed_ = YES;
            } else {
                if (self.pushType == H5PushTypePresent) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
            break;
        case H5TopBarTapEventsClose://关闭
        {
            if (self.pushType == H5PushTypePresent) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        case H5TopBarTapEventsRefresh://刷新
        {
            [self.h5WebView reload];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Custom Methods

- (void)setTopBarData {
    
    H5TopBarInfo *topBarInfo = [[H5TopBarInfo alloc] init];
    
    NSString *title = [self.h5WebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length > 0) {
        topBarInfo.titleStr = title;
    }
    
    topBarInfo.hasClose = isBackButtonPressed_;
    [self.h5TopBarView updateTopBarInfo:topBarInfo];
}

- (void)sendWebViewRequest {
    if (self.webUrlString.length > 0) {
        //消除url首尾空格符
        self.webUrlString = [self.webUrlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrlString]];
        [self.h5WebView loadRequest:request];
    }
}

- (void)customViewInit {
    
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;

    [self.view addSubview:self.h5TopBarView];
    [self.h5TopBarView addSubview:self.progressView];
    [self.view addSubview:self.h5WebView];

    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    
    if (!self.didSetupConstraints) {
        [self.h5TopBarView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
        [self.h5TopBarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
        [self.h5TopBarView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
        [self.h5TopBarView autoSetDimension:ALDimensionHeight toSize:64.0];
        
        [self.progressView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
        [self.progressView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
        [self.progressView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
        [self.progressView autoSetDimension:ALDimensionHeight toSize:2.0];
        
        [self.h5WebView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.h5TopBarView];
        [self.h5WebView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
        [self.h5WebView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
        [self.h5WebView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];

}

#pragma mark - Getters and Setters

- (UIWebView *)h5WebView {
    if (!_h5WebView) {
        _h5WebView = [UIWebView newAutoLayoutView];
        _h5WebView.delegate = _progressProxy;
        _h5WebView.scrollView.delegate = self;
        _h5WebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _h5WebView.opaque = NO;
        _h5WebView.backgroundColor = [UIColor whiteColor];
        _h5WebView.scalesPageToFit = YES;
        _h5WebView.scrollView.bounces = NO;
    }
    return _h5WebView;
}

- (H5TopBarView *)h5TopBarView {
    if (!_h5TopBarView) {
        _h5TopBarView = [H5TopBarView newAutoLayoutView];
        _h5TopBarView.delegate = self;
    }
    return _h5TopBarView;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        _progressView = [NJKWebViewProgressView newAutoLayoutView];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progress = 0.0f;
        _progressView.fadeAnimationDuration = 0.5f;
        _progressView.hidden = YES;
    }
    return _progressView;
}

@end
