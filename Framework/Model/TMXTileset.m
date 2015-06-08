//
//  TMXTileset.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/19.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXTileset.h"
#import "TMXTile.h"
#import "TMXMap.h"
#import "TMXTerrain.h"
#import "SKColor+TMXColorWithHex.h"
#import "WBImage+WBUtils.h"
#import "WBMatrix.h"
#import "SKTexture+WBUtils.h"

@implementation TMXTileset {
    WBMatrix *m_Tiles;
}

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_Tileset;
    self.terrainTypes = [NSMutableArray array];
}

- (void)dealloc {
    m_Tiles = nil;
    _atlasTexture = nil;
    [self.terrainTypes removeAllObjects];
    self.terrainTypes = nil;
}

- (uint32_t)tileCount {
    return _numCols*_numRows;
}

- (TMXTile *)tileAtIndex:(uint32_t)index {
//    return [m_Tiles objectAtIndex:index];
    if (index >= [self tileCount]) {
        return nil;
    }
    uint32_t row = index/_numCols;
    uint32_t col = index - (row*_numCols);
    return [self tileAtRow:row col:col];
}

- (TMXTile *)tileAtRow:(uint32_t)row col:(uint32_t)col {
    return [m_Tiles objectAtRow:row col:col];
}

-(SKTexture*)textureForTile:(TMXTile *)tile {
    if (!tile) {
        return nil;
    }
    CGFloat x = self.margin + tile.column * (self.tileWidth + self.spacing);
    CGFloat y = (self.imageSize.height - self.tileHeight) - (self.margin + tile.row * (self.tileHeight + self.spacing));
    
    SKTexture* tileTexture = [SKTexture textureWithNodeRect:CGRectMake(x, y, self.tileWidth, self.tileHeight) inTexture:self.atlasTexture];
    tileTexture.filteringMode = SKTextureFilteringNearest;
    return tileTexture;
}


#pragma mark - TerrainTypes
- (TMXTerrain *)terrainAtIndex:(int)index {
    return index >= 0 ? self.terrainTypes[index] : nil;
}

- (void)insertTerrain:(TMXTerrain *)terrain atIndex:(int)index {
    if (terrain.tileset != self) {
        SKTMLog(@"ERROR: insertTerrain");
        return;
    }
    [self.terrainTypes insertObject:terrain atIndex:index];
    
    // Reassign terrain IDs
    for (int i=index; i<self.terrainTypes.count; i++) {
        TMXTerrain *tmp = self.terrainTypes[i];
        tmp.terrainId = i;
    }
    
    // Adjust tile terrain references
    for (uint32_t i=0; i<_numRows; i++) {
        for (uint32_t j=0; j<_numCols; j++) {
            TMXTile *tile = [m_Tiles objectAtRow:i col:j];
            for (int corner = 0; corner < 4; corner++) {
                int terrainId = [tile cornerTerrainId:corner];
                if (terrainId >= index) {
                    [tile setCornerTerrain:corner terrainId:terrainId + 1];
                }
            }
            
        }
    }
    self.terrainDistancesDirty = YES;
}

- (TMXTerrain *)addTerrainWithName:(NSString *)name imageTileId:(int)imageTileId {
    TMXTerrain *terrain = [TMXTerrain new];
    terrain.name = name;
    terrain.terrainId = (uint32_t)self.terrainTypes.count;
    terrain.tileset = self;
    terrain.imageTileId = imageTileId;
    [self insertTerrain:terrain atIndex:terrain.terrainId];
    return terrain;
}

- (TMXTerrain *)takeTerrainAtIndex:(int)index {
    TMXTerrain *terrain = self.terrainTypes[index];
    [self.terrainTypes removeObjectAtIndex:index];
    
    // Reassign terrain IDs
    for (int i=index; i<self.terrainTypes.count; i++) {
        TMXTerrain *tmp = self.terrainTypes[i];
        tmp.terrainId = i;
    }
    
    // Clear and adjust tile terrain references
    for (uint32_t i=0; i<_numRows; i++) {
        for (uint32_t j=0; j<_numCols; j++) {
            TMXTile *tile = [m_Tiles objectAtRow:i col:j];
            for (int corner = 0; corner < 4; corner++) {
                int terrainId = [tile cornerTerrainId:corner];
                if (terrainId >= index) {
                    [tile setCornerTerrain:corner terrainId:terrainId - 1];
                } else if (terrainId == index) {
                    [tile setCornerTerrain:corner terrainId:0xFF];
                }
            }
            
        }
    }
    self.terrainDistancesDirty = YES;
    return terrain;
}

