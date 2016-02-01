//
//  ZFAppearance.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFAppearance.h"

@implementation ZFAppearance

- (id)init
{
  self = [super init];
  if (self) {
    _restartIfProxyClosed = NO;
    _isMediaApplication = NO;
  }
  return self;
}

@end
