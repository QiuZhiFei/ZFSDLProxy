//
//  AppDelegate.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "AppDelegate.h"
#import "DOUSDLManager.h"

#import "NSLogger.h"
#import "LoggerClient.h"
#import "JxbDebugTool.h"



void uncaughtExceptionHandler(NSException *exception) {
  LogDebug(@"Crash : %@ %@ %@ , \n Stacks Traces : %@", exception.name, exception.reason, exception.userInfo, exception.callStackSymbols);
}

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  // *********************** DEBUG *********************** //
  
  NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
  
  LoggerSetViewerHost(NULL, (CFStringRef)@"192.168.3.134", (UInt32)50000);
  LogDebug(@"测试 NSLogger");
  
#ifdef DEBUG
  [SDLProxy enableSiphonDebug];
  [SDLDebugTool enableDebugToLogFile];
  
  [[JxbDebugTool shareInstance] setMainColor:[UIColor redColor]];
  [[JxbDebugTool shareInstance] enableDebugMode];
#endif
  
  // *********************** DEBUG *********************** //
  
  
  
  // *********************** SDL *********************** //
  
  [[DOUSDLManager sharedManager] startProxy];
  
  // HAVAL 需要在连接配件后开启服务
  [[NSNotificationCenter defaultCenter] addObserverForName:EAAccessoryDidConnectNotification
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                  LogDebug(@"Accessory did connect");
                                                  [[DOUSDLManager sharedManager] startProxy];
                                                }];
  [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                  LogDebug(@"UIApplication did become active");
                                                  [[DOUSDLManager sharedManager] startProxy];
                                                }];
  [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                  [[DOUSDLManager sharedManager] stopProxy];
                                                }];
  
  // *********************** SDL *********************** //
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