- (int)terrainTransitionPenaltyType0:(int)terrainType0 type1:(int)terrainType1 {
    if (self.terrainDistancesDirty) {
        [self recalculateTerrainDistances];
        self.terrainDistancesDirty = NO;
    }
    
    terrainType0 = terrainType0 == 255 ? -1 : terrainType0;
    terrainType1 = terrainType1 == 255 ? -1 : terrainType1;
    
    // Do some magic, since we don't have a transition array for no-terrain
    if (terrainType0 == -1 && terrainType1 == -1) {
        return 0;
    }
    TMXTerrain *terrain = nil;
    if (terrainType0 == -1) {
        terrain = self.terrainTypes[terrainType1];
        return [terrain transitionDistance:terrainType0];
    }
    terrain = self.terrainTypes[terrainType0];
    return [terrain transitionDistance:terrainType1];
}

/**
 * Calculates the transition distance matrix for all terrain types.
 */
// some fancy macros which can search for a value in each byte of a word simultaneously
#define hasZeroByte(dword) (((dword) - 0x01010101UL) & ~(dword) & 0x80808080UL)
#define hasByteEqualTo(dword, value) (hasZeroByte((dword) ^ (~0UL/255 * (value))))
- (void)recalculateTerrainDistances {
    // Terrain distances are the number of transitions required before one terrain may meet another
    // Terrains that have no transition path have a distance of -1
    for (int i=0; i < self.terrainTypes.count; i++) {
        TMXTerrain *type = self.terrainTypes[i];
//        QVector<int> distance(terrainCount() + 1, -1);
        NSMutableArray *distance = [NSMutableArray array];
        for (int i=0; i<self.terrainTypes.count+1; i++) {
            distance[i] = @(-1);
        }
        
        // Check all tiles for transitions to other terrain types
        for (uint32_t i=0; i<_numRows; i++) {
            for (uint32_t j=0; j<_numCols; j++) {
                TMXTile *t = [m_Tiles objectAtRow:i col:j];
                
                if (!hasByteEqualTo(t.terrainValue, i))
                    continue;
                
                // This tile has transitions, add the transitions as neightbours (distance 1)
                int tl = [t cornerTerrainId:0];
                int tr = [t cornerTerrainId:1];
                int bl = [t cornerTerrainId:2];
                int br = [t cornerTerrainId:3];
                
                // Terrain on diagonally opposite corners are not actually a neighbour
                if (tl == i || br == i) {
                    distance[tr + 1] = @(1);
                    distance[bl + 1] = @(1);
                }
                if (tr == i || bl == i) {
                    distance[tl + 1] = @(1);
                    distance[br + 1] = @(1);
                }
                
                // terrain has at least one tile of its own type
                distance[i + 1] = @(0);
            }
        }
        [type setTransitionDistances:distance];
    }
    
    // Calculate indirect transition distances
    BOOL bNewConnections;
    do {
        bNewConnections = NO;
        
        // For each combination of terrain types
        for (int i=0; i < self.terrainTypes.count; i++) {
            TMXTerrain *t0 = self.terrainTypes[i];
            for (int j=0; j < self.terrainTypes.count; j++) {
                if (i == j)
                    continue;
                TMXTerrain *t1 = self.terrainTypes[j];
                
                // Scan through each terrain type, and see if we have any in common
                for (int t = -1; t < self.terrainTypes.count; t++) {
                    
                    int d0 = [t0 transitionDistance:t];
                    int d1 = [t1 transitionDistance:t];
                    if (d0 == -1 || d1 == -1)
                        continue;
                    
                    // We have cound a common connection
                    int d = [t0 transitionDistance:j];
                    NSAssert([t1 transitionDistance:i]==d, @"recalculateTerrainDistances error");
                    
                    // If the new path is shorter, record the new distance
                    if (d == -1 || d0 + d1 < d) {
                        d = d0 + d1;
                        [t0 setTransitionDistance:j distance:d];
                        [t1 setTransitionDistance:i distance:d];
                        
                        // We're making progress, flag for another iteration...
                        bNewConnections = YES;
                    }
                }
            }
        }
        
        // Repeat while we are still making new connections (could take a
        // number of iterations for distant terrain types to connect)
    } while (bNewConnections);
}



