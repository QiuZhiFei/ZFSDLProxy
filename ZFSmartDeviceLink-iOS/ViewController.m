//
//  ViewController.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ViewController.h"
#import "DOUSDLManager.h"
#import "DOUSDLManager+Manufacturer.h"
#import "ZFRadioStation.h"
#import "ZFSong.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self _proxyStateChanged];
  [self _updateSongInfo];
  
  // HAVAL 需要在连接配件后开启服务
  if ([DOUSDLManager connectedAccessoryIsHaval]) {
    [[NSNotificationCenter defaultCenter] addObserverForName:EAAccessoryDidConnectNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                    LogDebug(@"Accessory Did Connect");
                                                    [[DOUSDLManager sharedManager] startProxy];
                                                  }];
  } else {
    [[DOUSDLManager sharedManager] startProxy];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_proxyStateChanged)
                                               name:kZFProxyStateChangedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_updateSongInfo)
                                               name:kZFRadioStationSongChangedNotification
                                             object:nil];
  
  // Do any additional setup after loading the view, typically from a nib.
}



#pragma mark - IBActions

- (IBAction)connectButtonWasPressed:(UIButton *)sender
{
  [[DOUSDLManager sharedManager] toggleProxy];
}

- (IBAction)_previousButtonWasPressed:(id)sender
{
  [[ZFRadioStation sharedRadioStation] skipSong];
}

- (IBAction)_toggleButtonWasPressed:(id)sender
{
  [[ZFRadioStation sharedRadioStation] toggleAudioPlaying];
}

- (IBAction)_skipButtonWasPressed:(id)sender
{
  [[ZFRadioStation sharedRadioStation] skipSong];
}

#pragma mark - Private Methods

- (void)_proxyStateChanged
{
  LogDebug(@"proxy state changed, current state == %lu", (unsigned long)[[DOUSDLManager sharedManager] state]);
  NSString *state = nil;
  switch ([[DOUSDLManager sharedManager] state]) {
    case ZFProxyStateConnected:
      state = @"Current: Connected";
      break;
    case ZFProxyStateSearchingForConnection:
      state = @"Current: SearchingForConnection";
      break;
    case ZFProxyStateStopped:
      state = @"Current: Stopped";
      break;
    default:
      break;
  }
  [self.connectButton setTitle:state
                      forState:UIControlStateNormal];
}

- (void)_updateSongInfo
{
  self.songTitle.text = [[[ZFRadioStation sharedRadioStation] curSong] title];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
