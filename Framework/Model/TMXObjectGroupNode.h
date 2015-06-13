//
//  TMXObjectGroupNode.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/24.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"

@class TMXTile;
@class TMXObjectGroup;
@class SKMapRenderer;

@interface TMXObjectGroupNode : TMXObject

@property (nonatomic, weak) TMXObjectGroup *objectGroup;
@property (nonatomic, assign) ObjectGroupType objGroupType;

// base data
@property (nonatomic, assign) int objectId;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) float rotation;


//  ObjectGroupType_Tile
@property (nonatomic, strong) TMXTile *tile;

// ObjectGroupType_Polygon | ObjectGroupType_Polyline
@property (nonatomic, strong) NSMutableArray *points;

/** Turns the object's outline in a CGPathRef.
 @returns The newly created CGPathRef. */
- (id)getPathRef:(SKMapRenderer*)renderer;


// customize
- (BOOL)isShowObject;


- (NSComparisonResult)compareObjectGroupNode:(TMXObjectGroupNode *)aNode;

@end
