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
    int m_sideLengthX;
    int m_sideOffsetX;
    int m_sideLengthY;
    int m_sideOffsetY;
    int m_rowHeight;
    int m_columnWidth;
    BOOL m_staggerX;
    BOOL m_staggerEven;
}

- (BOOL)doStaggerX:(int)x {
    return m_staggerX && (x & 1) ^ m_staggerEven;
}

- (BOOL)doStaggerY:(int)y {
    return !m_staggerX && (y & 1) ^ m_staggerEven;
}

- (void)updateRenderParams {
    m_staggerX = self.map.staggerAxis == StaggerAxis_StaggerX;
    m_staggerEven = self.map.staggerIndex == StaggerIndex_StaggerEven;
    
    if (self.map.orientation==OrientationStyle_Hexagonal) {
        if (m_staggerX) {
            m_sideLengthX = self.map.hexSideLength;
        } else {
            m_sideLengthY = self.map.hexSideLength;
        }
    }
    
    m_sideOffsetX = (self.tileWidth - m_sideLengthX) / 2;
    m_sideLengthY = (self.tileHeight - m_sideLengthY) / 2;
    
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
}


- (CGRect)boundingRect {
    CGRect rect = CGRectMake(0, 0, self.mapWidth, self.mapHeight);
    CGPoint topLeft = [self tileToScreenCoords:rect.origin];
    int width, height;
    
    if (m_staggerX) {
        width = CGRectGetWidth(rect) * m_columnWidth + m_sideOffsetX;
        height = CGRectGetHeight(rect) * (self.tileHeight + m_sideLengthY);
        
        if (CGRectGetWidth(rect) > 1) {
            height += m_rowHeight;
            if ([self doStaggerX:rect.origin.x]) {
                topLeft.y -= m_rowHeight;
            }
            
        }
    } else {
        width = CGRectGetWidth(rect) * (self.tileWidth + m_sideLengthX);
        height = CGRectGetHeight(rect) * m_rowHeight + m_sideOffsetY;
        
        if (CGRectGetHeight(rect) > 1) {
            width += m_columnWidth;
            if ([self doStaggerY:rect.origin.y]) {
                topLeft.x -= m_columnWidth;
            }
                
        }
    }
    
    return CGRectMake(topLeft.x, topLeft.y, width, height);
}



- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    SKTMTileLayer *layer = [SKTMTileLayer nodeWithModel:layerData];
    
    CGRect rect = [self boundingRect];
    
    // Determine the tile and pixel coordinates to start at
    CGPoint startTile = [self screenToTileCoords:rect.origin];
    CGPoint startPos = [self tileToScreenCoords:startTile];
    
    /* Determine in which half of the tile the top-left corner of the area we
     * need to draw is. If we're in the upper half, we need to start one row
     * up due to those tiles being visible as well. How we go up one row
     * depends on whether we're in the left or right half of the tile.
     */
    BOOL inUpperHalf = rect.origin.y - startPos.y < m_sideOffsetY;
    BOOL inLeftHalf = rect.origin.x - startPos.x < m_sideOffsetX;
    
    if (inUpperHalf)
        startTile.y--;
    if (inLeftHalf)
        startTile.x--;
    
    if (m_staggerX) {
        startTile.x = MAX(-1, startTile.x);
        startTile.y = MAX(-1, startTile.y);
        
        startPos = [self tileToScreenCoords:startTile];
        startPos.y += self.tileHeight;
        
        BOOL staggeredRow = [self doStaggerX:startTile.x];
        
        for (; startPos.y < (CGRectGetMaxY(rect) - 1) && startTile.y < self.mapHeight;) {
            CGPoint rowTile = startTile;
            CGPoint rowPos = startPos;
            
            for (; rowPos.x < (CGRectGetMaxX(rect) - 1) && rowTile.x < self.mapWidth; rowTile.x += 2) {
                
                if (rowTile.x>=0 && rowTile.y>=0 && rowTile.x < self.mapWidth && rowTile.y < self.mapHeight) {
                    NSLog(@"rowTile=%@", NSStringFromCGPoint(rowTile));
                }
                
                rowPos.x += self.tileWidth + m_sideLengthX;
            }
            
            if (staggeredRow) {
                startTile.x -= 1;
                startTile.y += 1;
                startPos.x -= m_columnWidth;
                staggeredRow = NO;
            } else {
                startTile.x += 1;
                startPos.x += m_columnWidth;
                staggeredRow = YES;
            }
            
            startPos.y += m_rowHeight;
        }
    } else {
        startTile.x = MAX(0, startTile.x);
        startTile.y = MAX(0, startTile.y);
        
        startPos = [self tileToScreenCoords:startTile];
        startPos.y += self.tileHeight;
        
        // Odd row shifting is applied in the rendering loop, so un-apply it here
        if ([self doStaggerY:startTile.y])
            startPos.x -= m_columnWidth;
        
        for (; startPos.y < (CGRectGetMaxY(rect) - 1) && startTile.y < self.mapHeight; startTile.y++) {
            CGPoint rowTile = startTile;
            CGPoint rowPos = startPos;
            
            if ([self doStaggerY:startTile.y])
                rowPos.x += m_columnWidth;
            
            for (; rowPos.x < (CGRectGetMaxX(rect) - 1) && rowTile.x < self.mapWidth; rowTile.x++) {
                if (rowTile.x>=0 && rowTile.y>=0 && rowTile.x < self.mapWidth && rowTile.y < self.mapHeight) {
                    NSLog(@"rowTile=%@", NSStringFromCGPoint(rowTile));
                }
                
                rowPos.x += self.tileWidth + m_sideLengthX;
            }
            
            startPos.y += m_rowHeight;
        }
    }
    
    
    
    return layer;
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
        pixelY = tileY * (self.tileHeight + m_sideLengthY);
        if ([self doStaggerX:tileX]) {
            pixelY += m_rowHeight;
        }
        pixelX = tileX * m_columnWidth;
        
    } else {
        pixelX = tileX * (self.tileWidth + m_sideLengthX);
        if ([self doStaggerY:tileY]) {
            pixelX += m_columnWidth;
        }
        pixelY = tileY * m_rowHeight;
    }
    
    return CGPointMake(pixelX, pixelY);
}



