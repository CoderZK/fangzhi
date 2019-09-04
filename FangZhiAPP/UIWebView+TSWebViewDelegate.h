//
//  UIWebView+TSWebViewDelegate.h
//  FangZhiAPP
//
//  Created by zk on 2019/8/31.
//  Copyright © 2019 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TSWebViewDelegate <UIWebViewDelegate>

@optional

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx;

@end


@interface UIWebView (TSWebViewDelegate)
@property (nonatomic, readonly) JSContext* ts_javaScriptContext;
@end


