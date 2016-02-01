//
//  ZFPutFile.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDLFileType;

@interface ZFPutFile : NSObject

+ (instancetype)fileWithFileName:(NSString *)syncFileName
                        bulkData:(NSData *)bulkData
                        fileType:(SDLFileType *)fileType
                persisistentFile:(NSNumber *)persistentFile
                   correlationID:(NSNumber *)correlationID;

@property (nonatomic, strong, readonly) NSString *syncFileName;
@property (nonatomic, strong, readonly) SDLFileType *fileType;
@property (nonatomic, strong, readonly) NSNumber *persistentFile;
@property (nonatomic, strong, readonly) NSNumber *correlationID;
@property (nonatomic, strong, readonly) NSData* bulkData;

@end
