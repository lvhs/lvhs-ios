//
//  LHAppDelegate.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/25/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHConsts.h"
#import "LHAppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <Parse/Parse.h>

#import "GAI.h"
#import <Repro/Repro.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "SRGVersionUpdater.h"

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


@implementation LHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    SRGVersionUpdater *versionUpdater = [SRGVersionUpdater new];
    versionUpdater.endPointUrl = [[[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_WEB_BASE_URL] stringByAppendingString:@"/version.json"];
    [versionUpdater executeVersionCheck];
    
    //AFで通信中は自動的にインジケータ回す
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [self initGoogleAnalytics];
//    [self initRepro];
    [Fabric with:@[CrashlyticsKit]];
    [self initParse:application];

    //通知タップからの起動
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"didFinishLaunchingWithOptions: %@", userInfo);
        self.launchingRomoteNotificationOptions = userInfo;
    }
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Repro

- (void)initRepro {
    // Repro
//    [ReproInsight setupWithToken:LH_REPRO_TOKEN];
}

#pragma mark -
#pragma mark Google Analytics

- (void)initGoogleAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance] trackerWithTrackingId:LH_GAI_TRACKING_ID];
}

#pragma mark -
#pragma mark Parse

- (void)initParse:(UIApplication *)application {
    LHConfig* config = [LHConfig sharedInstance];
    [Parse setApplicationId:[config objectForKey:LH_CONFIG_KEY_PARSE_APPLICATION_KEY]
                  clientKey:[config objectForKey:LH_CONFIG_KEY_PARSE_CLIENT_KEY]];
    // Register for Push Notifications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    [PFPush subscribeToChannelInBackground:@"global"];
}

//デバイストークン取得失敗
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"fail to recieve device token: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSString* type = userInfo[@"type"];
	if ([type isEqual:@"url"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNotificationWithUrl" object:nil userInfo:userInfo];
        return;
	}
    [PFPush handlePush:userInfo];
}

#pragma mark -
#pragma mark Facebook

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

+ (instancetype)sharedInstance {
    return [UIApplication sharedApplication].delegate;
}

@end