/**
 * Converts screen to tile coordinates.
 * Sub-tile return values are not supported by this renderer.
 */
- (CGPoint)screenToTileCoords:(CGPoint)pos {
    
    if (m_staggerX)
        pos.x -= m_staggerEven ? self.tileWidth : m_sideOffsetX;
    else
        pos.y -= m_staggerEven ? self.tileHeight : m_sideOffsetY;
    
    // Start with the coordinates of a grid-aligned tile
    CGPoint referencePoint = CGPointMake(floor(pos.x / (self.tileWidth + m_sideLengthX)),
                                         floor(pos.y / (self.tileHeight + m_sideLengthY)));
    
    // Relative x and y position on the base square of the grid-aligned tile
    CGPoint rel = CGPointMake(pos.x - referencePoint.x * (self.tileWidth + m_sideLengthX),
                              pos.y - referencePoint.y * (self.tileHeight + m_sideLengthY));
    
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
    
    // Determine the nearest hexagon tile by the distance to the center
    CGPoint centers[4];
    
    if (m_staggerX) {
        int left = m_sideLengthX / 2;
        int centerX = left + m_columnWidth;
        int centerY = self.tileHeight / 2;
        
        centers[0] = CGPointMake(left, centerY);
        centers[1] = CGPointMake(centerX, centerY - m_rowHeight);
        centers[2] = CGPointMake(centerX, centerY + m_rowHeight);
        centers[3] = CGPointMake(centerX + m_columnWidth, centerY);
    } else {
        int top = m_sideLengthY / 2;
        int centerX = self.tileWidth / 2;
        int centerY = top + m_rowHeight;
        
        centers[0] = CGPointMake(centerX, top);
        centers[1] = CGPointMake(centerX - m_columnWidth, centerY);
        centers[2] = CGPointMake(centerX + m_columnWidth, centerY);
        centers[3] = CGPointMake(centerX, centerY + m_rowHeight);
    }
    
    int nearest = 0;
    CGFloat minDist = CGFLOAT_MAX;
    
    for (int i = 0; i < 4; i++) {
        CGPoint center = centers[i];
        CGFloat dx = center.x - rel.x;
        CGFloat dy = center.y - rel.y;
//        CGFloat dc = (center - rel).lengthSquared();
        CGFloat dc = dx*dx + dy+dy;
        if (dc < minDist) {
            minDist = dc;
            nearest = i;
        }
    }
    
    
    static const CGPoint offsetsStaggerX[4] = {
        {0, 0}, {1, -1}, {1, 0}, {2, 0}
    };
    
    static const CGPoint offsetsStaggerY[4] = {
        {0, 0}, {1, 1}, {0, 1}, {0, 2}
    };
    
    const CGPoint *offsets = m_staggerX ? offsetsStaggerX : offsetsStaggerY;
    return CGPointMake(referencePoint.x + offsets[nearest].x, referencePoint.y + offsets[nearest].y);
}




@end
