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
}

//- (void)setTileWidth:(uint32_t)tileWidth {
//    _tileWidth = tileWidth;
//    [self updateRenderParams];
//}
//
//- (void)setTileHeight:(uint32_t)tileHeight {
//    _tileHeight = tileHeight;
//    [self updateRenderParams];
//}
//
//- (void)setMapWidth:(uint32_t)mapWidth {
//    _mapWidth = mapWidth;
//    [self updateRenderParams];
//}
//
//- (void)setMapHeight:(uint32_t)mapHeight {
//    _mapHeight = mapHeight;
//    [self updateRenderParams];
//}

- (void)updateRenderParams {
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
