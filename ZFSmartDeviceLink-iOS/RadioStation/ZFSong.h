//
//  ZFSong.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/3.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"

@interface ZFSong : NSObject <DOUAudioFile>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSURL    *albumCoverUrl;
@property (nonatomic, strong) NSURL    *audioFileURL;
@property (nonatomic, assign) BOOL     likeit;
@property (nonatomic, assign) BOOL     collected;

@end
