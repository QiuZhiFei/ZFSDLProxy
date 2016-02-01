//
//  DOUSDLManager.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFSDLProxy.h"

@interface DOUSDLManager : NSObject

@property (nonatomic, assign) ZFProxyState state;

+ (instancetype)sharedManager;

- (void)startProxy;
- (void)stopProxy;
- (void)toggleProxy;

@end
