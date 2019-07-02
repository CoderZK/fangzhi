//
//  AppDelegate.m
//  FangZhiAPP
//
//  Created by zk on 2019/6/17.
//  Copyright © 2019 张坤. All rights reserved.
//

#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>
#import <UShareUI/UShareUI.h>
#import <UMCommon/UMCommon.h>
#import "UMessage.h"
#import "ViewController.h"
#import <UMErrorCatch/UMErrorCatch.h>
#import "Crash.h"
#import "FangZhiCrachVC.h"

#define UMKey @"5d0c48590cafb2fb2b000ca6"
//友盟安全密钥//quvss8rcpv3jahqyajgeuspa6o1vdeqr
#define SinaAppKey @"102135063"
#define SinaAppSecret @"47a31952aed883dc13cdccaf9b30df0d"
#define QQAppID @"101504727"
#define QQAppKey @"2e7928e5d1e2974eb06a35fa408e0950"
#define WXAppID @"wxe68b61e47e500548"
#define WXAppSecret @"96405f2eddb5e6cd8e6e01c87bbda8fb"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController* vc = [[ViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *newUserAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@"%@",adId]];//自定义需要拼接的字符串
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKey];
    
   
    
    [self configUSharePlatforms];
    
    
    //注册消息处理函数的处理方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // 发送崩溃日志
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [path stringByAppendingPathComponent:@"error.log"];
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
    NSString *content=[NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"\n\n\n---%@",content);

    
    if (data != nil) {
       
        [self.window.rootViewController presentViewController:[[FangZhiCrachVC alloc] init] animated:YES completion:nil];
        
    }
    
    return YES;
}



- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID/*设置QQ平台的appID*/  appSecret:QQAppKey redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppKey  appSecret:SinaAppSecret redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
