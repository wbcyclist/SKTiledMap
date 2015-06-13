//
//  StaggeredRenderer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/2.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "StaggeredRenderer.h"
#import "TMXBase.h"
#import "SKTMBase.h"

@implementation StaggeredRenderer {
    
}

// 交错时景深在前的返回YES (StaggerOdd时，奇数返回YES。StaggerEven时，偶数返回YES)
- (BOOL)doStaggerX:(int)x {
    return m_staggerX && (x & 1) ^ m_staggerEven;
}

// 交错时靠右的返回YES (StaggerOdd时，奇数返回YES。StaggerEven时，偶数返回YES)
- (BOOL)doStaggerY:(int)y {
    return !m_staggerX && (y & 1) ^ m_staggerEven;
}

- (void)updateRenderParams {
    m_staggerX = self.map.staggerAxis == StaggerAxis_StaggerX;
    m_staggerEven = self.map.staggerIndex == StaggerIndex_StaggerEven;
    
    m_sideLengthX = m_sideLengthY = 0;
    if (self.map.orientation==OrientationStyle_Hexagonal) {
        if (m_staggerX) {
            m_sideLengthX = self.map.hexSideLength;
        } else {
            m_sideLengthY = self.map.hexSideLength;
        }
    }
    
    // 将奇数-1变为偶数
    self.tileWidth = self.tileWidth & ~1;
    self.tileHeight = self.tileHeight & ~1;
    
    m_sideOffsetX = (self.tileWidth - m_sideLengthX) / 2;
    m_sideOffsetY = (self.tileHeight - m_sideLengthY) / 2;
    
    m_columnWidth = m_sideOffsetX + m_sideLengthX;
    m_rowHeight = m_sideOffsetY + m_sideLengthY;
    
    // The map size is the same regardless of which indexes are shifted.
    if (m_staggerX) {
        self.mapPixelSize = CGSizeMake(self.mapWidth * m_columnWidth + m_sideOffsetX,
                                       self.mapHeight * (self.tileHeight + m_sideLengthY));
        
        if (self.mapWidth > 1)
            self.mapPixelSize = CGSizeMake(self.mapPixelSize.width, self.mapPixelSize.height + m_rowHeight);
        
    } else {
        self.mapPixelSize = CGSizeMake(self.mapWidth * (self.tileWidth + m_sideLengthX),
                                       self.mapHeight * m_rowHeight + m_sideOffsetY);
        
        if (self.mapHeight > 1)
            self.mapPixelSize = CGSizeMake(self.mapPixelSize.width + m_columnWidth, self.mapPixelSize.height);
    }
//    SKTMLog(@"self.mapPixelSize=%@", NSStringFromCGSize(self.mapPixelSize));
//    SKTMLog(@"self.tileSize=%d, %d", self.tileWidth, self.tileHeight);
//    SKTMLog(@"m_columnWidth=%@", @(m_columnWidth));
//    SKTMLog(@"m_rowHeight=%@", @(m_rowHeight));
//    SKTMLog(@"m_sideLengthX=%@", @(m_sideLengthX));
//    SKTMLog(@"m_sideOffsetX=%@", @(m_sideOffsetX));
//    SKTMLog(@"m_sideOffsetY=%@", @(m_sideOffsetY));
}

- (void)setupTileZPosition {
    CGPoint startTile = CGPointMake(0, 0);
    CGPoint startPos = [self tileToScreenCoords:startTile];
    
    int tileZIndex = 0;
    
    if (m_staggerX) {
        BOOL staggeredRow = [self doStaggerX:startTile.x];
        
        if (staggeredRow) {
            startTile.x += 1;
            startPos.x += m_columnWidth;
            startPos.y += m_rowHeight;
        }
        
        for (; startPos.y > 0 && startTile.y < self.mapHeight;) {
            CGPoint rowTile = startTile;
            CGPoint rowPos = startPos;
            
            for (; rowPos.x < self.mapPixelSize.width && rowTile.x < self.mapWidth; rowTile.x += 2) {
                if (rowTile.x>=0 && rowTile.y>=0 && rowTile.x < self.mapWidth && rowTile.y < self.mapHeight) {
                    int tileId = rowTile.x + rowTile.y*self.mapWidth;
                    self.tileZPositions[tileId] = tileZIndex++;
                }
                rowPos.x += self.tileWidth + m_sideLengthX;
            }
            
            if ([self doStaggerX:startTile.x]) {
                startTile.y += 1;
            }
            
            if (staggeredRow) {
                startTile.x -= 1;
                startPos.x -= m_columnWidth;
                staggeredRow = NO;
            } else {
                startTile.x += 1;
                startPos.x += m_columnWidth;
                staggeredRow = YES;
            }
            
            startPos.y -= m_rowHeight;
        }
        
    } else {
        startPos.x = 0;
        for (; startPos.y > 0 && startTile.y < self.mapHeight; startTile.y++) {
            CGPoint rowTile = startTile;
            CGPoint rowPos = startPos;
            
            if ([self doStaggerY:startTile.y])
                rowPos.x += m_columnWidth;
            
            for (int i=0; i<self.mapWidth; i++) {
                int tileId = rowTile.x + rowTile.y*self.mapWidth;
                self.tileZPositions[tileId] = tileZIndex++;
                
                rowTile.x++;
                rowPos.x += self.tileWidth + m_sideLengthX;
            }
            
            startPos.y -= m_rowHeight;
        }
    }
}



- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    SKTMTileLayer *layer = [SKTMTileLayer nodeWithModel:layerData];
    
    CGPoint startTile = CGPointMake(0, 0);
    CGPoint startPos = [self tileToScreenCoords:startTile];
    
    int tileZIndex = 0;
    
    if (m_staggerX) {
        BOOL staggeredRow = [self doStaggerX:startTile.x];
        
        if (staggeredRow) {
            startTile.x += 1;
            startPos.x += m_columnWidth;
            startPos.y += m_rowHeight;
        }
        
        for (; startPos.y > 0 && startTile.y < self.mapHeight;) {
            CGPoint rowTile = startTile;
            CGPoint rowPos = startPos;
            
            for (; rowPos.x < self.mapPixelSize.width && rowTile.x < self.mapWidth; rowTile.x += 2) {
                if (rowTile.x>=0 && rowTile.y>=0 && rowTile.x < self.mapWidth && rowTile.y < self.mapHeight) {
//                    NSLog(@"rowTile=%@", NSStringFromCGPoint(rowTile));
//                    NSLog(@"rowPos=%@", NSStringFromCGPoint(rowPos));
                    tileZIndex++;
                    SKTMTileNode *tileNode = [self createTileNodeWithRowTile:rowTile andRowPos:rowPos atLayer:layerData];
                    if (tileNode) {
                        tileNode.zPosition = tileZIndex - 1;
                        [layer addChild:tileNode];
                    }
                    
                }
                rowPos.x += self.tileWidth + m_sideLengthX;
            }
            
            if ([self doStaggerX:startTile.x]) {
                startTile.y += 1;
            }
            
            if (staggeredRow) {
                startTile.x -= 1;
                startPos.x -= m_columnWidth;
                staggeredRow = NO;
            } else {
                startTile.x += 1;
                startPos.x += m_columnWidth;
                staggeredRow = YES;
            }
            
            startPos.y -= m_rowHeight;
        }
        
    } else {
        startPos.x = 0;
        for (; startPos.y > 0 && startTile.y < self.mapHeight; startTile.y++) {
            CGPoint rowTile = startTile;
            CGPoint rowPos = startPos;
            
            if ([self doStaggerY:startTile.y])
                rowPos.x += m_columnWidth;
            
            for (int i=0; i<self.mapWidth; i++) {
                tileZIndex++;
                SKTMTileNode *tileNode = [self createTileNodeWithRowTile:rowTile andRowPos:rowPos atLayer:layerData];
                if (tileNode) {
                    tileNode.zPosition = tileZIndex - 1;
                    [layer addChild:tileNode];
                }
                
                rowTile.x++;
                rowPos.x += self.tileWidth + m_sideLengthX;
            }
            
            startPos.y -= m_rowHeight;
        }
    }
    
    
    
    return layer;
}


- (SKTMTileNode *)createTileNodeWithRowTile:(CGPoint)rowTile andRowPos:(CGPoint)rowPos atLayer:(TMXTileLayer *)layerData {
    int x, y;
    x = rowTile.x;
    y = rowTile.y;
    uint32_t gid = layerData.tiles[x + y*self.mapWidth];
    
    BOOL flipX = (gid & kTileHorizontalFlag) != 0;
    BOOL flipY = (gid & kTileVerticalFlag) != 0;
    BOOL flipDiag = (gid & kTileDiagonalFlag) != 0;
    // clear all flag
    gid = gid & kFlippedMask;
    TMXTile *tile = [layerData.map tileAtGid:gid];
    if (!tile) {
        return nil;
    }
    tile.flippedHorizontally = flipX;
    tile.flippedVertically = flipY;
    tile.flippedAntiDiagonally = flipDiag;
    
    CGPoint pixelPos = [self screenToPixelCoords:CGPointMake(rowPos.x, rowPos.y - self.tileHeight)];
    SKTMTileNode *tileNode = [SKTMTileNode nodeWithModel:tile position:pixelPos origin:BottomLeft];
    tileNode.position = [self pixelToScreenCoords:tileNode.pixelPos];
    tileNode.name = [NSString stringWithFormat:@"%d,%d", x, y];
    return tileNode;
}


#pragma mark - Coordinates System Convert
/**
 * Converts tile to screen coordinates.
 * Sub-tile return values are not supported by this renderer.
 */
