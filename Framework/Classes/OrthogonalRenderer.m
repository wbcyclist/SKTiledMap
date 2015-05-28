//
//  OrthogonalRenderer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "OrthogonalRenderer.h"

#define SWAP(x, y) do { typeof(x) SWAP = x; x = y; y = SWAP; } while (0)


@implementation OrthogonalRenderer


- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    SKTMTileLayer *layer = [SKTMTileLayer nodeWithModel:layerData];
    
    int columnLength = layerData.map.width;
    int rowLenght = layerData.map.height;
    int tileWidth = layerData.map.tileWidth;
    int tileHeight = layerData.map.tileHeight;
    CGSize mapSize = CGSizeMake(columnLength*tileWidth, rowLenght*tileHeight);
    
    
    int startX = 0;
    int startY = 0;
    int endX = columnLength - 1;
    int endY = rowLenght - 1;
    
    int incX = 1, incY = 1;
    RenderOrder renderOrder = layerData.map.renderOrder;
    switch (renderOrder) {
        case RenderOrder_RightUp:
            SWAP(startY, endY);
            incY = -1;
            break;
        case RenderOrder_LeftDown:
            SWAP(startX, endX);
            incX = -1;
            break;
        case RenderOrder_LeftUp:
            SWAP(startX, endX);
            SWAP(startY, endY);
            incX = -1;
            incY = -1;
            break;
        case RenderOrder_RightDown:
        default:
            break;
    }
    endX += incX;
    endY += incY;
    
    int tileZIndex = 0;
    for (int y = startY; y != endY; y += incY) {
        for (int x = startX; x != endX; x += incX) {
//            NSLog(@"x=%d, y=%d", x, y);
//            NSLog(@"%@", array[x + y*columnLength]);
            uint32_t gid = layerData.tiles[x + y*columnLength];
            
            BOOL flipX = (gid & kTileHorizontalFlag) != 0;
            BOOL flipY = (gid & kTileVerticalFlag) != 0;
            BOOL flipDiag = (gid & kTileDiagonalFlag) != 0;
            // clear all flag
            gid = gid & kFlippedMask;
            TMXTile *tile = [layerData.map tileAtGid:gid];
            if (!tile) {
                continue;
            }
            tile.flippedHorizontally = flipX;
            tile.flippedVertically = flipY;
            tile.flippedAntiDiagonally = flipDiag;
            
            CGPoint offset = tile.tileset.tileOffset;
            
            SKTMTileNode *tileNode = [SKTMTileNode nodeWithModel:tile];
            tile.position = CGPointMake(x*tileWidth + offset.x, (y+1)*tileHeight + offset.y);
            tileNode.position = [self tileToScreenCoords:CGPointMake(tile.position.x + tileNode.tileOffset.x,
                                                                     tile.position.y + tileNode.tileOffset.y)
                                             withMapSize:mapSize];
            tileNode.zPosition = tileZIndex++;
            
            [layer addChild:tileNode];
        }
    }
    
    return layer;
}

- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData {
    SKTMObjectGroupLayer *layer = [SKTMObjectGroupLayer nodeWithModel:layerData];
    
    int columnLength = layerData.map.width;
    int rowLenght = layerData.map.height;
    int tileWidth = layerData.map.tileWidth;
    int tileHeight = layerData.map.tileHeight;
    CGSize mapSize = CGSizeMake(columnLength*tileWidth, rowLenght*tileHeight);
    
    int tileZIndex = 0;
    NSArray *objects = [layerData sortedObjectsWithDrawOrder:layerData.drawOrder];
    for (TMXObjectGroupNode *nodeData in objects) {
        if (nodeData.objGroupType == ObjectGroupType_Tile) {
            CGPoint offset = nodeData.tile.tileset.tileOffset;
            
            SKTMObjectGroupTile *tileNode = [SKTMObjectGroupTile nodeWithModel:nodeData];
            tileNode.position = [self tileToScreenCoords:CGPointMake(nodeData.position.x + tileNode.tileOffset.x + offset.x,
                                                                     nodeData.position.y + tileNode.tileOffset.y + offset.y)
                                             withMapSize:mapSize];
            [tileNode updateTileRotation:TMX_ROTATION(nodeData.rotation)];
            tileNode.zPosition = tileZIndex++;
            [layer addChild:tileNode];
            
        } else {
            SKTMObjectGroupShape *shapeNode = [SKTMObjectGroupShape nodeWithModel:nodeData];
            shapeNode.position = [self tileToScreenCoords:CGPointMake(nodeData.position.x, nodeData.position.y) withMapSize:mapSize];
            shapeNode.zRotation = TMX_ROTATION(nodeData.rotation);
            shapeNode.zPosition = tileZIndex++;
            [layer addChild:shapeNode];
        }
    }
    
    return layer;
}


- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer *)layerData {
    SKTMImageLayer *imageLayer = [SKTMImageLayer nodeWithModel:layerData];
    
    int columnLength = layerData.map.width;
    int rowLenght = layerData.map.height;
    int tileWidth = layerData.map.tileWidth;
    int tileHeight = layerData.map.tileHeight;
    CGSize mapSize = CGSizeMake(columnLength*tileWidth, rowLenght*tileHeight);
    
    imageLayer.position = [self tileToScreenCoords:CGPointMake(layerData.position.x, layerData.position.y) withMapSize:mapSize];
    return imageLayer;
}


- (CGPoint)tileToScreenCoords:(CGPoint)tPoint withMapSize:(CGSize)mapSize{
    return CGPointMake(tPoint.x, mapSize.height - tPoint.y);
}



@end
