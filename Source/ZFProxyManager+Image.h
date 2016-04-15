//
//  ZFProxyManager+Image.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"

@class UIImage;

typedef void(^ZFPutImageHandler)(BOOL success, SDLPutFileResponse *response);

@interface ZFProxyManager (Image)

- (void)putImage:(UIImage *)image
            name:(NSString *)name
   correlationID:(NSNumber *)correlationID
        finished:(ZFPutImageHandler)handler;

- (void)putImage:(UIImage *)image
            name:(NSString *)name
        fileType:(SDLFileType *)fileType
   correlationID:(NSNumber *)correlationID
        finished:(ZFPutImageHandler)handler;

- (SDLImage *)SDLImageNamed:(NSString *)name;

@end
