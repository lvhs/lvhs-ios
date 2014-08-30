//
//  LHSlideViewController.h
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/30/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHSlideViewControllerDelegate <NSObject>
- (void)didSelectSetting;
- (void)didMenuToggledVisible:(BOOL)visible;
- (void)didSettingViewClosed;
@end

@interface LHSlideViewController : UIViewController

@property (nonatomic, weak) id<LHSlideViewControllerDelegate> delegate;

@end
