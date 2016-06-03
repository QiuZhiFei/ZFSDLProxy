//
//  SDLProtocol+Haval.m
//  Pods
//
//  Created by zhifei on 16/6/3.
//
//

#import "SDLProtocol+Haval.h"
#import "ZFProxyManager+Manufacturer.h"

NSString * const kZFProxyRetrieveSessionID = @"kZFProxyRetrieveSessionID";

@implementation SDLProtocol (Haval)

- (UInt8)zf_retrieveSessionIDforServiceType:(SDLServiceType)serviceType
{
  UInt8 sessionID = [self zf_retrieveSessionIDforServiceType:serviceType];
  LogDebug(@"retrieve session id == %ld", sessionID);
  [[NSNotificationCenter defaultCenter] postNotificationName:kZFProxyRetrieveSessionID object:[NSNumber numberWithInteger:sessionID]];
  return sessionID;
}


@end