- (CGPoint)tileToScreenCoords:(CGPoint)pos {
    int tileX = floor(pos.x);
    int tileY = floor(pos.y);
    int pixelX, pixelY;
    
    if (m_staggerX) {
        pixelY = self.mapPixelSize.height - tileY * (self.tileHeight + m_sideLengthY);
        if ([self doStaggerX:tileX]) {
            pixelY -= m_rowHeight;
        }
        pixelX = tileX * m_columnWidth;
        
    } else {
        pixelX = tileX * (self.tileWidth + m_sideLengthX);
        if ([self doStaggerY:tileY]) {
            pixelX += m_columnWidth;
        }
        pixelY = self.mapPixelSize.height - tileY * m_rowHeight;
    }
    
    return CGPointMake(pixelX, pixelY);
}

- (CGPoint)tileToPixelCoords:(CGPoint)pos {
    return [self screenToPixelCoords:[self tileToScreenCoords:pos]];
}

/**
 * Converts screen to tile coordinates.
 * Sub-tile return values are not supported by this renderer.
 */
- (CGPoint)screenToTileCoords:(CGPoint)pos {
    
    pos.y = self.mapPixelSize.height - pos.y;
    
    if (m_staggerX)
        pos.x -= m_staggerEven ? m_sideOffsetX : 0;
    else
        pos.y -= m_staggerEven ? m_sideOffsetY : 0;
    
    // Start with the coordinates of a grid-aligned tile
    CGPoint referencePoint = CGPointMake(floor(pos.x / self.tileWidth),
                                         floor(pos.y / self.tileHeight));
    
    // Relative x and y position on the base square of the grid-aligned tile
    CGPoint rel = CGPointMake(pos.x - referencePoint.x * self.tileWidth,
                              pos.y - referencePoint.y * self.tileHeight);
    
    // Adjust the reference point to the correct tile coordinates
    if (m_staggerX) {
        referencePoint.x *= 2;
        if (m_staggerEven)
            referencePoint.x++;
    } else {
        referencePoint.y *= 2;
        if (m_staggerEven)
            referencePoint.y++;
    }
    
    CGFloat y_pos = rel.x * ((CGFloat)self.tileHeight / (CGFloat)self.tileWidth);
    
    // Check whether the cursor is in any of the corners (neighboring tiles)
    if (m_sideOffsetY - y_pos > rel.y)
        return [self topLeftX:referencePoint.x Y:referencePoint.y];
    if (-m_sideOffsetY + y_pos > rel.y)
        return [self topRightX:referencePoint.x Y:referencePoint.y];
    
    if (m_sideOffsetY + y_pos < rel.y)
        return [self bottomLeftX:referencePoint.x Y:referencePoint.y];
    if (m_sideOffsetY * 3 - y_pos < rel.y)
        return [self bottomRightX:referencePoint.x Y:referencePoint.y];
    
    return referencePoint;
    
}

- (CGPoint)pixelToTileCoords:(CGPoint)pos {
    return [self screenToTileCoords:[self pixelToScreenCoords:pos]];
}




- (CGPoint)topLeftX:(int)x Y:(int)y {
    if (!m_staggerX) {
        if ((y & 1) ^ self.map.staggerIndex)
            return CGPointMake(x, y - 1);
        else
            return CGPointMake(x - 1, y - 1);
    } else {
        if ((x & 1) ^ self.map.staggerIndex)
            return CGPointMake(x - 1, y);
        else
            return CGPointMake(x - 1, y - 1);
    }
}

- (CGPoint)topRightX:(int)x Y:(int)y {
    if (!m_staggerX) {
        if ((y & 1) ^ self.map.staggerIndex)
            return CGPointMake(x + 1, y - 1);
        else
            return CGPointMake(x, y - 1);
    } else {
        if ((x & 1) ^ self.map.staggerIndex)
            return CGPointMake(x + 1, y);
        else
            return CGPointMake(x + 1, y - 1);
    }
}

- (CGPoint)bottomLeftX:(int)x Y:(int)y {
    if (!m_staggerX) {
        if ((y & 1) ^ self.map.staggerIndex)
            return CGPointMake(x, y + 1);
        else
            return CGPointMake(x - 1, y + 1);
    } else {
        if ((x & 1) ^ self.map.staggerIndex)
            return CGPointMake(x - 1, y + 1);
        else
            return CGPointMake(x - 1, y);
    }
}

- (CGPoint)bottomRightX:(int)x Y:(int)y {
    if (!m_staggerX) {
        if ((y & 1) ^ self.map.staggerIndex)
            return CGPointMake(x + 1, y + 1);
        else
            return CGPointMake(x, y + 1);
    } else {
        if ((x & 1) ^ self.map.staggerIndex)
            return CGPointMake(x + 1, y + 1);
        else
            return CGPointMake(x + 1, y);
    }
}




@end
