//
//  TMXObject.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/19.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"

@implementation TMXObject

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultValue];
    }
    return self;
}



- (void)initDefaultValue {
    
}

- (id)copyWithZone:(NSZone *)zone {
    TMXObject *copy = [[self class] new];
    copy.name = self.name;
    copy.objType = self.objType;
    copy.properties = self.properties;// 统一属性内容，不用copy
    return copy;
}


- (NSMutableDictionary *)properties {
    if (!_properties) {
        _properties = [NSMutableDictionary dictionary];
    }
    return _properties;
}

- (void)readProperties:(ONOXMLElement *)element {
    if ([@"properties" isEqualToString:element.tag]) {
        for (ONOXMLElement *subele in element.children) {
            if ([@"property" isEqualToString:subele.tag]) {
                [self setProperty:subele[@"value"] forName:subele[@"name"]];
            }
        }
    }
}

- (BOOL)hasProperties {
    return [_properties.allKeys count] != 0;
}
- (BOOL)hasProperty:(NSString *)name {
    NSEnumerator *enumerator = [_properties keyEnumerator];
    for(NSString *aKey in enumerator) {
        if ([aKey isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)propertyForName:(NSString *)name {
    return [_properties objectForKey:name];
}

- (void)setProperty:(NSString *)property forName:(NSString *)name {
    if (name==nil) {
        return;
    }
    [self.properties setObject:property?property:@"" forKey:name];
}

- (void)removeProperty:(NSString *)name {
    if (name==nil) {
        return;
    }
    [_properties removeObjectForKey:name];
}


- (BOOL)parseSelfElement:(ONOXMLElement *)element {
    return YES;
}


#define XMLFormatStr @"<property name=\"%@\" value=\"%@\"/>\n"
- (NSString *)writePropertiesInString {
    NSMutableString *writerStr = [NSMutableString string];
    [writerStr appendString:@"\n"];
    
    NSEnumerator *enumerator = [_properties keyEnumerator];
    NSString *aValue;
    for(NSString *aKey in enumerator) {
        aValue = [_properties objectForKey:aKey];
        [writerStr appendFormat:XMLFormatStr, aKey, aValue];
    }
    return writerStr;
}


@end
