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

@interface ZFProxyManager () 
@property (assign, nonatomic) BOOL isFirstHMIFull;
@property (nonatomic, assign) ProxyState state;
@property (nonatomic, assign) BOOL pausedByUser;
@end

@implementation ZFProxyManager

+ (instancetype)sharedManager
{
  static ZFProxyManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ZFProxyManager alloc] init];
  });
  return manager;
}

- (id)init
{
  self = [super init];
  if (self) {
    [self _setupProxy];
  }
  return self;
}

- (NSNumber *)autoIncCorrIDNum
{
  return @1;
}

#pragma mark - Public Methods

- (void)startProxy
{
  if (_proxy == nil) {
    _proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
  }
  _state = ProxyStateSearchingForConnection;
}

- (void)stopProxy
{
  _state = ProxyStateStopped;
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
  _state = ProxyStateStopped;
  _isFirstHMIFull = NO;
}

- (void)_showIcon
{
  if (self.app.icon) {
    NSString *icon = @"icon";
    NSNumber *correlationID = [self.autoIncCorrIDNum copy];
    [self putImage:self.app.icon
              name:icon
     correlationID:self.autoIncCorrIDNum
          finished:^(BOOL success, SDLPutFileResponse *response) {
            if (success) {
              SDLSetAppIcon *req = [SDLRPCRequestFactory buildSetAppIconWithFileName:icon
                                                                       correlationID:correlationID];
              [self.proxy sendRPC:req];
            }
          }];
  }
}

#pragma mark - SDLProxyListner delegate methods

- (void)onProxyOpened
{
  _state = ProxyStateConnected;
  
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
  if (self.app.restartIfProxyClosed) {
    [self resetProxy];
  } else {
    [self stopProxy];
  }
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification
{
  if (notification.hmiLevel == SDLHMILevel.NONE) {
    self.state = ProxyStateStopped;
  } else if (notification.hmiLevel == SDLHMILevel.FULL) {
    if (!_isFirstHMIFull) {
      _isFirstHMIFull = YES;
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
  
  [self _showIcon];
}

- (void)onOnCommand:(SDLOnCommand *)notification
{
  
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification
{
  [HavalDebugTool logInfo:[NSString stringWithFormat:@"%@ name == %@ id == %@", NSStringFromSelector(_cmd), notification.buttonName, notification.customButtonID]];
  
  if ([notification.buttonEventMode isEqual:[SDLButtonEventMode BUTTONDOWN]]) {
    if ([notification.buttonName isEqual:[SDLButtonName OK]]) {
      _pausedByUser = [self isAudioPlaying];
      [self toggleAudioPlaying];
    } else if ([notification.buttonName isEqual:[SDLButtonName SEEKRIGHT]]) {
      [[DOURadioStation sharedRadioStation] skipSong];
      [self _clearMediaTimer];
    } else if ([notification.buttonName isEqual:[SDLButtonName SEEKLEFT]]) {
      [self prompt:HAVAL_LOCALE_PREVIOUS_NOT_SUPPORTED];
    }
  }
}

- (void)lockUserInterface
{
  if (self.SDLConnectedSuccessHandler) {
    self.SDLConnectedSuccessHandler();
  }
}

- (void)unlockUserInterface
{
  if (self.SDLDisconnectedHandler) {
    self.SDLDisconnectedHandler();
  }
}

@end