#pragma mark - Parse XML
- (BOOL)loadExternalTileset:(NSString *)source {
    if (!self.map) {
        SKTMLog(@"need to setup map property.");
        return NO;
    }
    self.source = source;
    NSString *XMLFilePath = [self.map.filePath stringByAppendingPathComponent:source];
    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[NSData dataWithContentsOfFile:XMLFilePath] error:&error];
    if (error) {
        SKTMLog(@"[Error] %@", error);
        return NO;
    }
    
    if (![@"tileset" isEqualToString:document.rootElement.tag]) {
        SKTMLog(@"rootElement isn't tileset. [tsx file: %@]", source);
        return NO;
    }
    
    return [self parseSelfElement:document.rootElement];
}

- (BOOL)parseSelfElement:(ONOXMLElement *)element {
    NSAssert([@"tileset" isEqualToString:element.tag], @"ERROR: Not A tileset Element");
    id firstgid = element[@"firstgid"];
    if (firstgid) {
        self.firstGid = [firstgid intValue];
    }
    
    
    NSString *source = element[@"source"];
    if (source) {
        return [self loadExternalTileset:source];
    }
    
    self.name = element[@"name"];
    self.tileWidth = [element[@"tilewidth"] intValue];
    self.tileHeight = [element[@"tileheight"] intValue];
    self.spacing = [element[@"spacing"] intValue];
    self.margin = [element[@"margin"] intValue];
    
    
    for (ONOXMLElement *subElement in element.children) {
//        SKTMLog(@"%@: %@", subElement.tag, subElement.attributes);
        if ([@"tileoffset" isEqualToString:subElement.tag]) {
            self.tileOffset = CGPointMake([subElement[@"x"] intValue], [subElement[@"y"] intValue]);
            
        } else if ([@"image" isEqualToString:subElement.tag]) {
            [self parseImageWithElement:subElement];
            
        } else if ([@"terraintypes" isEqualToString:subElement.tag]) {
            [self parseTerraintypesWithElement:subElement];
            
        } else if ([@"tile" isEqualToString:subElement.tag]) {
            [self parseTileWithElement:subElement];
            
        } else if ([@"properties" isEqualToString:subElement.tag]) {
            [self readProperties:subElement];
            
        }
    }
    
    return YES;
}


- (BOOL)parseImageWithElement:(ONOXMLElement *)element {
    NSAssert([@"image" isEqualToString:element.tag], @"ERROR: Not A image Element");
//    self.transparentColor = [SKColor tmxColorWithHex:@"000000"];
    self.transparentColor = [SKColor tmxColorWithHex:element[@"trans"]];
    
    self.imageSource = element[@"source"];
    if (!self.imageSource) {
        SKTMLog(@"image source Not Found");
        return NO;
    }
    
    
    NSString *imgFilePath = [self.map.filePath stringByAppendingPathComponent:self.imageSource];
    WBImage *texImage = [[WBImage alloc] initWithContentsOfFile:imgFilePath];
    if (!texImage) {
        SKTMLog(@"Image Not Found: %@", self.imageSource);
        return NO;
    }
    
    if (self.transparentColor) {
        texImage = [texImage replacingOccurrencesOfPixel:self.transparentColor withColor:[SKColor colorWithRed:.0 green:.0 blue:.0 alpha:.0]];
    }
    _atlasTexture = [SKTexture textureWithImage:texImage];
    _atlasTexture.filteringMode = SKTextureFilteringNearest;    // Makes the sprite (atlasTexture) stay pixelated:
    self.imageSize = _atlasTexture.size;
//    if ([self.imageSource containsString:@"@2x"]) {
//        _imageSize.width *= 2.0;
//        _imageSize.height *= 2.0;
//    }
    
    // 计算tileset矩阵有几行几列
    _numCols = (_imageSize.width - _margin * 2 + _spacing) / (_tileWidth + _spacing);
    _numRows = (_imageSize.height - _margin * 2 + _spacing) / (_tileHeight + _spacing);
    m_Tiles = [[WBMatrix alloc] initWithRows:_numRows cols:_numCols];
    
    uint32_t tileCount = 0;
    for (uint32_t i=0; i<_numRows; i++) {
        for (uint32_t j=0; j<_numCols; j++) {
            TMXTile *tile = [TMXTile new];
            tile.tileset = self;
            tile.tileId = tileCount++;
            tile.size = CGSizeMake(_tileWidth, _tileHeight);
            tile.row = i;
            tile.column = j;
            [m_Tiles setObject:tile atRow:i col:j];
        }
    }
    return YES;
}

