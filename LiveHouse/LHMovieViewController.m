//
//  LHMovieViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/3/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHMovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LHMovieViewController ()

@property (strong, nonatomic) MPMoviePlayerController *player;
- (IBAction)back:(id)sender;

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
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pv01" ofType:@"mp4" inDirectory:@"Resources/movie/"];
    NSLog(@"%@", path);
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:path]];
    self.player = player;
    // 動画読み込み後に呼ばれるNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:nil
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
    // 動作の再生終了時に呼ばれるNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:nil
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
    player.view.frame = CGRectMake(0, 0, 320, 200);
    [self.view addSubview:player.view];
    
    // 再生開始
    [player prepareToPlay];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
