//
//  DOUSDLManager.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "DOUSDLManager.h"
#import "ZFRadioStation.h"
#import "ZFSong.h"

#import <SDWebImage/SDWebImageManager.h>
#import <MAKVONotificationCenter/MAKVONotificationCenter.h>

NSString *const ZFSDLAppName = @"豆瓣FM";
NSString *const ZFSDLAppId = @"9999";

// 0 ~ 999  constantID
static const NSUInteger kHotChannelChoiceInteractionSetID = 100;

@interface DOUSDLManager ()
@property (nonatomic, strong, readonly) ZFProxyManager *proxyManager;
@property (nonatomic, strong, readonly) ZFAppearance *app;

@property (nonatomic, strong, readonly) SDLSoftButton *playStatusButton;
@property (nonatomic, strong, readonly) SDLSoftButton *collectChannelButton;
@property (nonatomic, strong, readonly) SDLSoftButton *shareButton;
@property (nonatomic, strong, readonly) SDLSoftButton *banButton;
@end

@implementation DOUSDLManager

+ (instancetype)sharedManager
{
  static DOUSDLManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[DOUSDLManager alloc] init];
  });
  return manager;
}

- (id)init
{
  self = [super init];
  if (self) {
    [self _setupAPP];
    [self _setupProxy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updatePlayingInfo)
                                                 name:kZFRadioStationSongLikedChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_songChanged)
                                                 name:kZFRadioStationSongChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_playerStatusChanged)
                                                 name:kZFRadioStationPlayerStatusChangedNotification
                                               object:nil];
    
  }
  return self;
}

- (void)startProxy
{
  if (_proxyManager == nil) {
    [self _setupProxy];
  }
  if (_proxyManager.state == ZFProxyStateStopped) {
    [_proxyManager startProxy];
  }
}

- (void)stopProxy
{
  [_proxyManager stopProxy];
  _proxyManager = nil;
}

- (void)toggleProxy
{
  if (_proxyManager.state == ZFProxyStateStopped) {
    [self startProxy];
  } else {
    [self stopProxy];
  }
}

- (ZFProxyState)state
{
  return _proxyManager.state;
}

#pragma mark - Setup

- (void)_setupAPP
{
  _app = [[ZFAppearance alloc] init];
  _app.name = ZFSDLAppName;
  _app.lang = [SDLLanguage ZH_CN];
  _app.appID = ZFSDLAppId;
  _app.isMediaApplication = YES;
  _app.icon = [UIImage imageNamed:@"icon"];
  _app.restartIfProxyClosed = NO;
}

- (void)_setupProxy
{
  _proxyManager = [[ZFProxyManager alloc] initWithAPP:_app];
  typeof(self) __weak wself = self;
  _proxyManager.SDLConnectedSuccessHandler = ^{
    LogDebug(@"SDL Connected Success");
    [wself _updateStatusPlayingInfo];
#pragma message "感觉不需要添加 help，直接添加 command 就可以了"
    [wself _addCommand];
    [wself _addSubscribeButton];
    [wself _addHotChoiceSet];
  };
  _proxyManager.SDLDisconnectedHandler = ^{
    LogDebug(@"SDL Disconnected Success");
  };
}

#pragma mark - UI

- (void)_addCommand
{
  typeof(self) __weak wself = self;
  [_proxyManager addCommandWithMenuName:@"Skip"
                               commands:@[@"Skip"]
                          correlationID:_proxyManager.autoIncCorrIDNum
                                handler:^{
                                  LogDebug(@"Skip ~ ");
                                  [[ZFRadioStation sharedRadioStation] skipSong];
                                }];
  [_proxyManager addCommandWithMenuName:@"Ban"
                               commands:@[@"Ban"]
                          correlationID:_proxyManager.autoIncCorrIDNum
                                handler:^{
                                  LogDebug(@"Ban ~ ");
                                  [[ZFRadioStation sharedRadioStation] banSong];
                                }];
  [_proxyManager addCommandWithMenuName:@"HotChoice"
                               commands:@[@"Hotchoice"]
                          correlationID:_proxyManager.autoIncCorrIDNum
                                handler:^{
#pragma message "hot choice 旧版正常，新车机不展示"
                                  LogDebug(@"Hotchoice ~ ");
                                  [wself.proxyManager showPerformInteractionWithInitialPrompt:@"prompt"
                                                                                  initialText:@"initialText"
                                                                       interactionChoiceSetID:[NSNumber numberWithInteger:kHotChannelChoiceInteractionSetID]];
                                }];
  
}

- (void)_addSubscribeButton
{
  [_proxyManager addSubscribeButtonWithName:[SDLButtonName OK]
                              correlationID:_proxyManager.autoIncCorrIDNum
                                    handler:^{
                                      [[ZFRadioStation sharedRadioStation] toggleAudioPlaying];
                                    }];
  [_proxyManager addSubscribeButtonWithName:[SDLButtonName SEEKRIGHT]
                              correlationID:_proxyManager.autoIncCorrIDNum
                                    handler:^{
                                      [[ZFRadioStation sharedRadioStation] skipSong];
                                    }];
  [_proxyManager addSubscribeButtonWithName:[SDLButtonName SEEKLEFT]
                              correlationID:_proxyManager.autoIncCorrIDNum
                                    handler:^{
                                      [[ZFRadioStation sharedRadioStation] skipSong];
                                    }];
}

