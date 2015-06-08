//
//  OrthogonalRenderer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "OrthogonalRenderer.h"
#import "TMXBase.h"
#import "SKTMBase.h"


#define SWAP(x, y) do { typeof(x) SWAP = x; x = y; y = SWAP; } while (0)


@implementation OrthogonalRenderer


- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    SKTMTileLayer *layer = [SKTMTileLayer nodeWithModel:layerData];
    
    int startX = 0;
    int startY = 0;
    int endX = self.mapWidth - 1;
    int endY = self.mapHeight - 1;
    
    int incX = 1, incY = 1;
    RenderOrder renderOrder = self.map.renderOrder;
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
//            NSLog(@"%@", array[x + y*self.mapWidth]);
            uint32_t gid = layerData.tiles[x + y*self.mapWidth];
            
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
            
            SKTMTileNode *tileNode = [SKTMTileNode nodeWithModel:tile position:CGPointMake(x*self.tileWidth, (y+1)*self.tileHeight) origin:BottomLeft];
            tileNode.name = [NSString stringWithFormat:@"%d,%d", x, y];
            tileNode.position = [self pixelToScreenCoords:tileNode.pixelPos];
            tileNode.zPosition = tileZIndex++;
            [layer addChild:tileNode];
        }
    }
    
    return layer;
}

// OrthogonalRenderer, StaggeredRenderer, HexagonalRenderer
- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData {
    SKTMObjectGroupLayer *layer = [SKTMObjectGroupLayer nodeWithModel:layerData];
    
    int tileZIndex = 0;
    NSArray *objects = [layerData sortedObjectsWithDrawOrder:layerData.drawOrder];
    for (TMXObjectGroupNode *nodeData in objects) {
        if (nodeData.objGroupType == ObjectGroupType_Tile) {
            SKTMObjectGroupTile *tileNode = [SKTMObjectGroupTile nodeWithModel:nodeData position:nodeData.position origin:BottomLeft];
            tileNode.position = [self pixelToScreenCoords:tileNode.pixelPos];
            [tileNode updateTileRotation:TMX_ROTATION(nodeData.rotation)];
            tileNode.zPosition = tileZIndex++;
            [layer addChild:tileNode];
            
        } else {
            SKTMObjectGroupShape *shapeNode = [SKTMObjectGroupShape nodeWithModel:nodeData];
            shapeNode.position = [self pixelToScreenCoords:CGPointMake(nodeData.position.x, nodeData.position.y)];
            
            shapeNode.zRotation = TMX_ROTATION(nodeData.rotation);
            shapeNode.zPosition = tileZIndex++;
            [layer addChild:shapeNode];
        }
    }
    
    return layer;
}

// OrthogonalRenderer, StaggeredRenderer, HexagonalRenderer
- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer *)layerData {
    SKTMImageLayer *imageLayer = [SKTMImageLayer nodeWithModel:layerData];
    
    imageLayer.position = [self pixelToScreenCoords:CGPointMake(layerData.position.x, layerData.position.y)];
    return imageLayer;
}


#pragma mark - Coordinates System Convert
// OrthogonalRenderer, StaggeredRenderer, HexagonalRenderer
- (CGPoint)pixelToScreenCoords:(CGPoint)pos {
    return CGPointMake(pos.x, self.mapPixelSize.height - pos.y);
}

- (CGPoint)pixelToTileCoords:(CGPoint)pos {
    return CGPointMake((int)(pos.x / self.tileWidth), (int)(pos.y / self.tileHeight));
}

- (CGPoint)tileToPixelCoords:(CGPoint)pos {
    return CGPointMake(pos.x * self.tileWidth, pos.y * self.tileHeight);;
}

- (CGPoint)tileToScreenCoords:(CGPoint)pos {
    CGPoint pixel = [self tileToPixelCoords:pos];
    return [self pixelToScreenCoords:pixel];
}

// OrthogonalRenderer, StaggeredRenderer, HexagonalRenderer
- (CGPoint)screenToPixelCoords:(CGPoint)pos {
    return CGPointMake(pos.x, self.mapPixelSize.height - pos.y);
}

- (CGPoint)screenToTileCoords:(CGPoint)pos {
    CGPoint pixel = [self screenToPixelCoords:pos];
    return [self pixelToTileCoords:pixel];
}








@end
