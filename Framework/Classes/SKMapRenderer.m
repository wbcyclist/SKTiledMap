//
//  SKMapRenderer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKMapRenderer.h"

@implementation SKMapRenderer


- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    return nil;
}

- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData {
    return nil;
}

- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer *)layerData {
    return nil;
}

- (CGPoint)tileToScreenCoords:(CGPoint)tPoint withMapSize:(CGSize)mapSize {
    return tPoint;
}

@end
