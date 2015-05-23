//
//  LHConfig.h
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/31/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHBaseConfig.h"

//本番接続先
#define LH_ENV_PRO (@"production")

#ifdef DEV
/////////開発時のデフォルトの接続先///////////
#define LH_ENV_DEV_DEFAULT LH_ENV_DEV
//////////////////////////////////////////

#define LH_ENV_DEV (@"dev")
#endif

#define LH_CONFIG_KEY_COOKIE_DOMAIN (@"cookie.domain")
#define LH_CONFIG_KEY_API_BASE_URL (@"api.base.url")
#define LH_CONFIG_KEY_WEB_BASE_URL (@"web.base.url")
#define LH_CONFIG_KEY_INDIES_BASE_URL (@"web.indies.url")
#define LH_CONFIG_KEY_RESOURCE_BASE_URL (@"resource.base.url")

#define LH_CONFIG_KEY_PARSE_APPLICATION_KEY (@"parse.application.key")
#define LH_CONFIG_KEY_PARSE_CLIENT_KEY      (@"parse.client.key")

@interface LHConfig : LHBaseConfig

+ (LHConfig*)sharedInstance;

#ifdef DEV
+ (void)setupBasicAuth;
+ (BOOL)isProduction;
+ (BOOL)isDevelopment;
#endif

@end

