//
//  ZFProxyManager+PutFile.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+PutFile.h"
#import "ZFPutFile.h"

#import <objc/runtime.h>

@interface ZFProxyManager ()
@property (nonatomic, strong) NSMutableDictionary *zf_putHandlers;
@property (nonatomic, strong) NSMutableDictionary *zf_putFiles;
@property (nonatomic, strong) NSMutableDictionary *zf_puttingFiles;
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
      [self.zf_putHandlers setValue:handler forKey:key];
      if ([self.zf_puttingFiles valueForKey:key]) {
        // 已经在请求中
        return;
      }
      [self.zf_puttingFiles setValue:file forKey:key];
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
  return self.zf_putFiles[correlationID.stringValue];
}

- (BOOL)inPuttingForFile:(ZFPutFile *)file
{
  return [self.zf_puttingFiles objectForKey:file.correlationID] != nil;
}

- (void)resetPutFilesData
{
  self.zf_putFiles = nil;
  self.zf_puttingFiles = nil;
  self.zf_putHandlers = nil;
}

#pragma mark - Delegate

- (void)onPutFileResponse:(SDLPutFileResponse *)response
{
  if (response == nil) {
    return;
  }
  NSString *correlationID = [NSString stringWithFormat:@"%@", response.correlationID];
  
  ZFPutFile *file = self.zf_puttingFiles[correlationID];
  [self.zf_puttingFiles removeObjectForKey:correlationID];
  
  ZFPutFileHandler handler = self.zf_putHandlers[correlationID];
  
  if ([response.resultCode.value isEqualToString:[SDLResult SUCCESS].value]) {
    if (file) {
      [self.zf_putFiles setValue:file forKey:correlationID];
      handler(YES, response);
      [self.zf_putHandlers removeObjectForKey:correlationID];
      return;
    }
  }
  
  handler(NO, nil);
  [self.zf_putHandlers removeObjectForKey:correlationID];
}

#pragma mark - Private Methods

- (void)setZf_putFiles:(NSMutableDictionary *)zf_putFiles
{
  objc_setAssociatedObject(self, @selector(zf_putFiles), zf_putFiles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_putHandlers:(NSMutableDictionary *)zf_putHandlers
{
  objc_setAssociatedObject(self, @selector(zf_putHandlers), zf_putHandlers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_puttingFiles:(NSMutableDictionary *)zf_puttingFiles
{
  objc_setAssociatedObject(self, @selector(zf_puttingFiles), zf_puttingFiles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)zf_putFiles
{
  NSMutableDictionary *dictionary = objc_getAssociatedObject(self, _cmd);
  if (dictionary == nil) {
    dictionary = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return dictionary;
}

- (NSMutableDictionary *)zf_putHandlers
{
  NSMutableDictionary *dictionary = objc_getAssociatedObject(self, _cmd);
  if (dictionary == nil) {
    dictionary = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return dictionary;
}

- (NSMutableDictionary *)zf_puttingFiles
{
  NSMutableDictionary *dictionary = objc_getAssociatedObject(self, _cmd);
  if (dictionary == nil) {
    dictionary = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return dictionary;
}

@end
