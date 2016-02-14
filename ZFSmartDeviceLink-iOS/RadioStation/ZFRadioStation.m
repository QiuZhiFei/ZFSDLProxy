//
//  ZFRadioStation.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/3.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFRadioStation.h"
#import "ZFSong.h"

#import <MAKVONotificationCenter/MAKVONotificationCenter.h>

static NSString *kStatusKVOKey = @"status";
static NSString *kDurationKVOKey = @"duration";
static NSString *kBufferingRatioKVOKey = @"bufferingRatio";

NSString * const kZFRadioStationPlayerStatusChangedNotification = @"kZFRadioStationPlayerStatusChangedNotification";
NSString * const kZFRadioStationSongChangedNotification = @"kZFRadioStationSongChangedNotification";
NSString * const kZFRadioStationSongLikedChangedNotification = @"kZFRadioStationSongLikedChangedNotification";
NSString * const kZFRadioStationSongCollectedChangedNotification = @"kZFRadioStationSongCollectedChangedNotification";

@interface ZFRadioStation ()
@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic, strong) ZFSong *curSong;
@property (nonatomic, strong) NSArray *songs;
@end

@implementation ZFRadioStation

+ (instancetype)sharedRadioStation
{
  static ZFRadioStation *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[ZFRadioStation alloc] init];
  });
  return instance;
}

- (void)playSong:(ZFSong *)song
{
  [self _cancelStreamer];
  if (song) {
    self.curSong = song;
    _streamer = [DOUAudioStreamer streamerWithAudioFile:song];
    [_streamer addObservationKeyPath:kStatusKVOKey
                             options:NSKeyValueObservingOptionNew
                               block:^(MAKVONotification *notification) {
                                 NSNotification *noti = [[NSNotification alloc] initWithName:kZFRadioStationPlayerStatusChangedNotification
                                                                                      object:nil
                                                                                    userInfo:nil];
                                 [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:noti waitUntilDone:YES];
                               }];
    [_streamer addObservationKeyPath:kDurationKVOKey
                             options:NSKeyValueObservingOptionNew
                               block:^(MAKVONotification *notification) {
                                 //
                               }];
    [_streamer addObservationKeyPath:kBufferingRatioKVOKey
                             options:NSKeyValueObservingOptionNew
                               block:^(MAKVONotification *notification) {
                                 //
                               }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kZFRadioStationSongChangedNotification object:nil];
    [_streamer play];
  }
}

- (void)playSongList:(NSArray *)songs
             atIndex:(NSUInteger)index
{
  ZFSong *song = nil;
  if (index < songs.count) {
    self.songs = songs;
    song = songs[index];
    [self playSong:song];
  }
}

- (void)skipSong
{
  NSUInteger curIndex = [self.songs indexOfObject:self.curSong];
  if (curIndex == NSNotFound ||
      curIndex == self.songs.count - 1) {
    curIndex = 0;
  } else {
    curIndex ++;
  }
  [self playSongList:self.songs atIndex:curIndex];
}

- (void)banSong
{
  [self skipSong];
}

- (void)likeSong
{
  self.curSong.likeit = !self.curSong.likeit;
  [[NSNotificationCenter defaultCenter] postNotificationName:kZFRadioStationSongLikedChangedNotification object:nil];
}

- (void)collectSong
{
  self.curSong.collected = !self.curSong.collected;
  [[NSNotificationCenter defaultCenter] postNotificationName:kZFRadioStationSongCollectedChangedNotification object:nil];
}

- (void)pausePlaying
{
  [_streamer pause];
}

- (void)startPlaying
{
  [_streamer play];
}

- (void)toggleAudioPlaying
{
  if ([self isAudioPlaying]) {
    [self pausePlaying];
  } else {
    [self startPlaying];
  }
}

- (BOOL)isAudioPlaying
{
  return _streamer.status == DOUAudioStreamerPlaying;
}

- (NSTimeInterval)currentTime
{
  return _streamer.currentTime;
}

- (NSTimeInterval)duration
{
  return _streamer.duration;
}

- (BOOL)isRunning
{
  return _streamer.status == DOUAudioStreamerPlaying;
}

- (DOUAudioStreamerStatus)status
{
  return _streamer.status;
}

#pragma mark - Private Methods

- (void)_cancelStreamer
{
  if (_streamer != nil) {
    [_streamer pause];
    [_streamer removeAllObservers];
    _streamer = nil;
  }
}

@end
