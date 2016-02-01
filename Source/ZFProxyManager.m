//
//  ZFProxyManager.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"
#import "ZFProxyManager+PutFile.h"
#import "ZFProxyManager+Image.h"
#import "ZFMacros.h"

NSString * const kZFProxyStateChangedNotification = @"kZFProxyStateChangedNotification";

@interface ZFProxyManager () 
@property (nonatomic, assign) BOOL           isFirstHMIFull;
@property (nonatomic, assign) ZFProxyState   state;
@property (nonatomic, assign) BOOL           pausedByUser;

@property (nonatomic, assign) BOOL           isGraphicsSupported;
@property (nonatomic, strong) SDLDisplayType *displayType;
@property (nonatomic, strong) NSArray        *textFields;
@property (nonatomic, strong) NSArray        *tempplatesAvailable;
@end

@implementation ZFProxyManager

- (id)initWithAPP:(ZFAppearance *)app
{
  NSParameterAssert(app);
  self = [super init];
  if (self) {
    _isGraphicsSupported = NO;
    
    _app = app;
    [self _setupProxy];
  }
  return self;
}

- (instancetype)init NS_UNAVAILABLE
{
  return nil;
}

- (NSNumber *)autoIncCorrIDNum
{
  static NSInteger _correlationID = 1000;
  return @(_correlationID++);
}

- (void)setState:(ZFProxyState)state
{
  _state = state;
  [[NSNotificationCenter defaultCenter] postNotificationName:kZFProxyStateChangedNotification
                                                      object:nil];
}

#pragma mark - Public Methods

- (void)startProxy
{
  LogDebug(@"startProxy ~ ");
  if (_proxy == nil) {
    _proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
  }
  self.state = ZFProxyStateSearchingForConnection;

}

- (void)stopProxy
{
  LogDebug(@"stopProxy ~ ");
  SDLUnregisterAppInterface *unRegRequest = [SDLRPCRequestFactory buildUnregisterAppInterfaceWithCorrelationID:self.autoIncCorrIDNum];
  [_proxy sendRPC:unRegRequest];
  
  self.state = ZFProxyStateStopped;
  [_proxy dispose];
  _proxy = nil;
  _isFirstHMIFull = NO;
  [self resetPutFilesData];  
}

- (void)resetProxy
{
  [self stopProxy];
  [self startProxy];
}

#pragma mark - Private Methods

- (void)_setupProxy
{
  _proxy = nil;
  _state = ZFProxyStateStopped;
  _isFirstHMIFull = NO;
}

- (void)_showIcon
{
  if (self.app.icon && self.isGraphicsSupported) {
    NSString *iconName = @"icon";
    NSNumber *correlationID = [self.autoIncCorrIDNum copy];
    [self putImage:self.app.icon
              name:iconName
     correlationID:self.autoIncCorrIDNum
          finished:^(BOOL success, SDLPutFileResponse *response) {
            if (success) {
              SDLSetAppIcon *req = [SDLRPCRequestFactory buildSetAppIconWithFileName:iconName
                                                                       correlationID:correlationID];
              [self.proxy sendRPC:req];
            }
          }];
  }
}

- (void)_lockUserInterface
{
  if (self.SDLConnectedSuccessHandler) {
    self.SDLConnectedSuccessHandler();
  }
}

- (void)_unlockUserInterface
{
  if (self.SDLDisconnectedHandler) {
    self.SDLDisconnectedHandler();
  }
}

#pragma mark - SDLProxyListner delegate methods

- (void)onProxyOpened
{
  LogDebug(@"onProxyOpened ~");
  self.state = ZFProxyStateConnected;

  SDLRegisterAppInterface *regRequest = [SDLRPCRequestFactory
                                         buildRegisterAppInterfaceWithAppName:self.app.name
                                         languageDesired:self.app.lang
                                         appID:self.app.appID];
  regRequest.isMediaApplication = [NSNumber numberWithBool:self.app.isMediaApplication];
  regRequest.ngnMediaScreenAppName = nil;
  regRequest.vrSynonyms = nil;
  [_proxy sendRPC:regRequest];
}

- (void)onProxyClosed
{
  LogDebug(@"onProxyClosed");
  [self _unlockUserInterface];
  if (self.app.restartIfProxyClosed) {
    [self resetProxy];
  } else {
    [self stopProxy];
  }
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification
{
  LogDebug(@"HMILevel == %@", [SDLHMILevel NONE].description);
  if (notification.hmiLevel == SDLHMILevel.NONE) {
#pragma message "none 如何处理"
  } else if (notification.hmiLevel == SDLHMILevel.FULL) {
    if (!_isFirstHMIFull) {
      _isFirstHMIFull = YES;
      [self _lockUserInterface];
    }
  }
  
  if (self.app.isMediaApplication) {
    if ([[SDLAudioStreamingState NOT_AUDIBLE] isEqual:notification.audioStreamingState ]) {
      if (self.SDLAudioStreamingStateChanged) {
        self.SDLAudioStreamingStateChanged(YES);
      }
    } else if ([[SDLAudioStreamingState AUDIBLE] isEqual:notification.audioStreamingState] ||
               [[SDLAudioStreamingState ATTENUATED] isEqual:notification.audioStreamingState]) {
      if (!_pausedByUser && self.SDLAudioStreamingStateChanged) {
        self.SDLAudioStreamingStateChanged(NO);
      }
    }
  }
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification
{
  // Do nothing.
}

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response
{
  self.isGraphicsSupported = NO;
  if (response.displayCapabilities != nil) {
    self.displayType = response.displayCapabilities.displayType;
    self.textFields = response.displayCapabilities.textFields;
    self.tempplatesAvailable = response.displayCapabilities.templatesAvailable;
    
    if (response.displayCapabilities.graphicSupported != nil) {
      self.isGraphicsSupported = response.displayCapabilities.graphicSupported.boolValue;
    }
  }
  [self _showIcon];
}

@end

