//
//  LHAudioPlayer.h
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/1/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LHAudioPlayer : UIViewController

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

// Public methods
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension;
- (void)playAudio;
- (void)pauseAudio;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString*)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;

@end