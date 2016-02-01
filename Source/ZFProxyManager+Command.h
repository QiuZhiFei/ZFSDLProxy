//
//  ZFProxyManager+Command.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"

typedef void(^ZFCommandHandler)();

@interface ZFProxyManager (Command)

- (void)addCommandWithMenuName:(NSString *)name
                      commands:(NSArray *)commands
                 correlationID:(NSNumber *)correlationID
                       handler:(ZFCommandHandler)handler;

@end
