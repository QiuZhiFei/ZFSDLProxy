//
//  ZFProxyManager+PutFile.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"
@class ZFPutFile;

typedef void(^ZFPutFileHandler)(BOOL success, SDLPutFileResponse *response);

@interface ZFProxyManager (PutFile)

- (void)putFile:(ZFPutFile *)file finished:(ZFPutFileHandler)handler;
- (ZFPutFile *)putFileForCorrelationID:(NSNumber *)correlationID;
- (BOOL)hasCachedForCorrelationID:(NSNumber *)correlationID;

- (void)resetPutFilesData;

@end
