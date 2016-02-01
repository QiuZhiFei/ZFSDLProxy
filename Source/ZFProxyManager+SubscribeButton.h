//
//  ZFProxyManager+SubscribeButton.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"

typedef void(^ZFSubscribeHandler)();

@interface ZFProxyManager (SubscribeButton)

- (void)addSubscribeButtonWithName:(SDLButtonName *)name
                     correlationID:(NSNumber *)correlationID
                           handler:(ZFSubscribeHandler)handler;

@end
