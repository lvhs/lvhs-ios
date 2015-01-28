//
//  LHURLRequest.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 10/20/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHURLRequest.h"
#import "UIApplication+UIID.h"

@implementation LHURLRequest

- (LHURLRequest *)initWithURL:(NSURL *)url {
    LHURLRequest *req = [super initWithURL:url];
    UIApplication *application = [UIApplication sharedApplication];
    [req addValue:[application uniqueInstallationIdentifier] forHTTPHeaderField:@"X-UIID"];
    [req addValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"X-BUNDLE-VERSION"];
    return req;
}

@end
