//
//  LHViewController.h
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/25/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "LHSlideViewController.h"

@interface LHViewController : UITableViewController <UITableViewDelegate, LHSlideViewControllerDelegate>

@property (nonatomic) LHSlideViewController* menuViewController;

@end