- (BOOL)parseTerraintypesWithElement:(ONOXMLElement *)element {
    NSAssert([@"terraintypes" isEqualToString:element.tag], @"ERROR: Not A terraintypes Element");
    for (ONOXMLElement *subElement in element.children) {
        if ([@"terrain" isEqualToString:subElement.tag]) {
            // if subElement[@"tile"] == -1  then no image display
            TMXTerrain *terrain = [self addTerrainWithName:subElement[@"name"] imageTileId:[subElement[@"tile"] intValue]];
            [terrain readProperties:[subElement firstChildWithTag:@"properties"]];
        }
    }
    return YES;
}

- (BOOL)parseTileWithElement:(ONOXMLElement *)element {
    NSAssert([@"tile" isEqualToString:element.tag], @"ERROR: Not A tile Element");
    
    uint32_t tileId = [element[@"id"] intValue];
    
    if (self.imageSource && tileId >= [self tileCount]) {
        SKTMLog(@"Tile ID does not exist in tileset image: %d", tileId);
        return NO;
    }
    
    TMXTile *tile = nil;
    if (tileId == [self tileCount]) {
        tile = [TMXTile new];
        tile.tileId = tileId;
        tile.row = 0;
        tile.column = tileId;
        tile.tileset = self;
        
        if (!m_Tiles) {
            _numRows = _numCols = 1;
            m_Tiles = [[WBMatrix alloc] initWithRows:_numRows cols:_numCols];
        } else {
            _numCols++;
            [m_Tiles updateMatrixColsNum:_numCols];
        }
        [m_Tiles setObject:tile atRow:tile.row col:tile.column];
    } else {
        tile = [self tileAtIndex:tileId];
    }
    
    // Read tile quadrant terrain ids
    NSString *terrainStr = element[@"terrain"];
    if (terrainStr) {
        NSArray *array = [terrainStr componentsSeparatedByString:@","];
        if (array.count==4) {
            for (int i=0; i<4; i++) {
                int t = [array[i] intValue];
                [tile setCornerTerrain:i terrainId:t];
            }
        }
    }
    
    // Read tile probability
    NSString *probabilityStr = element[@"probability"];
    if (probabilityStr) {
        [tile setTerrainProbability:probabilityStr.floatValue];
    }
    
    // read child
    for (ONOXMLElement *subElement in element.children) {
        if ([@"properties" isEqualToString:subElement.tag]) {
            [tile readProperties:subElement];
            
        } else if ([@"image" isEqualToString:subElement.tag]) {
            tile.imageSource = subElement[@"source"];
            tile.size = CGSizeMake([subElement[@"width"] intValue], [subElement[@"height"] intValue]);
            
        } else if ([@"objectgroup" isEqualToString:subElement.tag]) {
//            tile->setObjectGroup(readObjectGroup());
            
        } else if ([@"animation" isEqualToString:subElement.tag]) {
            [tile readAnimationFrames:subElement];
            
        }
    }
    
    
    return YES;
}



@end
