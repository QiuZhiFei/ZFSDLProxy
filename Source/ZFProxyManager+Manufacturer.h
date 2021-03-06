//
//  ZFProxyManager+Manufacturer.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 3/3/16.
//  Copyright © 2016 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import <ZFSDLProxy/ZFSDLProxy.h>

typedef NS_ENUM(NSUInteger, ZFSDLManufacturer) {
  ZFSDLManufacturerNone = 0,
  ZFSDLManufacturerFord = 1,
  ZFSDLManufacturerPateo = 2,
  ZFSDLManufacturerHaval = 3,
  ZFSDLManufacturerUnKnown = 4
};

@interface ZFProxyManager (Manufacturer)

@property (nonatomic, assign, readonly) ZFSDLManufacturer manufacturer;

- (void)resetSDLManufacturer:(SDLRegisterAppInterfaceResponse *)response;

+ (BOOL)isHavalValidAccessoryConnected;
+ (BOOL)isSDLValidAccessoryConnected;

@end
