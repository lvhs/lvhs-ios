//
//  MBRegexCache.m
//  Mockingbird Toolbox
//
//  Created by Evan Coyne Maloney on 11/29/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import "MBRegexCache.h"

#define DEBUG_LOCAL                 0
#define DEBUG_DISABLE_CACHING       0

/******************************************************************************/
#pragma mark -
#pragma mark MBRegexCache implementation
/******************************************************************************/

@implementation MBRegexCache

MBImplementSingleton();

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (id) init
{
    if (DEBUG_FLAG(DEBUG_DISABLE_CACHING)) {
        errorLog(@"WARNING: %@ compiled with regular expression caching DISABLED!", [self class]);
    }
    
    return [super init];
}

/******************************************************************************/
#pragma mark Public API (singleton instance class level)
/******************************************************************************/

- (NSRegularExpression*) regularExpressionWithPattern:(NSString*)pattern
                                              options:(NSRegularExpressionOptions)options
                                                error:(NSError**)errPtr
{
    debugTrace();
    
    NSString* cacheKey = [NSString stringWithFormat:@"%@ 0x%lx", pattern, (unsigned long)options];
    NSRegularExpression* regex = nil;
    if (!DEBUG_FLAG(DEBUG_DISABLE_CACHING)) {
        regex = [self objectForKey:cacheKey];
    }
    if (!regex) {
        NSError* logError = nil;

        regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                          options:options
                                                            error:&logError];
        if (errPtr) {
            *errPtr = logError;
        }
        else if (logError) {
            errorLog(@"Error %@ attempting to create NSRegularExpression instance from the pattern: %@", logError, pattern);
        }
 
        if (regex && !DEBUG_FLAG(DEBUG_DISABLE_CACHING)) {
            [self setObject:regex forKey:cacheKey];
        }
    }
    return regex;
}

- (NSRegularExpression*) regularExpressionWithPattern:(NSString*)pattern 
                                              options:(NSRegularExpressionOptions)options
{
    return [self regularExpressionWithPattern:pattern options:options error:nil];
}

- (NSRegularExpression*) regularExpressionWithPattern:(NSString*)pattern
{
    return [self regularExpressionWithPattern:pattern options:0 error:nil];
}

/******************************************************************************/
#pragma mark Public API (class level, for convenience)
/******************************************************************************/

+ (NSRegularExpression*) regularExpressionWithPattern:(NSString*)pattern 
                                              options:(NSRegularExpressionOptions)options 
                                                error:(NSError**)errPtr
{
    return [[self instance] regularExpressionWithPattern:pattern options:options error:errPtr];
}

+ (NSRegularExpression*) regularExpressionWithPattern:(NSString*)pattern 
                                              options:(NSRegularExpressionOptions)options
{
    return [[self instance] regularExpressionWithPattern:pattern options:options error:nil];
}

+ (NSRegularExpression*) regularExpressionWithPattern:(NSString*)pattern
{
    return [[self instance] regularExpressionWithPattern:pattern options:0 error:nil];
}

@end
