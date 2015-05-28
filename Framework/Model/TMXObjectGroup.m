//
//  TMXObjectGroup.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/24.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObjectGroup.h"
#import "SKColor+TMXColorWithHex.h"
#import "TMXObjectGroupNode.h"

@implementation TMXObjectGroup

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_ObjectGroup;
}

- (void)dealloc {
    
}


- (NSMutableArray *)objects {
    if (!_objects) {
        _objects = [NSMutableArray array];
    }
    return _objects;
}

- (NSArray *)sortedObjectsWithDrawOrder:(DrawOrderType)drawOrder {
    if (drawOrder==DrawOrderType_TopDown) {
        return [self.objects sortedArrayUsingSelector:@selector(compareObjectGroupNode:)];
    } else {
        return self.objects;
    }
}

#pragma mark - customize
- (BOOL)isShowShape {
    return [[self propertyForName:@"showShape"] intValue] == 1;
}


#pragma mark - Parse XML
- (BOOL)parseSelfElement:(ONOXMLElement *)element {
    NSAssert([@"objectgroup" isEqualToString:element.tag], @"ERROR: Not A objectgroup Element");

    self.name = element[@"name"];
    
    id o = element[@"opacity"];
    self.opacity = o==nil ? 1.0 : [o floatValue];
    
    id v = element[@"visible"];
    self.visible = v==nil || [v intValue]==1;
    
    self.color = [SKColor tmxColorWithHex:element[@"color"]];
    
    NSString *draworderStr = element[@"draworder"];
    if (draworderStr && [@"index" isEqualToString:draworderStr]) {
        self.drawOrder = DrawOrderType_IndexOrder;
    } else {
        self.drawOrder = DrawOrderType_TopDown;
    }
    
    [self.objects removeAllObjects];
    for (ONOXMLElement *subElement in element.children) {
        if ([@"properties" isEqualToString:subElement.tag]) {
            [self readProperties:subElement];
            
        } else if ([@"object" isEqualToString:subElement.tag]) {
            [self parseObjectElement:subElement];
        }
    }
    return YES;
}

- (BOOL)parseObjectElement:(ONOXMLElement *)element {
    TMXObjectGroupNode *node = [TMXObjectGroupNode new];
    node.objectGroup = self;
    [node parseSelfElement:element];
    [self.objects addObject:node];
    return YES;
}









@end
