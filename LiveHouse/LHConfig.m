//
//  LHConfig.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/31/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHConsts.h"
#import "LHConfig.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MF_Base64Additions.h"

@implementation LHConfig

+ (LHConfig*)sharedInstance {
    return [super sharedInstance];
}

//本番接続先
- (LHBaseConfigItem*)productionConfig {
    return [[LHBaseConfigItem alloc]
            initWithName:LH_ENV_PRO
            withDict:@{
                LH_CONFIG_KEY_API_BASE_URL:          @"http://dev.lvhs.jp/api",
                LH_CONFIG_KEY_WEB_BASE_URL:          @"http://dev.lvhs.jp/app",
                LH_CONFIG_KEY_RESOURCE_BASE_URL:     @"http://static.lvhs.jp",
                LH_CONFIG_KEY_COOKIE_DOMAIN:         @".lvhs.jp",
                
                LH_CONFIG_KEY_PARSE_APPLICATION_KEY: @"ERw21W839WcCmKIpvaRKKg0NKuz5VLMQK5K7cR7k",
                LH_CONFIG_KEY_PARSE_CLIENT_KEY:      @"XuwWIp8VfGXXxBWil89AZNxCJ8YtsEHP5e4Mgyxi",
            }];
}

//開発中接続先
#ifdef DEV
- (NSDictionary*)devConfigDict {
    return @{
        LH_ENV_PRO : [self productionConfig],
        
        LH_ENV_DEV : [[LHBaseConfigItem alloc]
                      initWithName:LH_ENV_DEV
                      withDict:@{
                          LH_CONFIG_KEY_API_BASE_URL: @"http://dev.lvhs.jp/api",
                          LH_CONFIG_KEY_WEB_BASE_URL: @"http://dev.lvhs.jp/app",
                          LH_CONFIG_KEY_RESOURCE_BASE_URL: @"http://dev.lvhs.jp",
                          LH_CONFIG_KEY_COOKIE_DOMAIN: @".dev.lvhs.jp",
                          
                          LH_CONFIG_KEY_PARSE_APPLICATION_KEY: @"ERw21W839WcCmKIpvaRKKg0NKuz5VLMQK5K7cR7k",
                          LH_CONFIG_KEY_PARSE_CLIENT_KEY:      @"XuwWIp8VfGXXxBWil89AZNxCJ8YtsEHP5e4Mgyxi",
                      }],
        LH_ENV_STG : [[LHBaseConfigItem alloc]
                initWithName:LH_ENV_STG
                    withDict:@{
                            LH_CONFIG_KEY_API_BASE_URL: @"http://stage.lvhs.jp/api",
                            LH_CONFIG_KEY_WEB_BASE_URL: @"http://stage.lvhs.jp/app",
                            LH_CONFIG_KEY_RESOURCE_BASE_URL: @"http://stage.lvhs.jp",
                            LH_CONFIG_KEY_COOKIE_DOMAIN: @".stage.lvhs.jp",

                            LH_CONFIG_KEY_PARSE_APPLICATION_KEY: @"ERw21W839WcCmKIpvaRKKg0NKuz5VLMQK5K7cR7k",
                            LH_CONFIG_KEY_PARSE_CLIENT_KEY:      @"XuwWIp8VfGXXxBWil89AZNxCJ8YtsEHP5e4Mgyxi",
                    }],
        LH_ENV_LCL : [[LHBaseConfigItem alloc]
                initWithName:LH_ENV_STG
                    withDict:@{
                            LH_CONFIG_KEY_API_BASE_URL: @"http://localhost:3000/api",
                            LH_CONFIG_KEY_WEB_BASE_URL: @"http://localhost:3000/app",
                            LH_CONFIG_KEY_RESOURCE_BASE_URL: @"http://localhost:3000",
                            LH_CONFIG_KEY_COOKIE_DOMAIN: @".localhost",

                            LH_CONFIG_KEY_PARSE_APPLICATION_KEY: @"ERw21W839WcCmKIpvaRKKg0NKuz5VLMQK5K7cR7k",
                            LH_CONFIG_KEY_PARSE_CLIENT_KEY:      @"XuwWIp8VfGXXxBWil89AZNxCJ8YtsEHP5e4Mgyxi",
                    }]
        
    };
}
#endif

