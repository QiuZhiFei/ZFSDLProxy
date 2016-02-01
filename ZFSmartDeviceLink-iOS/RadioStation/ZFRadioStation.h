//
//  ZFRadioStation.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/3.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioStreamer/DOUAudioStreamer.h>
@class ZFSong;

FOUNDATION_EXPORT NSString * const kZFRadioStationPlayerStatusChangedNotification;
FOUNDATION_EXPORT NSString * const kZFRadioStationSongChangedNotification;
FOUNDATION_EXPORT NSString * const kZFRadioStationSongLikedChangedNotification;

@interface ZFRadioStation : NSObject

@property (nonatomic, strong, readonly) ZFSong *curSong;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, assign, readonly) DOUAudioStreamerStatus status;
+ (instancetype)sharedRadioStation;

- (void)playSong:(ZFSong *)song;
- (void)playSongList:(NSArray *)songs
             atIndex:(NSUInteger)index;

- (void)skipSong;
- (void)banSong;
- (void)likeSong;
- (void)pausePlaying;
- (void)startPlaying;
- (BOOL)isAudioPlaying;
- (void)toggleAudioPlaying;

@end
