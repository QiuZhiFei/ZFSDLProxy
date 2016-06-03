//
//  SDLProxy+Haval.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 3/3/16.
//  Copyright © 2016 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFSDLProxy.h"

@interface SDLProxy (Haval)

- (void)zf_onProtocolMessageReceived:(SDLProtocolMessage *)msgData;

- (void)_resetSeesionID;

@property (nonatomic, assign) UInt8 sessionID; // only haval, default is 0

@end
