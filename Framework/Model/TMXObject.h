//
//  TMXObject.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/19.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono/Ono.h>
#import "TMXTypes.h"


/**
 * The base class for anything that can hold properties.
 */

@interface TMXObject : NSObject <NSCopying>

@property (nonatomic, assign) ObjectType objType;
@property (nonatomic, strong) NSMutableDictionary *properties;

// using SpriteKit
@property (nonatomic, assign) CGFloat zPosition;

- (void)readProperties:(ONOXMLElement *)element;

- (BOOL)hasProperties;
- (BOOL)hasProperty:(NSString *)name;
- (NSString *)propertyForName:(NSString *)name;
- (void)setProperty:(NSString *)property forName:(NSString *)name;
- (void)removeProperty:(NSString *)name;


- (BOOL)parseSelfElement:(ONOXMLElement *)element;

- (NSString *)writePropertiesInString;




- (void)initDefaultValue;
@end
