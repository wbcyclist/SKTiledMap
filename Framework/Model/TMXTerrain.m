//
//  TMXTerrain.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/23.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXTerrain.h"
#import "TMXTile.h"
#import "TMXTileset.h"

@implementation TMXTerrain {
    NSMutableArray *m_TransitionDistance;
}

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_Terrain;
}

- (TMXTile *)imageTile {
    if (self.imageTileId < 0) {
        return nil;
    }
    return [self.tileset tileAtIndex:self.imageTileId];
}

- (void)setTransitionDistances:(NSMutableArray *)transitionDistances {
    m_TransitionDistance = transitionDistances;
}

- (void)setTransitionDistance:(int)targetTerrainType distance:(int)distance {
    m_TransitionDistance[targetTerrainType + 1] = @(distance);
}

- (int)transitionDistance:(int)targetTerrainType {
    return [m_TransitionDistance[targetTerrainType + 1] intValue];
}

+ (unsigned int)getTerrainCorner:(unsigned int)terrain corner:(int)corner terrainId:(int)terrainId {
    unsigned mask = 0xFF << (3 - corner) * 8;
    unsigned insert = terrainId << (3 - corner) * 8;
    return (terrain & ~mask) | (insert & mask);
}

@end
