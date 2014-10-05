//
//  LHUtils.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 10/5/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHUtils.h"

// クラスの実装
@implementation LHUtils

- (BOOL)isEqual:(id)other
{
    if (self == other) {
        return YES;
    }
    if (other == nil || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    
    // クラス名からメタデータを取得
    const char *className = NSStringFromClass(self.class).UTF8String;
    id clazz = objc_getClass(className);
    
    // プロパティのリストを取得
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    
    for (int i = 0 ; i < count; i++) {
        //property_getName でプロパティの名前が取れる
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id myProperty = [self valueForKey:propertyName]; //valueForKeyで値を取得
        id otherProperty = [other valueForKey:propertyName];
        // 比較
        if (myProperty == nil && otherProperty == nil) {
            continue;
        }
        if (![myProperty isEqual:otherProperty]) {
            return NO;
        }
    }
    
    return YES;
}

@end