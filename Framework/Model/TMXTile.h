//
//  TMXTile.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/19.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"

@class TMXTileset;
@class TMXTerrain;

@interface TMXTile : TMXObject

@property (nonatomic, weak) TMXTileset *tileset;

@property (nonatomic, assign) uint32_t tileId;
@property (nonatomic, readonly) uint32_t gId;

@property (nonatomic, copy) NSString *imageSource;
@property (nonatomic, retain) SKTexture *texture;

@property (nonatomic, assign) CGSize size;

// 在tileset的矩阵中所处的位置
@property (nonatomic, assign) uint32_t row;
@property (nonatomic, assign) uint32_t column;

// setup in SK Node
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) BOOL flippedHorizontally;
@property (nonatomic, assign) BOOL flippedVertically;
@property (nonatomic, assign) BOOL flippedAntiDiagonally;









// Terrain
@property (nonatomic, assign) unsigned terrainValue;
@property (nonatomic, assign) float terrainProbability;
/**
 * Returns the Terrain of a given corner.
 */
- (TMXTerrain *)terrainAtCorner:(int)corner;

/**
 * Returns the terrain id at a given corner.
 */
- (int)cornerTerrainId:(int)corner;

/**
 * Set the terrain type of a given corner.
 */
- (void)setCornerTerrain:(int)corner terrainId:(int)terrainId;

/**
 * Set the terrain for each corner of the tile.
 */
- (void)updateTerrain:(unsigned)terrain;


@end
