//
//  STLVideoViewController.m
//  STLBGVideo
//
//  Created by StoneLeon on 16/1/13.
//  Copyright © 2016年 StoneLeon. All rights reserved.
//

#import "STLVideoViewController.h"
#import "STLVideoFunctions.h"
#import "Header.h"

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface STLVideoViewController ()

@property (nonatomic,strong) MPMoviePlayerController *player;

@property (nonatomic,strong) AVAudioSession *avaudioSession;

@property (nonatomic,assign) BOOL isLoop;

@end

@implementation STLVideoViewController

#pragma mark - allow background music still play
- (void)stillPlayMusic {

    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
}

#pragma mark - Player
- (void)getPlayerNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerStateChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
}

- (void)preparePlayback {
    if (self.player == nil) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[STLVideoFunctions getVideoUrl] ofType:[STLVideoFunctions getVideoType]]];
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [self.player setControlStyle:MPMovieControlStyleNone];
        [self.player prepareToPlay];
        [self.player.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:self.player.view];
        [self.view sendSubviewToBack:self.player.view];
        self.player.scalingMode = MPMovieScalingModeAspectFill;

    }

}

#pragma mark - Notifications
- (void)moviePlayerStateChangeNotification:(NSNotification *)notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    
    switch (playbackState) {
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped:
        case MPMoviePlaybackStateInterrupted:{
            
            if (self.isLoop) {
                moviePlayer.controlStyle = MPMovieControlStyleNone;
                [self.player play];
            }
            
            break;
            
        }
            
            
        default:
            break;
    }
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self stillPlayMusic];

    if ([STLVideoFunctions getUrlInfo] != nil) {
        self.isLoop = [STLVideoFunctions getLoopMode];
        
        [self preparePlayback];
    }
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self getPlayerNotifications];
    
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    [self.player pause];
}
@end
