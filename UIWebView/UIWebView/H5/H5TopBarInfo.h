//
//  H5TopBarInfo.h
//  UIWebView
//
//  Created by likai on 16/8/15.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface H5TopBarInfo : NSObject

/**标题*/
@property (nonatomic, copy) NSString *titleStr;

/**刷新*/
@property (nonatomic, assign) BOOL hasRefresh;
/**关闭*/
@property (nonatomic, assign) BOOL hasClose;
/**返回*/
@property (nonatomic, assign) BOOL hasBack;

@end
