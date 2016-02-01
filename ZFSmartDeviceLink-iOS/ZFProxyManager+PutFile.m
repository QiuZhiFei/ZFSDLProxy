//
//  ZFProxyManager+PutFile.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+PutFile.h"
#import "ZFPutFile.h"

@interface ZFProxyManager ()
@property (nonatomic, strong) NSMutableDictionary *putHandlers;
@property (nonatomic, strong) NSMutableDictionary      *putFiles;
@property (nonatomic, strong) NSMutableDictionary *puttingFiles;
@end

@implementation ZFProxyManager (PutFile)

- (void)putFileWithFileName:(NSString *)syncFileName
                   bulkData:(NSData *)bulkData
                   fileType:(SDLFileType *)fileType
           persisistentFile:(NSNumber *)persistentFile
              correlationID:(NSNumber *)correlationID
                   finished:(ZFPutFileHandler)handler
{
  ZFPutFile *file = [ZFPutFile fileWithFileName:syncFileName
                                       bulkData:bulkData
                                       fileType:fileType
                               persisistentFile:persistentFile
                                  correlationID:correlationID];
  [self putFile:file finished:handler];
}

- (void)putFile:(ZFPutFile *)file finished:(ZFPutFileHandler)handler
{
  if (file.correlationID) {
    NSString *key = [NSString stringWithFormat:@"%@", file.correlationID];
    // 已经上传过
    if ([self hasCachedForCorrelationID:file.correlationID]) {
      SDLPutFileResponse *response = [[SDLPutFileResponse alloc] init];
      response.resultCode = [SDLResult SUCCESS];
      response.correlationID = file.correlationID;
      if (handler) {
        handler(YES, response);
      }
      return;
    } else {
      [self.putHandlers setValue:handler forKey:key];
      if ([self.puttingFiles valueForKey:key]) {
        // 已经在请求中
        return;
      }
      [self.puttingFiles setValue:file forKey:key];
    }
  }
  
  SDLPutFile *putFileReq = [SDLRPCRequestFactory buildPutFileWithFileName:file.syncFileName
                                                                 fileType:file.fileType
                                                           persistentFile:file.persistentFile
                                                            correlationId:file.correlationID];
  putFileReq.bulkData = file.bulkData;
  [self.proxy sendRPC:putFileReq];
}

- (BOOL)hasCachedForCorrelationID:(NSNumber *)correlationID
{
  return [self putFileForCorrelationID:correlationID] != nil;
}

- (ZFPutFile *)putFileForCorrelationID:(NSNumber *)correlationID
{
  return self.putFiles[correlationID.stringValue];
}

- (BOOL)inPuttingForFile:(ZFPutFile *)file
{
  return [self.puttingFiles objectForKey:file.correlationID] != nil;
}

- (void)resetPutFilesData
{
  self.putFiles = nil;
  self.puttingFiles = nil;
  self.putHandlers = nil;
}

#pragma mark - Delegate

- (void)onPutFileResponse:(SDLPutFileResponse *)response
{
  if (response == nil) {
    return;
  }
  NSString *correlationID = [NSString stringWithFormat:@"%@", response.correlationID];
  
  ZFPutFile *file = self.puttingFiles[correlationID];
  [self.puttingFiles removeObjectForKey:correlationID];
  
  ZFPutFileHandler handler = self.putHandlers[correlationID];
  
  if ([response.resultCode.value isEqualToString:[SDLResult SUCCESS].value]) {
    if (file) {
      [self.putFiles setValue:file forKey:correlationID];
      handler(YES, response);
      [self.putHandlers removeObjectForKey:correlationID];
      return;
    }
  }
  
  handler(NO, nil);
  [self.putHandlers removeObjectForKey:correlationID];
}

@end
