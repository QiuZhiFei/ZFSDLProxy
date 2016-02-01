//
//  ZFPutFile.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFPutFile.h"

#import <SmartDeviceLink-iOS/SmartDeviceLink.h>

@interface ZFPutFile ()
@property (nonatomic, strong) NSString    *syncFileName;
@property (nonatomic, strong) SDLFileType *fileType;
@property (nonatomic, strong) NSNumber    *persistentFile;
@property (nonatomic, strong) NSNumber    *correlationID;
@property (nonatomic, strong) NSData      *bulkData;
@end

@implementation ZFPutFile

+ (instancetype)fileWithFileName:(NSString *)syncFileName
                        bulkData:(NSData *)bulkData
                        fileType:(SDLFileType *)fileType
                persisistentFile:(NSNumber *)persistentFile
                   correlationID:(NSNumber *)correlationID
{
  return [[ZFPutFile alloc] initWithFileName:syncFileName
                                    bulkData:bulkData
                                    fileType:fileType
                            persisistentFile:persistentFile
                               correlationID:correlationID];
}

- (id)initWithFileName:(NSString *)syncFileName
              bulkData:(NSData *)bulkData
              fileType:(SDLFileType *)fileType
      persisistentFile:(NSNumber *)persistentFile
         correlationID:(NSNumber *)correlationID
{
  self = [super init];
  if (self) {
    self.syncFileName = syncFileName;
    self.bulkData = bulkData;
    self.fileType = fileType;
    self.persistentFile = persistentFile;
    self.correlationID = correlationID;
  }
  return self;
}

- (BOOL)isEqual:(id)object
{
  BOOL equal = NO;
  if (object
      && [object isKindOfClass:[ZFPutFile class]]) {
    ZFPutFile *eObj = (ZFPutFile *)object;
    if ([eObj.syncFileName isEqualToString:self.syncFileName]
        && [eObj.correlationID isEqualToNumber:self.correlationID]
        && [eObj.persistentFile isEqualToNumber:self.persistentFile]) {
      equal = YES;
    }
  }
  return equal;
}

@end
