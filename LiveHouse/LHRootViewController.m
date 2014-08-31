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
    [_menuBtn setAction:@selector(toggleMenu)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleMenu {
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

@end
