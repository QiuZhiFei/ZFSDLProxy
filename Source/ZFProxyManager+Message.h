//
//  ZFProxyManager+Message.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFProxyManager.h"

@interface ZFProxyManager (Message)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  duration:(NSInteger)duration;

- (void)speakWithTTS:(NSString *)ttsText;

- (void)showMessageWithField1:(NSString *)field1
                       field2:(NSString *)field2
                   mediaTrack:(NSString *)mediaTrack
                      graphic:(SDLImage *)graphic
                  softButtons:(NSArray *)buttons;

- (void)showPerformInteractionWithInitialPrompt:(NSString *)initialPrompt
                                    initialText:(NSString *)initialText
                         interactionChoiceSetID:(NSNumber *)interactionChoiceSetID;
@end
