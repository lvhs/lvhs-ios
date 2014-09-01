//
//  LHPlayerController.h
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/1/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHAudioPlayer.h"

@interface LHPlayerController : UIViewController

@property (nonatomic, strong) LHAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;

@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;

@end