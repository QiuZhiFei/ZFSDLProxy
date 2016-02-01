//
//  ZFProxyManager+ChoiceSet.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/2/1.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"

typedef void(^ZFChoiceSetHandler)(NSUInteger index);

@interface ZFProxyManager (ChoiceSet)

/**
 *  @param choices                [SDLChoice]
 */
- (void)addChoiceSetsWithID:(NSNumber*)interactionChoiceSetID
                  choiceSet:(NSArray*)choices
              correlationID:(NSNumber*)correlationID
                    handler:(ZFChoiceSetHandler)handler;

- (SDLChoice *)choiceWithName:(NSString *)name
                     choiceID:(NSNumber *)choiceID;

@end
