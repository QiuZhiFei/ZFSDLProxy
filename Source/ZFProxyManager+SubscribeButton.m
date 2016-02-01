//
//  ZFProxyManager+SubscribeButton.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+SubscribeButton.h"
#import "ZFMacros.h"

#import <objc/runtime.h>

@interface ZFProxyManager ()
@property (nonatomic, strong, readonly) NSMutableDictionary *zf_subscribeButtons;
@end

@implementation ZFProxyManager (SubscribeButton)

- (void)addSubscribeButtonWithName:(SDLButtonName *)name
                     correlationID:(NSNumber *)correlationID
                           handler:(ZFSubscribeHandler)handler
{
#pragma message "这里使用 name 可能会有问题"
  [self.zf_subscribeButtons setValue:handler forKey:name.value];
  LogDebug(@"SDLButton: name == %@", name.value);
  SDLSubscribeButton *button = [SDLRPCRequestFactory buildSubscribeButtonWithName:name
                                                                    correlationID:correlationID];
  [self.proxy sendRPC:button];
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification
{
  LogDebug(@"SubscribeButton: name == %@", notification.buttonName.value);
  if ([notification.buttonEventMode isEqual:[SDLButtonEventMode BUTTONDOWN]]) {
    ZFSubscribeHandler handler = self.zf_subscribeButtons[notification.buttonName.value];
    if (handler) {
      handler();
    }
  }
}

#pragma mark - Private Methods

- (NSMutableDictionary *)zf_subscribeButtons
{
  NSMutableDictionary *buttons = objc_getAssociatedObject(self, _cmd);
  if (buttons == nil) {
    buttons = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, buttons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return buttons;
}

@end
