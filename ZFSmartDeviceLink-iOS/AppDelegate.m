//
//  AppDelegate.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "AppDelegate.h"
#import "DOUSDLManager.h"
#import "ZFSDLProxy.h"

#import "NSLogger.h"
#import "LoggerClient.h"
#import "JxbDebugTool.h"

#import "ZFRadioStation.h"
#import "ZFSong.h"

void uncaughtExceptionHandler(NSException *exception) {
  LogDebug(@"Crash : %@ %@ %@ , \n Stacks Traces : %@", exception.name, exception.reason, exception.userInfo, exception.callStackSymbols);
}

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
  
  LoggerSetViewerHost(NULL, (CFStringRef)@"192.168.0.198", (UInt32)50000);
  LogDebug(@"测试 NSLogger");
  
#ifdef DEBUG
  [SDLProxy enableSiphonDebug];
  [SDLDebugTool enableDebugToLogFile];
  
  [[JxbDebugTool shareInstance] setMainColor:[UIColor redColor]];
  [[JxbDebugTool shareInstance] enableDebugMode];
#endif
  
  NSArray *imageURLs = @[@"http://img1.imgtn.bdimg.com/it/u=1768261506,2972859401&fm=21&gp=0.jpg",
                         @"http://img3.imgtn.bdimg.com/it/u=1284416964,1606791513&fm=21&gp=0.jpg",
                         @"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg"];
  NSMutableArray *songs = [NSMutableArray array];
  for (int i = 0; i < 3; i ++) {
    ZFSong *song = [[ZFSong alloc] init];
    song.title = [NSString stringWithFormat:@"title - %d", i];
    song.artist = [NSString stringWithFormat:@"artist - %d", i];
    song.audioFileURL = [NSURL URLWithString:@"http://douban.fm/misc/mp3url?domain=mr7"];
    song.albumCoverUrl = [NSURL URLWithString:imageURLs[i]];
    song.likeit = NO;
    song.collected = NO;
    [songs addObject:song];
  } 
  [[ZFRadioStation sharedRadioStation] playSongList:songs atIndex:0];

  
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
