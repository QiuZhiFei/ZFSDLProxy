//
//  ZFProxyManager+Message.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager+Message.h"
#import "ZFMacros.h"

@implementation ZFProxyManager (Message)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  duration:(NSInteger)duration
{
  SDLAlert *alertReq = [SDLRPCRequestFactory buildAlertWithAlertText1:title
                                                           alertText2:message
                                                             duration:[NSNumber numberWithInteger:duration]
                                                        correlationID:self.autoIncCorrIDNum];
  [self.proxy sendRPC:alertReq];
}

- (void)speakWithTTS:(NSString *)ttsText
{
  [self.proxy sendRPC:[SDLRPCRequestFactory buildSpeakWithTTS:ttsText
                                                correlationID:self.autoIncCorrIDNum]];
}

- (void)showMessageWithField1:(NSString *)field1
                       field2:(NSString *)field2
                   mediaTrack:(NSString *)mediaTrack
                      graphic:(SDLImage *)graphic
                  softButtons:(NSArray *)buttons
{
  LogDebug(@"Show message, field == %@", field1);
  SDLShow *msg = [SDLRPCRequestFactory buildShowWithMainField1:field1
                                                    mainField2:field2
                                                    mainField3:nil
                                                    mainField4:nil
                                                     statusBar:nil
                                                    mediaClock:nil
                                                    mediaTrack:mediaTrack
                                                     alignment:[SDLTextAlignment LEFT_ALIGNED]
                                                       graphic:graphic
                                                   softButtons:buttons
                                                 customPresets:nil
                                                 correlationID:[self autoIncCorrIDNum]];
  [self.proxy sendRPC:msg];
}

- (void)showPerformInteractionWithInitialPrompt:(NSString *)initialPrompt
                                    initialText:(NSString *)initialText
                         interactionChoiceSetID:(NSNumber *)interactionChoiceSetID

{
  SDLPerformInteraction *req = [SDLRPCRequestFactory
                                buildPerformInteractionWithInitialPrompt:initialPrompt
                                initialText:initialText
                                interactionChoiceSetID:interactionChoiceSetID
                                correlationID:self.autoIncCorrIDNum];
  req.interactionMode = [SDLInteractionMode MANUAL_ONLY];
  [self.proxy sendRPC:req];
}


@end
