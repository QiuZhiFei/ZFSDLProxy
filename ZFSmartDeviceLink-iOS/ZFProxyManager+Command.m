//
//  ZFProxyManager+Command.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+Command.h"

@interface ZFProxyManager ()
@property (nonatomic, strong) NSDictionary *commands;
@end

@implementation ZFProxyManager (Command)

- (void)addCommand:(NSString *)name
     correlationID:(NSNumber *)correlationID
           handler:(ZFCommandHandler)handler
{
  [self.commands setValue:handler forKey:correlationID];
  
}

- (void)onOnCommand:(SDLOnCommand *)notification
{
  NSInteger commandID = notification.cmdID.integerValue;
  
}

@end
