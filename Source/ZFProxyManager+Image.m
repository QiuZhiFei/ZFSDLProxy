//
//  ZFProxyManager+Image.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+Image.h"
#import "ZFPutFile.h"
#import "ZFProxyManager+PutFile.h"
#import "ZFMacros.h"

#import <objc/runtime.h>

@interface ZFProxyManager ()
@property (nonatomic, strong) NSMutableDictionary *zf_putImages;
@end

@implementation ZFProxyManager (Image)

- (void)putImage:(UIImage *)image
            name:(NSString *)name
   correlationID:(NSNumber *)correlationID
        finished:(ZFPutImageHandler)handler
{
  NSData *data = UIImageJPEGRepresentation(image, 1);
  if (data == nil) {
    data = UIImagePNGRepresentation(image);
  }
  if (data) {
    [self putImage:image
              name:name
          fileType:[[self class] _typeForImageData:data]
     correlationID:correlationID
          finished:handler];
  }
}

- (void)putImage:(UIImage *)image
            name:(NSString *)name
        fileType:(SDLFileType *)fileType
   correlationID:(NSNumber *)correlationID
        finished:(ZFPutImageHandler)handler
{
  NSData *data = UIImageJPEGRepresentation(image, 1);
  if (data == nil) {
    data = UIImagePNGRepresentation(image);
  }
  LogDebug(@"Put Image == %@  size == %@", name, NSStringFromCGSize(image.size));
#pragma message "需要设置图片的大小限制"
  if (data) {
    [self.zf_putImages setValue:correlationID forKey:name];
    ZFPutFile *file = [ZFPutFile fileWithFileName:name
                                         bulkData:data
                                         fileType:fileType
                                 persisistentFile:[NSNumber numberWithBool:0]
                                    correlationID:correlationID];
    [self putFile:file finished:handler];
  }
}

- (SDLImage *)SDLImageNamed:(NSString *)name
{
  SDLImage *image = nil;
  ZFPutFile *file = [self putFileForCorrelationID:self.zf_putImages[name]];
  if (file) {
    image = [[SDLImage alloc] init];
    image.value = file.syncFileName;
    image.imageType = [SDLImageType DYNAMIC];
  }
  LogDebug(@"get image, name == %@, in Images == %@, image == %@", name, self.zf_putImages, image);
  return image;
}

#pragma mark - Private Methods

+ (SDLFileType *)_typeForImageData:(NSData *)data
{
  uint8_t c;
  [data getBytes:&c length:1];
  
  switch (c) {
    case 0xFF:
      return [SDLFileType GRAPHIC_JPEG];
    case 0x89:
      return [SDLFileType GRAPHIC_PNG];
  }
  return nil;
}

#pragma mark - Private Methods

- (NSMutableDictionary *)zf_putImages
{
  NSMutableDictionary *putImages = objc_getAssociatedObject(self, _cmd);
  if (putImages == nil) {
    putImages = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, putImages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return putImages;
}

@end
