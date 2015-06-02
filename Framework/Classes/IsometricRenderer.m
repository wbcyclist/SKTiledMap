//
//  IsometricRenderer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/29.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "IsometricRenderer.h"
#import "TMXBase.h"
#import "SKTMBase.h"

@interface IsometricRenderer ()

@end


@implementation IsometricRenderer {
    CGFloat m_tile_width_half;
    CGFloat m_tile_height_half;
    CGFloat m_origin_x;
    CGPoint m_factor;
}

- (void)updateRenderParams {
    m_tile_width_half = self.tileWidth/2.0;
    m_tile_height_half = self.tileHeight/2.0;
    m_origin_x = self.mapHeight * m_tile_width_half;
    m_factor.x = m_tile_width_half/self.tileHeight;
    m_factor.y = m_tile_height_half/self.tileHeight;
    
    CGFloat maxW = (self.mapWidth + self.mapHeight) * m_tile_width_half;
    CGFloat maxH = (self.mapWidth + self.mapHeight) * m_tile_height_half;
    self.mapPixelSize = CGSizeMake(maxW, maxH);
}


- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    SKTMTileLayer *layer = [SKTMTileLayer nodeWithModel:layerData];
    
    int columnLength = self.mapWidth;
    int rowLenght = self.mapHeight;
    
    int tileZIndex = 0;
    for(int p=0; p < rowLenght + columnLength - 1; p++) {
        for(int r=0; r <= p; r++) {
            int c = p-r;
            if(r < rowLenght && c < columnLength) {
//                NSLog(@"x, y = %d, %d", c, r);
                int tileIndex = c + r*columnLength;
                uint32_t gid = layerData.tiles[tileIndex];
                
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
                
                tile.position = [self tileToScreenCoords:CGPointMake(c, r)];
                CGPoint sPoint = [self tileToScreenCoords:CGPointMake(c+1, r+1)];
                SKTMTileNode *tileNode = [SKTMTileNode nodeWithModel:tile position:sPoint origin:BottomCenter];
                tileNode.zPosition = tileZIndex++;
                [layer addChild:tileNode];
            }
        }
    }
    
    return layer;
}


- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData {
    SKTMObjectGroupLayer *layer = [SKTMObjectGroupLayer nodeWithModel:layerData];
    
    int tileZIndex = 0;
    NSArray *objects = [layerData sortedObjectsWithDrawOrder:layerData.drawOrder];
    for (TMXObjectGroupNode *nodeData in objects) {
        if (nodeData.objGroupType == ObjectGroupType_Tile) {
            CGPoint sPoint = [self pixelToScreenCoords:nodeData.position];
            SKTMObjectGroupTile *tileNode = [SKTMObjectGroupTile nodeWithModel:nodeData position:sPoint origin:BottomCenter];
            tileNode.zPosition = tileZIndex++;
            [layer addChild:tileNode];
            
        } else {
            SKTMObjectGroupShape *shapeNode = [SKTMObjectGroupShape nodeWithModel:nodeData renderer:self];
            shapeNode.position = [self pixelToScreenCoords:CGPointMake(nodeData.position.x, nodeData.position.y)];
            shapeNode.zRotation = TMX_ROTATION(nodeData.rotation);
            shapeNode.zPosition = tileZIndex++;
            [layer addChild:shapeNode];
        }
    }
    
    return layer;
}

- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer *)layerData {
    SKTMImageLayer *imageLayer = [SKTMImageLayer nodeWithModel:layerData];
    
    imageLayer.position = CGPointMake(layerData.position.x, self.mapPixelSize.height - layerData.position.y);
    return imageLayer;
}



#pragma mark - Coordinates System Convert
- (CGPoint)pixelToTileCoords:(CGPoint)pos {
    return CGPointMake((int)(pos.x / self.tileHeight), (int)(pos.y / self.tileHeight));
}

- (CGPoint)tileToPixelCoords:(CGPoint)pos {
    return CGPointMake(pos.x * self.tileHeight, pos.y * self.tileHeight);
}


- (CGPoint)tileToScreenCoords:(CGPoint)pos {
    return CGPointMake((pos.x - pos.y) * m_tile_width_half + m_origin_x,
                       self.mapPixelSize.height - (pos.x + pos.y) * m_tile_height_half);
}

- (CGPoint)pixelToScreenCoords:(CGPoint)pos {
    return CGPointMake((pos.x - pos.y) * m_factor.x + m_origin_x,
                       self.mapPixelSize.height - (pos.x + pos.y) * m_factor.y);
}

- (CGPoint)screenToTileCoords:(CGPoint)pos {
    CGFloat tx = ((pos.x - m_origin_x)/m_tile_width_half + (self.mapPixelSize.height - pos.y)/m_tile_height_half) / 2.0;
    CGFloat ty = ((self.mapPixelSize.height - pos.y)/m_tile_height_half - (pos.x - m_origin_x)/m_tile_width_half) / 2.0;
    return CGPointMake((int)tx, (int)ty);
}

- (CGPoint)screenToPixelCoords:(CGPoint)pos {
    CGFloat tx = ((pos.x - m_origin_x)/m_factor.x + (self.mapPixelSize.height - pos.y)/m_factor.y) / 2.0;
    CGFloat ty = ((self.mapPixelSize.height - pos.y)/m_factor.y - (pos.x - m_origin_x)/m_factor.x) / 2.0;
    return CGPointMake(tx, ty);
}


@end
