//
//  ZFProxyManager+ChoiceSet.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+ChoiceSet.h"

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
                                                                                              correlationID:[self autoIncCorrIDNum]];
  
  [self.proxy sendRPC:choiceSetReq];
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
    NSMutableArray *ids = self.zf_choiceSets[response.correlationID.stringValue][0];
    ZFChoiceSetHandler handler = self.zf_choiceSets[response.correlationID.stringValue][1];
    if ([ids containsObject:response.choiceID] && handler) {
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
