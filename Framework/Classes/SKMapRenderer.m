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

- (void)setTileWidth:(uint32_t)tileWidth {
    _tileWidth = tileWidth;
    [self updateMapPixelSize];
}

- (void)setTileHeight:(uint32_t)tileHeight {
    _tileHeight = tileHeight;
    [self updateMapPixelSize];
}

- (void)setMapWidth:(uint32_t)mapWidth {
    _mapWidth = mapWidth;
    [self updateMapPixelSize];
}

- (void)setMapHeight:(uint32_t)mapHeight {
    _mapHeight = mapHeight;
    [self updateMapPixelSize];
}

- (void)updateMapPixelSize {
    self.mapPixelSize = CGSizeMake(_tileWidth*_mapWidth, _tileHeight*_mapHeight);
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
    return CGPointZero;
}

- (CGPoint)pixelToTileCoords:(CGPoint)pos {
    return CGPointZero;
}

- (CGPoint)tileToPixelCoords:(CGPoint)pos {
    return CGPointZero;
}

- (CGPoint)tileToScreenCoords:(CGPoint)pos {
    return CGPointZero;
}

- (CGPoint)screenToPixelCoords:(CGPoint)pos {
    return CGPointZero;
}

- (CGPoint)screenToTileCoords:(CGPoint)pos {
    return CGPointZero;
}





@end