- (NSArray*)items {
    static NSArray* config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#ifdef DEV
        NSMutableArray* ary = [NSMutableArray array];
        
        NSDictionary* dict = [self devConfigDict];
        [ary addObject:dict[LH_ENV_DEV_DEFAULT]]; //先頭がデフォルトの接続先
        
        for (id key in [dict keyEnumerator]) {
            if (![key isEqualToString:LH_ENV_DEV_DEFAULT]) {
                [ary addObject:dict[key]];
            }
        }
        config = ary;
#else
        config = @[[self productionConfig]];
#endif
        LHBaseConfigItem* item = config[0];
        NSLog(@"confing:%@", item.dict);
    });
    return config;
}

#ifdef DEV
+ (void)setupBasicAuth {
    //開発サーバー接続時はbasic認証付きでhttpアクセス
    if (![LHConfig isProduction]) {
        [self _setupBasicAuthCredential];
        [self _setupBasicAuthSDWebImage];
    }
}

+ (void)_setupBasicAuthSDWebImage {
    //for 画像リソース取得時
    NSString* basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", LH_API_BASIC_AUTH_USERNAME, LH_API_BASIC_AUTH_PASSWORD];
    NSString* authValue = [NSString stringWithFormat:@"Basic %@", [basicAuthCredentials base64String]];
    [[SDWebImageManager sharedManager].imageDownloader setValue:authValue forHTTPHeaderField:@"Authorization"];
}

+ (void)_setupBasicAuthCredential {
    //個人開発環境/dev環境の場合はwebview用にbasic認証の設定
    [[self class] _setupBasicAuthCredentialWithBaseURL:LH_WEB_BASE_URL];
    [[self class] _setupBasicAuthCredentialWithBaseURL:LH_RESOURCE_BASE_URL];
}

+ (void)_setupBasicAuthCredentialWithBaseURL:(NSString*)baseURL {
    NSURL* url = [NSURL URLWithString:baseURL];
    
    int port;
    NSString* realm;
    
    if ([[LHConfig sharedInstance].selectedName isEqualToString:LH_ENV_DEV]) {
        port = 443;
        realm = @"Enter name & passwd:";
        
    } else {
        port = 80;
        
        NSString* host = [url host];
        NSRange range = [host rangeOfString:@"mjwdev"];
        if (range.location == NSNotFound) {
            NSLog(@"Invalid host: %@", url);
            return;
        }
        
        NSString* subdomain;
        NSArray* comps = [host componentsSeparatedByString:@"."];
        for (NSString* comp in comps) {
            if ([comp hasPrefix:@"mjwdev"]) {
                subdomain = comp;
                break;
            }
        }
        if (subdomain == nil) {
            NSLog(@"Invalid host: %@", url);
            return;
        }
        realm = [NSString stringWithFormat:@"enter uname/passwd(%@)", subdomain];
    }
    
    NSURLCredentialStorage *storage = [NSURLCredentialStorage sharedCredentialStorage];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:LH_API_BASIC_AUTH_USERNAME
                                                             password:LH_API_BASIC_AUTH_PASSWORD
                                                          persistence:NSURLCredentialPersistencePermanent];
    
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc]
                                             initWithHost:url.host
                                             port:port
                                             protocol:url.scheme
                                             realm:realm
                                             authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    [storage setCredential:credential
        forProtectionSpace:protectionSpace];
    
}

+ (BOOL)isProduction {
    return [[LHConfig sharedInstance].selectedName isEqualToString:LH_ENV_PRO];
}

+ (BOOL)isDevelopment {
    return [[LHConfig sharedInstance].selectedName isEqualToString:LH_ENV_DEV];
}

+ (BOOL) isStaging {
    return [[LHConfig sharedInstance].selectedName isEqualToString:LH_ENV_STG];
}

#endif

@end
