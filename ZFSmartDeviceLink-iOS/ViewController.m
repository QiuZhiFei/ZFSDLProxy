//
//  ViewController.m
//  ZFSmartDeviceLink-iOS
//
//  Created by zhifei on 16/1/28.
//  Copyright © 2016年 ZhiFei(qiuzhifei521@gmail.com). All rights reserved.
//

#import "ViewController.h"
#import "ZFRadioStation.h"
#import "ZFSong.h"
#import "DOUSDLManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSArray *imageURLs = @[@"http://img1.imgtn.bdimg.com/it/u=1768261506,2972859401&fm=21&gp=0.jpg",
                         @"http://img3.imgtn.bdimg.com/it/u=1284416964,1606791513&fm=21&gp=0.jpg",
                         @"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg"];
  NSMutableArray *songs = [NSMutableArray array];
  for (int i = 0; i < 3; i ++) {
    ZFSong *song = [[ZFSong alloc] init];
    song.title = [NSString stringWithFormat:@"title - %d", i];
    song.artist = [NSString stringWithFormat:@"artist - %d", i];
    song.audioFileURL = [NSURL URLWithString:@"http://douban.fm/misc/mp3url?domain=mr7"];
    song.albumCoverUrl = [NSURL URLWithString:imageURLs[i]];
    song.likeit = NO;
    song.collected = NO;
    [songs addObject:song];
  }
  [[ZFRadioStation sharedRadioStation] playSongList:songs atIndex:0];

  
  [self _proxyStateChanged];
  [self _updateSongInfo];
  
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
