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

@interface ZFProxyManager ()
@property (nonatomic, strong) NSMutableDictionary *putImages;
@end

@implementation ZFProxyManager (Image)

- (void)putImage:(UIImage *)image
            name:(NSString *)name
   correlationID:(NSNumber *)correlationID
        finished:(ZFPutImageHandler)handler;
{
  NSData *data = UIImageJPEGRepresentation(image, 1);
  if (data == nil) {
    data = UIImagePNGRepresentation(image);
  }
#pragma message "需要设置图片的大小限制"
  if (data) {
    [self.putImages setValue:correlationID forKey:name];
    ZFPutFile *file = [ZFPutFile fileWithFileName:name
                                         bulkData:data
                                         fileType:[[self class] _typeForImageData:data]
                                 persisistentFile:[NSNumber numberWithBool:0]
                                    correlationID:correlationID];
    [self putFile:file finished:handler];
  }
}

- (SDLImage *)SDLImageNamed:(NSString *)name
{
  SDLImage *image = nil;
  ZFPutFile *file = [self putFileForCorrelationID:self.putImages[name]];
  if (file) {
    image = [[SDLImage alloc] init];
    image.value = file.syncFileName;
    image.imageType = [SDLImageType DYNAMIC];
  }
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

@end
