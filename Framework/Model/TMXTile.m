//
//  TMXTile.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/19.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXTile.h"
#import "TMXTileset.h"
#import "TMXMap.h"
#import "TMXTerrain.h"

@implementation TMXTile

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_Tile;
}

- (id)copyWithZone:(NSZone *)zone {
    TMXTile *copy = [super copyWithZone:zone];
    copy.tileset = self.tileset;
    copy.tileId = self.tileId;
    copy.imageSource = self.imageSource;
    copy.flippedHorizontally = self.flippedHorizontally;
    copy.flippedVertically = self.flippedVertically;
    copy.flippedAntiDiagonally = self.flippedAntiDiagonally;
    copy.position = self.position;
    copy.size = self.size;
    copy.row = self.row;
    copy.column = self.column;
    copy.terrainValue = self.terrainValue;
    copy.terrainProbability = self.terrainProbability;
    copy.texture = _texture;
    return copy;
}


- (void)dealloc {
    self.texture = nil;
}

- (uint32_t)gId {
    return self.tileset.firstGid + self.tileId;
}

- (SKTexture *)texture {
    if (!_texture) {
        if (self.imageSource) {
            // get image texture
            NSString *imgFilePath = [self.tileset.map.filePath stringByAppendingPathComponent:self.imageSource];
            _texture = [SKTexture textureWithImageNamed:imgFilePath];
            if (!_texture) {
                SKTMLog(@"Image Not Found: %@", self.imageSource);
            }
        } else {
            _texture = [self.tileset textureForTile:self];
        }
    }
    return _texture;
    
}

- (TMXTerrain *)terrainAtCorner:(int)corner {
    int terrainId = [self cornerTerrainId:corner];
    if (terrainId > 0 && terrainId < self.tileset.terrainTypes.count) {
        return self.tileset.terrainTypes[terrainId];
    }
    return nil;
}

- (int)cornerTerrainId:(int)corner {
    unsigned t = (self.terrainValue >> (3 - corner)*8) & 0xFF;
    return t == 0xFF ? -1 : (int)t;
}

- (void)setCornerTerrain:(int)corner terrainId:(int)terrainId {
    [self updateTerrain:[TMXTerrain getTerrainCorner:self.terrainValue corner:corner terrainId:terrainId]];
}

- (void)updateTerrain:(unsigned)terrain {
    if (self.terrainValue == terrain) {
        return;
    }
    self.terrainValue = terrain;
    self.tileset.terrainDistancesDirty = YES;
}




@end
