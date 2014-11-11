//
//  LHMovieViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/3/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHMovieViewController.h"
#import "LHMoviePlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <XCDYouTubeKit/XCDYouTubeKit.h>

@class AVPlayer;

@interface LHMovieViewController ()
{
    LHMoviePlayerView *playerView;
    AVPlayer *player;
    BOOL isPlaying;
}

//@property (strong, nonatomic) MPMoviePlayerController *player;
@property (weak, nonatomic) IBOutlet UIView *screen;
- (IBAction)back:(id)sender;
- (IBAction)togglePlayer:(id)sender;

@end

@implementation LHMovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSInteger artistId = [defaults integerForKey:@"artistId"];
    NSString *itemId = [defaults stringForKey:@"itemId"];
    
    if ([itemId isEqualToString:@"21"]) {
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"6-XjbdSAkOI"];
        [videoPlayerViewController presentInView:_screen];
        [videoPlayerViewController.moviePlayer play];
        return;
    }
    else if ([itemId isEqualToString:@"41"]) {
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"v6kwUZQN7mU"];
        [videoPlayerViewController presentInView:_screen];
        [videoPlayerViewController.moviePlayer play];
        return;
    }
    else if ([itemId isEqualToString:@"31"]) {
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"0Hv9_0uMnoo"];
        [videoPlayerViewController presentInView:_screen];
        [videoPlayerViewController.moviePlayer play];
        return;
    }
    
    // Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    
    //プレイヤーを設定
    float playerHeight = self.view.frame.size.height-(self.view.frame.size.height/2);
    player = [[AVPlayer alloc] initWithURL:url];
    playerView = [[LHMoviePlayerView alloc]initWithFrame:CGRectMake(0,
                                                               50,
                                                               self.view.frame.size.width,
                                                               playerHeight)];
    //*1で説明したAVPlayerとViewとを紐づける処理
    [(AVPlayerLayer*)playerView.layer setPlayer:player];
    
    [self.view addSubview:playerView];
    [self.view bringSubviewToFront:playerView];
    
    isPlaying = YES;
    
    //ステータスの変更を受け取るオブサーバの設定
    [player addObserver:self
             forKeyPath:@"status"
                options:NSKeyValueObservingOptionNew
                context:&player];
}

#pragma mark - ステータス変更時に呼ばれるオブサーバ（１）
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    //再生準備が整い次第、動画を再生させる。
    if([player status] == AVPlayerItemStatusReadyToPlay){
        
        [player removeObserver:self forKeyPath:@"status"];
        
        [player play];
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    NSLog(@"stop!!");
    [player pause];
    isPlaying = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)togglePlayer:(id)sender {
    if (isPlaying) {
        [player pause];
        isPlaying = NO;
    } else {
        [player play];
        isPlaying = YES;
    }
}

id timeObserver;
-(void)MoviePlay
{
    //0.5秒おきにスライダーを更新する
    CMTime time = CMTimeMakeWithSeconds(0.5f, NSEC_PER_SEC);
    __block LHMovieViewController *blockself = self; //ARCを使用している場合
    timeObserver = [player addPeriodicTimeObserverForInterval:time
                                                        queue:dispatch_get_main_queue()
                                                   usingBlock:^(CMTime time) {
                                                       Float64 sec = CMTimeGetSeconds(time);
                                                       [blockself upDateTimeSlider:sec];
                                                       //ARC不使用時は[self upDateTimeSlider:sec];
                                                   }];
}

-(void)upDateTimeSlider:(Float64)sec
{
//    timeSlider.value = sec;
}

//オブサーバは任意のタイミングでリムーブする
-(void)viewDidDisappear:(BOOL)animated
{
    if(timeObserver){
        [player removeTimeObserver:timeObserver];
    }
    
}

#pragma mark - スライダーの値が変更されたときに呼ばれるメソッド
- (void)slider_ValueChanged:(id)sender
{
    UISlider *slider = sender;
    CMTime time = CMTimeMakeWithSeconds(slider.value, NSEC_PER_SEC);
    [player seekToTime:time];
    
}

@end
