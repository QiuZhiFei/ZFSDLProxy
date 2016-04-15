//
//  ZFProxyManager+SoftButton.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+SoftButton.h"
#import "ZFMacros.h"

#import <objc/runtime.h>

@interface ZFProxyManager ()
@property (nonatomic, strong, readonly) NSMutableDictionary *zf_softButtons;
@end

@implementation ZFProxyManager (SoftButton)

- (SDLSoftButton *)zf_buildSDLSoftButtonText:(NSString *)text
                                       image:(SDLImage *)image
                                softButtonID:(NSNumber *)softButtonID
                                     handler:(ZFSoftButtonHandler)handler
{
  LogDebug(@"Build SDLSoftButton: buttonID == %@", softButtonID);
  SDLSoftButton *button = [[SDLSoftButton alloc] init];
  button.text = text;
  button.image = image;
  button.softButtonID = softButtonID;
  [self checkoutButtonType:button];
  [self.zf_softButtons setValue:handler forKey:softButtonID.stringValue];
  
  return button;
}

- (void)checkoutButtonType:(SDLSoftButton *)button
{
  if (button.image) {
    button.type = button.text.length > 0 ? [SDLSoftButtonType BOTH] : [SDLSoftButtonType IMAGE];
  } else {
    button.type = [SDLSoftButtonType TEXT];
  }
  LogDebug(@"button == %@, text == %@, image == %@, type == %@", button, button.text, button.image, button.type);
}

- (void)onOnButtonPress:(SDLOnButtonPress *)notification
{
  LogDebug(@"SDLSoftButton: buttonID == %@", notification.customButtonID);
  ZFSoftButtonHandler handler = self.zf_softButtons[notification.customButtonID.stringValue];
  if (handler) {
    handler();
  }
}

#pragma mark - Prviate Methods

- (NSMutableDictionary *)zf_softButtons
{
  NSMutableDictionary *buttons = objc_getAssociatedObject(self, _cmd);
  if (buttons == nil) {
    buttons = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, buttons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return buttons;
}

@end
