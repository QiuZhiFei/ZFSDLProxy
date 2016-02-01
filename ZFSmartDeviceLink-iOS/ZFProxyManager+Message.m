//
//  ZFProxyManager+Message.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+Message.h"

@implementation ZFProxyManager (Message)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  duration:(NSInteger)duration
{
  SDLAlert *alertReq = [SDLRPCRequestFactory buildAlertWithAlertText1:title
                                                           alertText2:message
                                                             duration:[NSNumber numberWithInteger:duration]
                                                        correlationID:self.autoIncCorrIDNum];
  [self.proxy sendRPC:alertReq];
}

@end
