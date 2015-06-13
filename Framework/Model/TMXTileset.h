//
//  TMXTileset.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/19.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"

@class TMXTile;
@class TMXMap;
@class TMXTerrain;

@interface TMXTileset : TMXObject

@property (nonatomic, weak) TMXMap *map;

@property (nonatomic, assign) uint32_t firstGid;
@property (nonatomic, assign) uint32_t tileWidth;
@property (nonatomic, assign) uint32_t tileHeight;
@property (nonatomic, assign) uint32_t spacing;
@property (nonatomic, assign) uint32_t margin;
@property (nonatomic, assign) CGPoint tileOffset;

@property (nonatomic, copy) NSString *source; //External tileset (*.tsx)
@property (nonatomic, copy) NSString *imageSource;
@property (nonatomic, readonly) SKTexture* atlasTexture;
@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign, readonly) uint32_t numRows;
@property (nonatomic, assign, readonly) uint32_t numCols;

@property (nonatomic) CGPoint anchorPoint;

@property (nonatomic, copy) SKColor *transparentColor;

- (uint32_t)tileCount;
- (TMXTile *)tileAtIndex:(uint32_t)index;
- (TMXTile *)tileAtRow:(uint32_t)row col:(uint32_t)col;
-(SKTexture*)textureForTile:(TMXTile *)tile;

- (BOOL)loadExternalTileset:(NSString *)source;











// TerrainTypes
@property (nonatomic, assign) BOOL terrainDistancesDirty;
@property (nonatomic, strong) NSMutableArray *terrainTypes;
/**
 * Returns the terrain type at the given \a index.
 */
- (TMXTerrain *)terrainAtIndex:(int)index;

/**
 * Adds a new terrain type.
 *
 * @param name      the name of the terrain
 * @param imageTile the id of the tile that represents the terrain visually
 * @return the created Terrain instance
 */
- (TMXTerrain *)addTerrainWithName:(NSString *)name imageTileId:(int)imageTileId;

/**
 * Adds the \a terrain type at the given \a index.
 *
 * The terrain should already have this tileset associated with it.
 */
- (void)insertTerrain:(TMXTerrain *)terrain atIndex:(int)index;

/**
 * Removes the terrain type at the given \a index and returns it. The
 * caller becomes responsible for the lifetime of the terrain type.
 *
 * This will cause the terrain ids of subsequent terrains to shift up to
 * fill the space and the terrain information of all tiles in this tileset
 * will be updated accordingly.
 */
- (TMXTerrain *)takeTerrainAtIndex:(int)index;

/**
 * Returns the transition penalty(/distance) between 2 terrains. -1 if no
 * transition is possible.
 */
- (int)terrainTransitionPenaltyType0:(int)terrainType0 type1:(int)terrainType1;



@end
