//
//  LHWebView.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 10/20/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHWebView.h"

@implementation LHWebView

- (BOOL) shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType) navigationType
{
    BOOL headerIsPresent = [[request allHTTPHeaderFields] objectForKey:@"my custom header"]!=nil;
    
    if(headerIsPresent) return YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [request URL];
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            // set the new headers
            for(NSString *key in [self.customHeaders allKeys]){
                [request addValue:[self.customHeaders objectForKey:key] forHTTPHeaderField:key];
            }
            
            // reload the request
            [self loadRequest:request];
        });
    });
    return NO;
}

@end
