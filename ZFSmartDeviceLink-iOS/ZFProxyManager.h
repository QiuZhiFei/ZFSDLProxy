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

typedef NS_ENUM(NSUInteger, ProxyState) {
  ProxyStateStopped,
  ProxyStateSearchingForConnection,
  ProxyStateConnected
};

@interface ZFProxyManager : NSObject <SDLProxyListener>

@property (nonatomic, readonly, strong) SDLProxy * proxy;
@property (nonatomic, readonly, assign) ProxyState state;

@property (nonatomic, strong) ZFAppearance *app;

@property (nonatomic, strong) void(^SDLConnectedSuccessHandler)();
@property (nonatomic, strong) void(^SDLDisconnectedHandler)();

@property (nonatomic, strong) void(^SDLAudioStreamingStateChanged)(BOOL paused);

@property (nonatomic, readonly, strong) NSNumber * autoIncCorrIDNum;

@end
