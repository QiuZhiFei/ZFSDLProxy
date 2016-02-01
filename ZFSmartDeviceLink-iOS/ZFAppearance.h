//
//  ZFAppearance.h
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/29.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLanguage, UIImage;

@interface ZFAppearance : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) SDLLanguage *lang;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, assign) BOOL isMediaApplication; // default is NO
@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, assign) BOOL restartIfProxyClosed; // default is NO

@end