- (void)_addHotChoiceSet
{
  NSArray *choiceNames = @[@"Chinese", @"EuroAmerican"];
  NSMutableArray *choiceSet = [NSMutableArray arrayWithCapacity:choiceNames.count];
  [choiceNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
    [choiceSet addObject:[_proxyManager choiceWithName:name choiceID:_proxyManager.autoIncCorrIDNum]];
  }];
  [_proxyManager addChoiceSetsWithID:[NSNumber numberWithInteger:kHotChannelChoiceInteractionSetID]
                           choiceSet:choiceSet
                       correlationID:_proxyManager.autoIncCorrIDNum
                             handler:^(NSUInteger index) {
                               LogDebug(@"ChoiceSet index == %ld", (unsigned long)index);
                             }];
}

- (void)_updatePlayingInfo
{
#pragma message "这里暂时用 song title 作为唯一标识，真正项目中更倾向于使用 id 的形式"
  ZFSong *curSong = [[ZFRadioStation sharedRadioStation] curSong];
  NSString *albumCoverName = curSong.title;
  SDLImage *sdlImage = [_proxyManager SDLImageNamed:albumCoverName];
  
  [self.proxyManager showMessageWithField1:curSong.title
                                    field2:curSong.artist
                                mediaTrack:@"mediatrack"
                                   graphic:sdlImage
                               softButtons:[self _defaultSoftButtons]];
  if (sdlImage == nil
      && curSong.albumCoverUrl.absoluteString.length > 0) {
    [[SDWebImageManager sharedManager] downloadImageWithURL:curSong.albumCoverUrl
                                                    options:SDWebImageRetryFailed
                                                   progress:NULL
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                    if (finished && error == nil) {
                                                      [self.proxyManager putImage:image
                                                                             name:albumCoverName
                                                                    correlationID:self.proxyManager.autoIncCorrIDNum
                                                                         finished:^(BOOL success, SDLPutFileResponse *response) {
                                                                           if (success) {
                                                                             [self.proxyManager showMessageWithField1:curSong.title
                                                                                                               field2:curSong.artist
                                                                                                           mediaTrack:@"mediatrack"
                                                                                                              graphic:[self.proxyManager SDLImageNamed:albumCoverName]
                                                                                                          softButtons:[self _defaultSoftButtons]];
                                                                           }
                                                                         }];
                                                    }
                                                  }];
  }
}

- (NSArray *)_defaultSoftButtons
{
  if (_playStatusButton == nil) {
    _playStatusButton = [_proxyManager zf_buildSDLSoftButtonText:@"喜欢"
                                                           image:[_proxyManager SDLImageNamed:@"ZF_Like"]
                                                    softButtonID:_proxyManager.autoIncCorrIDNum
                                                         handler:^{
                                                           LogDebug(@"like");
                                                         }];
  }
  _playStatusButton.text = [[[ZFRadioStation sharedRadioStation] curSong] likeit] ? @"不喜欢" : @"喜欢";
  if (_collectChannelButton == nil) {
    _collectChannelButton = [_proxyManager zf_buildSDLSoftButtonText:@"收藏"
                                                               image:[_proxyManager SDLImageNamed:@"ZF_Collect"]
                                                        softButtonID:_proxyManager.autoIncCorrIDNum
                                                             handler:^{
                                                               LogDebug(@"collect");
                                                             }];
  }
  if (_shareButton == nil) {
    _shareButton = [_proxyManager zf_buildSDLSoftButtonText:@"分享"
                                                      image:[_proxyManager SDLImageNamed:@"ZF_Share"]
                                               softButtonID:_proxyManager.autoIncCorrIDNum
                                                    handler:^{
                                                      LogDebug(@"share");
                                                    }];
  }
  if (_banButton == nil) {
    _banButton = [_proxyManager zf_buildSDLSoftButtonText:@"垃圾桶"
                                                    image:[_proxyManager SDLImageNamed:@"ZF_Ban"]
                                             softButtonID:_proxyManager.autoIncCorrIDNum
                                                  handler:^{
                                                    LogDebug(@"ban");
                                                  }];
  }
  return @[_playStatusButton, _collectChannelButton, _shareButton, _banButton];
}

#pragma mark - Private Methods

- (void)_songChanged
{
  [self _sendMediaClockTimerWithUpdateMode:[SDLUpdateMode CLEAR]];
}

- (void)_playerStatusChanged
{
  LogDebug("RadioStation status == %lu", (unsigned long)[[ZFRadioStation sharedRadioStation] status]);
#pragma message "AudioStreamer 导致 status 短时间内大量的调用，先 hack"
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  [self performSelector:@selector(_updateStatusPlayingInfo)
             withObject:nil
             afterDelay:0.5];
}

- (void)_updateStatusPlayingInfo
{
  LogDebug("Update Status Plaing Info, RadioStation status == %lu", (unsigned long)[[ZFRadioStation sharedRadioStation] status]);
  [self _updatePlayingInfo];
  if ([[ZFRadioStation sharedRadioStation] isRunning]) {
    [self _sendMediaClockTimerWithUpdateMode:[SDLUpdateMode COUNTUP]];
  } else {
    [self _sendMediaClockTimerWithUpdateMode:[SDLUpdateMode PAUSE]];
  }
}

- (void)_applicationTerminate
{
  [self stopProxy];
}

- (void)_sendMediaClockTimerWithUpdateMode:(SDLUpdateMode *)mode
{
  LogDebug(@"Send Media Clock Time, Start time: %f, End time: %f", [[ZFRadioStation sharedRadioStation] currentTime], [[ZFRadioStation sharedRadioStation] duration]);
  [self.proxyManager sendMediaClockTimerWithUpdateMode:mode
                                             startTime:[[ZFRadioStation sharedRadioStation] currentTime]
                                               endTime:[[ZFRadioStation sharedRadioStation] duration]
                                         correlationID:self.proxyManager.autoIncCorrIDNum];
}

@end