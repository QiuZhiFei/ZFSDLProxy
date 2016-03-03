//
//  ZFProxyManager+ChoiceSet.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+ChoiceSet.h"
#import "ZFMacros.h"

#import <objc/runtime.h>

@interface ZFProxyManager ()
@property (nonatomic, strong, readonly) NSMutableDictionary *zf_choiceSets;
@end

@implementation ZFProxyManager (ChoiceSet)

- (void)addChoiceSetsWithID:(NSNumber*)interactionChoiceSetID
                  choiceSet:(NSArray*)choices
              correlationID:(NSNumber*)correlationID
                    handler:(ZFChoiceSetHandler)handler
{
  NSMutableArray *ids = [NSMutableArray arrayWithCapacity:choices.count];
  [choices enumerateObjectsUsingBlock:^(SDLChoice *choice, NSUInteger idx, BOOL * _Nonnull stop) {
    [ids addObject:choice.choiceID];
  }];
  if (handler) {
    [self.zf_choiceSets setValue:@[ids, handler] forKey:correlationID.stringValue];
  }
  SDLCreateInteractionChoiceSet *choiceSetReq = [SDLRPCRequestFactory buildCreateInteractionChoiceSetWithID:interactionChoiceSetID
                                                                                                  choiceSet:choices
                                                                                              correlationID:correlationID];
  
  [self.proxy sendRPC:choiceSetReq];
}

- (void)deleteChoiceSetsWithID:(NSNumber*)interactionChoiceSetID
{
  SDLDeleteInteractionChoiceSet *deleteReq = [SDLRPCRequestFactory buildDeleteInteractionChoiceSetWithID:interactionChoiceSetID
                                                                                           correlationID:[self autoIncCorrIDNum]];
  [self.proxy sendRPC:deleteReq];
}

- (SDLChoice *)choiceWithName:(NSString *)name
                     choiceID:(NSNumber *)choiceID
{
  SDLChoice *choice = [[SDLChoice alloc] init];
  choice.menuName = name;
  choice.vrCommands = [NSMutableArray arrayWithObjects:name, nil];
  choice.choiceID = choiceID;
  return choice;
}

- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response
{
  if ([response.resultCode isEqual:[SDLResult SUCCESS]]) {
    __block NSArray *choiceHandlers = nil;
    [self.zf_choiceSets enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray *tmpChoiceHandlers, BOOL * _Nonnull stop) {
      if ([tmpChoiceHandlers[0] containsObject:response.choiceID]) {
        choiceHandlers = tmpChoiceHandlers;
        *stop = YES;
      }
    }];
    
    if (choiceHandlers) {
      NSArray *ids = choiceHandlers[0];
      ZFChoiceSetHandler handler = choiceHandlers[1];
      handler([ids indexOfObject:response.choiceID]);
    }
  }
}

#pragma mark - Private Methods

- (NSMutableDictionary *)zf_choiceSets
{
  NSMutableDictionary *choiceSets = objc_getAssociatedObject(self, _cmd);
  if (choiceSets == nil) {
    choiceSets = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, choiceSets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return choiceSets;
}

@end
