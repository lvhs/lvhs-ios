//
//  LHMovidePlayer.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/3/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHMoviePlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface LHMoviePlayerView ()

@end

@implementation LHMoviePlayerView

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+(Class)layerClass
{
    return [AVPlayerLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
