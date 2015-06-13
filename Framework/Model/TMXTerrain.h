//
//  TMXTerrain.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/23.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"


@class TMXTileset;
@class TMXTile;

@interface TMXTerrain : TMXObject

@property (nonatomic, weak) TMXTileset *tileset;    // the tileset this terrain type belongs to.

@property (nonatomic, assign) uint32_t terrainId;   // ID of this terrain type.
// if imageTileId == -1  then no image display
@property (nonatomic, assign) int imageTileId; // the index of the tile that visually represents this terrain type.

/**
 * Returns a Tile that represents this terrain type in the terrain palette.
 */
- (TMXTile *)imageTile;

/**
 * Sets the array of terrain penalties(/distances).
 */
- (void)setTransitionDistances:(NSMutableArray *)transitionDistances;

/**
 * Sets the transition penalty(/distance) from this terrain type to another terrain type.
 */
- (void)setTransitionDistance:(int)targetTerrainType distance:(int)distance;

/**
 * Returns the transition penalty(/distance) from this terrain type to another terrain type.
 */
- (int)transitionDistance:(int)targetTerrainType;


/**
 * Returns the given \a terrain with the \a corner modified to \a terrainId.
 */
+ (unsigned)getTerrainCorner:(unsigned)terrain corner:(int)corner terrainId:(int)terrainId;


@end
