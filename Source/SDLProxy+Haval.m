//
//  SDLProxy+Haval.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 3/3/16.
//  Copyright © 2016 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "SDLProxy+Haval.h"
#import "ZFProxyManager+Manufacturer.h"

#import <objc/runtime.h>

static const UInt8 ZFSessionIDNone = 0;

@interface SDLProxy ()

@end

@implementation SDLProxy (Haval)

- (void)zf_onProtocolMessageReceived:(SDLProtocolMessage *)msgData
{
  UInt8 sessionID = msgData.header.sessionID;
  LogDebug(@"Receive SessionID == %d, currentID == %d", sessionID, self.sessionID);
  if ([ZFProxyManager isHavalValidAccessoryConnected]) {
//    if (self.sessionID == ZFSessionIDNone) {
//      LogDebug(@"Set sessionID == %d, oldID == %d", sessionID, self.sessionID);
//      self.sessionID = sessionID;
//    }
    if (self.sessionID == sessionID) {
      LogDebug(@"SessionID is valid, receiveID == %d, currentID == %d", sessionID, self.sessionID);
      [self zf_onProtocolMessageReceived:msgData];
    } else {
      LogDebug(@"SessionID is invalid, receiveID == %d, currentID == %d", sessionID, self.sessionID);
    }
  } else {
    [self zf_onProtocolMessageReceived:msgData];
  }
}

- (void)_resetSeesionID
{
  self.sessionID = ZFSessionIDNone;
}

- (UInt8)sessionID
{
  id value = objc_getAssociatedObject(self, _cmd);
  if (value == nil) {
    return ZFSessionIDNone;
  }
  return [value integerValue];
}

- (void)setSessionID:(UInt8)sessionID
{
  objc_setAssociatedObject(self,
                           @selector(sessionID),
                           [NSNumber numberWithInteger:sessionID],
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
