//
//  ZFProxyManager+SoftButton.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"

typedef void(^ZFSoftButtonHandler)();

@interface ZFProxyManager (SoftButton)

- (SDLSoftButton *)zf_buildSDLSoftButtonText:(NSString *)text
                                       image:(SDLImage *)image
                                softButtonID:(NSNumber *)softButtonID
                                     handler:(ZFSoftButtonHandler)handler;

@end
