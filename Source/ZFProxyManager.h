//
//  ZFProxyManager.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFAppearance.h"

#import <SmartDeviceLink-iOS/SmartDeviceLink.h>

typedef NS_ENUM(NSUInteger, ZFProxyState) {
  ZFProxyStateStopped,
  ZFProxyStateSearchingForConnection,
  ZFProxyStateConnected
};

FOUNDATION_EXTERN NSString * const kZFProxyStateChangedNotification;

@interface ZFProxyManager : NSObject <SDLProxyListener>

- (id)initWithAPP:(ZFAppearance *)app NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly, strong) SDLProxy     * proxy;
@property (nonatomic, readonly, assign) ZFProxyState state;
@property (nonatomic, readonly, strong) ZFAppearance *app;
@property (nonatomic, readonly, assign) BOOL         isGraphicsSupported;
/**
 *  autoIncCorrIDNum 1000~ 
 *  0 ~ 999  constantID
 */
@property (nonatomic, readonly, strong) NSNumber     * autoIncCorrIDNum;

- (void)startProxy;
- (void)stopProxy;

@property (nonatomic, strong) void(^SDLConnectedSuccessHandler)();
@property (nonatomic, strong) void(^SDLDisconnectedHandler)();

@property (nonatomic, strong) void(^SDLAudioStreamingStateChanged)(BOOL paused);

@end
