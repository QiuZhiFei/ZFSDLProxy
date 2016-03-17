//
//  SDLIAPTransport+Haval.m
//  Pods
//
//  Created by zhifei on 3/17/16.
//  Copyright © 2016 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "SDLIAPTransport+Haval.h"

@implementation SDLIAPTransport (Haval)

- (SDLStreamEndHandler)zf_sdl_dataStreamEndedHandler
{  
  SDLStreamEndHandler handler = [self zf_sdl_dataStreamEndedHandler];
  
  typeof(self) __weak wself = self;
  SDLStreamEndHandler resultHandler = ^(NSStream *stream){
    if (handler) {
      handler(stream);
    }
    if ([ZFProxyManager isHavalValidAccessoryConnected]) {
      [wself.delegate onTransportDisconnected];
    }
  };
  
  return resultHandler;
}

@end
