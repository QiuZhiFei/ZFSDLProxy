//
//  SDLIAPTransport+Haval.h
//  Pods
//
//  Created by zhifei on 3/17/16.
//  Copyright © 2016 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFSDLProxy.h"
#import "SDLIAPSession.h"
#import "SDLStreamDelegate.h"

@interface SDLIAPTransport (Haval)

- (SDLStreamEndHandler)zf_sdl_dataStreamEndedHandler;

@end
