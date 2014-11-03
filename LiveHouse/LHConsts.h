//
//  LHConsts.h
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/31/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHConfig.h"

#ifndef LiveHouse_LHConsts_h
#define LiveHouse_LHConsts_h

////////////////
//接続先サーバー
#define LH_API_BASE_URL ([[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_API_BASE_URL])
#define LH_WEB_BASE_URL ([[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_WEB_BASE_URL])
#define LH_INDIES_BASE_URL ([[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_INDIES_BASE_URL])
#define LH_RESOURCE_BASE_URL ([[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_RESOURCE_BASE_URL])
#define LH_COOKIE_DOMAIN ([[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_COOKIE_DOMAIN])

#define LH_TERM_AGREEMENT_KEY (@"agree")

// Parse
#define LH_PARSE_APPLICATION_ID ([[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_PARSE_APPLICATION_KEY])
#define LH_PARSE_CLIENT_ID ([[LHConfig sharedInstance] objectForKey:LH_CONFIG_KEY_PARSE_CLIENT_KEY])

// Google Analytics
#define LH_GAI_TRACKING_ID (@"UA-55278022-1")

// Repro
#define LH_REPRO_TOKEN (@"bb0feda5-f142-46ec-b1b9-62387f7bc03b")

// CA Reward
#define LH_CA_REWARD_API_KEY (@"4245437727b92542")
#define LH_CA_REWARD_MEDIA_ID (@"3893")

////////////////
//開発用
//リリース時以外はbasic認証付きでapiアクセス
#ifdef DEV
#define LH_API_BASIC_AUTH_USERNAME @"lvhs"
#define LH_API_BASIC_AUTH_PASSWORD @"shvl"

#ifdef DEBUG
//#define DEBUG_VIEWER_COLOR 1
#endif
#endif

/////////////////
// 便利マクロたち
#define APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define ROOT_VIEW_CONTROLLER APP_DELEGATE.window.rootViewController
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIScreen mainScreen].scale > 1)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_BOUNDS   ([UIScreen mainScreen].bounds)
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_PORTRAIT (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
#define ORIENTAION ([UIApplication sharedApplication].statusBarOrientation)
#define IS_IOS7_LATER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define LOG(fmt, ...) NSLog(fmt, ##__VA_ARGS__)

// color
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// radians and degrees
#define DEGREES_TO_RADIANS(degrees) (degrees * M_PI / 180)
#define RADIANS_TO_DEGREES(radians) (radians * 180 / M_PI)

//いずれかのビューが画面トップに表示され、scrollToTopを有効化することを主張する際に発火される通知
static NSString* const kLHTopViewRequireScrollToTop = @"kLHTopViewRequireScrollToTop";

#endif