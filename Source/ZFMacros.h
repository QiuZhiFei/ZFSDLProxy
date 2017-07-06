//
//  ZFMacros.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#if DEBUG
#define LogDebug(fmt, ...) NSLog((@"ZFSDLDEBUG: %@ %s ~ ~   " fmt), [NSThread currentThread],__FUNCTION__, ##__VA_ARGS__)
#else
#define LogDebug(...)
#endif

