//
//  LHTermsViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 11/3/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <TTTAttributedLabel.h>
#import "LHTermsViewController.h"
#import "LHConsts.h"

@interface LHTermsViewController()
@property (weak, nonatomic) IBOutlet UIView *termsView;
@property (weak, nonatomic) IBOutlet UIButton *agree1;
@property (weak, nonatomic) IBOutlet UIButton *agree2;
@property (weak, nonatomic) IBOutlet UILabel *termsLink;
- (IBAction)toggleAgreement:(id)sender;
- (IBAction)agreeAndStart:(id)sender;
@end

@implementation LHTermsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:LH_TERM_AGREEMENT_KEY]) {
        [self start];
    } else {
        [self showTermsView];
    }
}

- (IBAction)toggleAgreement:(UIButton *)button {
    button.selected = !button.selected;
}

- (IBAction)agreeAndStart:(id)sender {
    if (_agree1.selected && _agree2.selected) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:LH_TERM_AGREEMENT_KEY];
        [self start];
    }
}

- (void)start {
    [self performSegueWithIdentifier:@"start" sender:self];
}

- (void)showTermsView {
    _termsView.hidden = NO;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"利用規約に同意する。"];
    [str addAttributes:@{
//                         NSLinkAttributeName: @"http://app.lvhs.jp/terms",
                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                         NSUnderlineColorAttributeName: [UIColor whiteColor],
                         NSForegroundColorAttributeName: [UIColor whiteColor],
                         NSURLLabelColorKey: [UIColor whiteColor]
                         } range:NSMakeRange(0, 4)];
    _termsLink.attributedText = str;
    _termsLink.tintColor = [UIColor whiteColor];
    _termsLink.highlightedTextColor = [UIColor whiteColor];
    _termsLink.textColor = [UIColor whiteColor];
    
    [_termsLink addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink)]];
}

- (void) openLink {
    NSURL *url = [[NSURL alloc] initWithString:@"http://app.lvhs.jp/terms"];
    [[UIApplication sharedApplication] openURL:url];
}
     

@end
