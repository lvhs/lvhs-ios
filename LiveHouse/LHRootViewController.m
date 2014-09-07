//
//  LHRootViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/31/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHRootViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

@interface LHRootViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *overLay;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)goArtist:(id)sender;
- (IBAction)toggleMenu:(id)sender;

@end

@implementation LHRootViewController

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
    
    // メニューアイコン
    FAKFontAwesome *menuIcon = [FAKFontAwesome barsIconWithSize:16];
    [menuIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    _menuBtn.image = [menuIcon imageWithSize:CGSizeMake(15, 15)];
    [_menuBtn setAction:@selector(toggleMenu:)];
    
    // メニュー
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleMenu:(id)sender {
    NSLog(@"toggled!");
    _menuView.hidden = !_menuView.hidden;
    _overLay.hidden = !_overLay.hidden;
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

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"menu_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *items = @[
                       @"お知らせ",
                       @"アーティスト一覧",
                       @"プレイリスト",
                       @"友達紹介",
                       @"設定・問い合わせ",
                       @"レビュー"
                       ];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    // セルの内容はNSArray型の「items」にセットされているものとする
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMenu:)];
    [cell setTag:indexPath.row];
    [cell addGestureRecognizer:tapGesture];
    
    return cell;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    NSLog(@"prepareForSegue");
//    if([[segue identifier] isEqualToString:@"goArtist"]){
//        [segue destinationViewController];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"goArtist" sender:self];
}

- (IBAction)goArtist:(id)sender {
    [self performSegueWithIdentifier:@"goArtist" sender:self];
}

- (void)goMenu:(UITapGestureRecognizer *)sender {
    NSLog(@"goMenu");
    NSLog(@"%ld", sender.view.tag);
    if (sender.view.tag == 0) {
        [self performSegueWithIdentifier:@"goInfo" sender:self];
    }
    else if (sender.view.tag == 1) {
        [self performSegueWithIdentifier:@"goArtistList" sender:self];
    }
    else if (sender.view.tag == 2) {
        [self performSegueWithIdentifier:@"goPlaylist" sender:self];
    }
    else if (sender.view.tag == 3) {
        NSString *sharedText = @"LiveHouseをShareする";
        NSURL *url = [NSURL URLWithString:@"http://lvhs.jp"];
        NSArray *activityItems = @[sharedText, url];
        UIActivity *activity = [[UIActivity alloc] init];
        NSArray *appActivities = @[activity];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                 applicationActivities:appActivities];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    else if (sender.view.tag == 4) {
        [self performSegueWithIdentifier:@"goSetting" sender:self];
    }
    else if (sender.view.tag == 5) {
        [self performSegueWithIdentifier:@"goReview" sender:self];
    }
}

@end
