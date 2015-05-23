//
//  NSString+Util.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 2015/05/23.
//  Copyright (c) 2015年 LIVEHOUSE inc. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (NSString *) decodeString {
    return [self stringByRemovingPercentEncoding];
}

@end
