//
//  SKMapRenderer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKMapRenderer.h"
#import "TMXBase.h"
#import "SKTMBase.h"

@implementation SKMapRenderer

- (void)setMap:(TMXMap *)map {
    _map = map;
    self.tileWidth = map.tileWidth;
    self.tileHeight = map.tileHeight;
    self.mapWidth = map.width;
    self.mapHeight = map.height;
    [self updateRenderParams];
    
    //
    self.tileZPositions = malloc(self.mapWidth * self.mapHeight * sizeof(int));
    [self setupTileZPosition];
}

- (void)dealloc {
    if (_tileZPositions) {
        free(_tileZPositions);
        _tileZPositions = NULL;
    }
}

- (void)setTileZPositions:(int *)tileZPositions {
    if (_tileZPositions && _tileZPositions != tileZPositions) {
        free(_tileZPositions);
        _tileZPositions = NULL;
    }
    _tileZPositions = tileZPositions;
}

- (int)zPositionInTileCoords:(CGPoint)pos {
    int x = pos.x;
    int y = pos.y;
    if (x<0 || x>=self.mapWidth || y<0 || y>=self.mapHeight) {
        return 0;
    }
    return self.tileZPositions[x + y*self.mapWidth];
}

- (void)updateRenderParams {
    self.mapPixelSize = CGSizeMake(_tileWidth*_mapWidth, _tileHeight*_mapHeight);
}

- (void)setupTileZPosition {
    
}


- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    return nil;
}

- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData {
    return nil;
}

- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer *)layerData {
    return nil;
}

#pragma mark - Coordinates System Convert
- (CGPoint)pixelToScreenCoords:(CGPoint)pos {
    return pos;
}

- (CGPoint)pixelToTileCoords:(CGPoint)pos {
    return pos;
}

- (CGPoint)tileToPixelCoords:(CGPoint)pos {
    return pos;
}

- (CGPoint)tileToScreenCoords:(CGPoint)pos {
    return pos;
}

- (CGPoint)screenToPixelCoords:(CGPoint)pos {
    return pos;
}

- (CGPoint)screenToTileCoords:(CGPoint)pos {
    return pos;
}





@end
