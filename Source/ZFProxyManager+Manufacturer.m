//
//  ZFProxyManager+Manufacturer.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 3/3/16.
//  Copyright © 2016 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+Manufacturer.h"

#import <objc/runtime.h>

@implementation ZFProxyManager (Manufacturer)

- (void)resetSDLManufacturer:(SDLRegisterAppInterfaceResponse *)response
{
  NSString *make = response.vehicleType.make;
  LogDebug(@"SDLManufacturer make == %@", make);
  ZFSDLManufacturer manufacturer = ZFSDLManufacturerNone;
  if (make) {
    manufacturer = ZFSDLManufacturerUnKnown;
    if ([make isEqualToString:@"Ford"]) {
      manufacturer = ZFSDLManufacturerFord;
    } else if ([make isEqualToString:@"HAVAL"]) {
      manufacturer = ZFSDLManufacturerHaval;
    } else if ([make isEqualToString:@"Pateo"]) {
      manufacturer = ZFSDLManufacturerPateo;
    }
  }
  self.manufacturer = manufacturer;
}

- (ZFSDLManufacturer)manufacturer
{
  ZFSDLManufacturer manufacturer = ZFSDLManufacturerNone;
  id value = objc_getAssociatedObject(self, _cmd);
  if (value) {
    manufacturer = [value integerValue];
  }
  return manufacturer;
}

- (void)setManufacturer:(ZFSDLManufacturer)manufacturer
{
  objc_setAssociatedObject(self,
                           @selector(manufacturer),
                           [NSNumber numberWithInteger:manufacturer],
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isHavalValidAccessoryConnected
{
  __block BOOL isConnected = NO;
  [[[EAAccessoryManager sharedAccessoryManager] connectedAccessories] enumerateObjectsUsingBlock:^(EAAccessory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj.manufacturer isEqualToString:@"Delphi E&S"]) {
      isConnected = YES;
      *stop = YES;
    };
  }];
  return isConnected;
}

+ (BOOL)isSDLValidAccessoryConnected
{
  NSString *const legacyProtocolString = @"com.ford.sync.prot0";
  NSString *const controlProtocolString = @"com.smartdevicelink.prot0";
  for (EAAccessory* accessory in [[EAAccessoryManager sharedAccessoryManager] connectedAccessories]) {
    for (NSString* protocolString in [accessory protocolStrings]) {
      if ([protocolString isEqualToString:legacyProtocolString]
          || [protocolString isEqualToString:controlProtocolString]) {
        return YES;
      }
    }
  }
  return NO;
}

@end
