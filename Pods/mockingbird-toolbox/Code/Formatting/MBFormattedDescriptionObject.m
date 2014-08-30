//
//  MBFormattedDescriptionObject.m
//  Mockingbird Toolbox
//
//  Created by Evan Coyne Maloney on 4/17/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import "MBFormattedDescriptionObject.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBFormattedDescriptionObject
/******************************************************************************/

@implementation MBFormattedDescriptionObject

- (void) addDescriptionFieldsTo:(MBFieldListFormatter*)fmt
{
}

- (NSString*) debugDescriptor
{
    return nil;
}

- (NSString*) consoleDescription
{
    MBFieldListFormatter* fmt = [MBFieldListFormatter formatterForObject:self];
    [fmt setField:@"debugDescriptor" value:[self debugDescriptor]];
    [self addDescriptionFieldsTo:fmt];
    return [fmt asDescription];
}

- (void) dump
{
    consoleLog(@"%@", [self consoleDescription]);
}

- (NSString*) description
{
    return [self consoleDescription];
}

@end

