//
//  H5TopBarView.h
//  UIWebView
//
//  Created by likai on 16/8/15.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "H5TopBarInfo.h"

typedef NS_ENUM (NSInteger, H5TopBarTapEvents){
    H5TopBarTapEventsBack    = 0,
    H5TopBarTapEventsClose   = 1,
    H5TopBarTapEventsRefresh = 2,
};

@class H5TopBarInfo;
@protocol H5TopBarViewDelegate;

@interface H5TopBarView : UIView

@property (nonatomic, weak) id<H5TopBarViewDelegate> delegate;

- (void)updateTopBarInfo:(H5TopBarInfo *)topBarInfo;

@end

@protocol H5TopBarViewDelegate <NSObject>

- (void)h5TopBarView:(H5TopBarView *)h5TopBarView buttonTapActionTapType:(H5TopBarTapEvents)tapEvent;

@end
