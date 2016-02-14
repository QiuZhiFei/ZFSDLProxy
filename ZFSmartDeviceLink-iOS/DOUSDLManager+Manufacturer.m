//
//  DOUSDLManager+Manufacturer.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/14.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "DOUSDLManager+Manufacturer.h"

#import <objc/runtime.h>

@implementation DOUSDLManager (Manufacturer)

- (void)resetSDLManufacturer:(SDLRegisterAppInterfaceResponse *)response
{
  NSString *make = response.vehicleType.make;
  ZFSDLManufacturer manufacturer = ZFSDLManufacturerNone;
  if (make) {
    manufacturer = ZFSDLManufacturerUnKnown;
    if ([make isEqualToString:@"Ford"]) {
      manufacturer = ZFSDLManufacturerFord;
    } else if ([make isEqualToString:@"Haval"]) {
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

+ (BOOL)connectedAccessoryIsHaval
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

@end
