//
//  DOUSDLManager+Manufacturer.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/14.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "DOUSDLManager.h"

typedef NS_ENUM(NSUInteger, ZFSDLManufacturer) {
  ZFSDLManufacturerNone = 0,
  ZFSDLManufacturerFord,
  ZFSDLManufacturerPateo,
  ZFSDLManufacturerHaval,
  ZFSDLManufacturerUnKnown
};

@interface DOUSDLManager (Manufacturer)

@property (nonatomic, assign, readonly) ZFSDLManufacturer manufacturer;

- (void)resetSDLManufacturer:(SDLRegisterAppInterfaceResponse *)response;

+ (BOOL)connectedAccessoryIsHaval;

@end
