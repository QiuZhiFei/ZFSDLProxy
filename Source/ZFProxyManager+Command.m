//
//  ZFProxyManager+Command.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+Command.h"
#import "ZFMacros.h"

#import <objc/runtime.h>

@interface ZFProxyManager ()
@property (nonatomic, strong, readonly) NSMutableDictionary *zf_commands;
@end

@implementation ZFProxyManager (Command)

// 这里让 commandID == correlationID 使用
- (void)addCommandWithMenuName:(NSString *)name
                      commands:(NSArray *)commands
                 correlationID:(NSNumber *)correlationID
                       handler:(ZFCommandHandler)handler
{
  [self.zf_commands setValue:handler forKey:correlationID.stringValue];
  SDLAddCommand *command = nil;
  if (name.length > 0) {
    command = [SDLRPCRequestFactory buildAddCommandWithID:correlationID
                                                 menuName:name
                                               vrCommands:commands
                                            correlationID:correlationID];
  } else {
    command = [SDLRPCRequestFactory buildAddCommandWithID:correlationID
                                               vrCommands:commands
                                            correlationID:correlationID];
  }
  
  LogDebug("Add command: %@", command.description);
  [self.proxy sendRPC:command];
}

- (void)onOnCommand:(SDLOnCommand *)notification
{
  LogDebug(@"command: %@", notification.cmdID);
  ZFCommandHandler handler = self.zf_commands[notification.cmdID.stringValue];
  if (handler) {
    handler();
  }
}

- (void)addHelpCommands:(NSArray *)helpCommands
            timeoutText:(NSString *)timeoutText
          correlationID:(NSNumber *)correlationID
startCommandCorrelationID:(NSNumber *)cmdID
                handler:(ZFCommandHandler)handler
{
  
  [self.zf_commands setValue:handler forKey:correlationID.stringValue];
  
}

#pragma mark - Private Methods

- (NSMutableDictionary *)zf_commands
{
  NSMutableDictionary *commands = objc_getAssociatedObject(self, _cmd);
  if (commands == nil) {
    commands = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, commands, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return commands;
}

@end
