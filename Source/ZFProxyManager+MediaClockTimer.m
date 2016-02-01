//
//  ZFProxyManager+MediaClockTimer.m
//  Pods
//
//  Created by zhifei on 16/2/3.
//
//

#import "ZFProxyManager+MediaClockTimer.h"

@implementation ZFProxyManager (MediaClockTimer)

- (void)sendMediaClockTimerWithUpdateMode:(SDLUpdateMode *)mode
                                startTime:(NSTimeInterval)startTime
                                  endTime:(NSTimeInterval)endTime
                            correlationID:(NSNumber *)correlationID
{
  SDLSetMediaClockTimer *scmt = [[SDLSetMediaClockTimer alloc] init];
  scmt.startTime = [self _timeIntervalToStartTime:startTime];
  scmt.endTime = [self _timeIntervalToStartTime:endTime];
  scmt.updateMode = mode;
  scmt.correlationID = correlationID;
  [self.proxy sendRPC:scmt];
}

#pragma mark - Private Methods

- (SDLStartTime *)_timeIntervalToStartTime:(NSTimeInterval)time
{
  int hour = time/3600;
  int minutes = (time - hour * 3600)/60;
  int seconds = time - hour * 3600 - minutes * 60;
  SDLStartTime *startTime = [[SDLStartTime alloc] init];
  startTime.hours = [NSNumber numberWithInt:hour];
  startTime.minutes = [NSNumber numberWithInt:minutes];
  startTime.seconds = [NSNumber numberWithInt:seconds];
  return startTime;
}


@end
