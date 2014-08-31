//
//  LHConfig.h
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/31/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString* const kConfigAPIBaseURL;
//extern NSString* const kConfigAPIBaseAuthUsername;
//extern NSString* const kConfigAPIBaseAuthPassword;
//extern NSString* const kConfigCookieDomain;

@interface LHBaseConfig : NSObject

@property (nonatomic, readonly) NSString* selectedName;
@property (nonatomic, readonly) NSArray*  itemNames;

+ (id)sharedInstance;
- (id)objectForKey:(id)key;
- (void)showSelectView:(UIViewController*)fromController;
- (void)setEnvironment:(NSString*)name;

@end

@interface LHBaseConfigItem : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSDictionary* dict;

-(id)initWithName:(NSString*)name withDict:(NSDictionary*)dict;

@end

@interface LHBaseConfigViewController : UITableViewController
@property (nonatomic) LHBaseConfig* config;
@end