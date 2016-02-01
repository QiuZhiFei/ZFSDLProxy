//
//  ZFProxyManager+MediaClockTimer.h
//  Pods
//
//  Created by zhifei on 16/2/3.
//
//

#import "ZFProxyManager.h"

@interface ZFProxyManager (MediaClockTimer)

- (void)sendMediaClockTimerWithUpdateMode:(SDLUpdateMode *)mode
                                startTime:(NSTimeInterval)startTime
                                  endTime:(NSTimeInterval)endTime
                            correlationID:(NSNumber *)correlationID;

@end
