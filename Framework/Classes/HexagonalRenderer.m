//
//  HexagonalRenderer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/4.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "HexagonalRenderer.h"

@implementation HexagonalRenderer



#pragma mark - Coordinates System Convert
/**
 * Converts screen to tile coordinates.
 * Sub-tile return values are not supported by this renderer.
 */
- (CGPoint)screenToTileCoords:(CGPoint)pos {
    
    pos.y = self.mapPixelSize.height - pos.y;
    
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
        {0, 0}, {-1, 1}, {0, 1}, {0, 2}
    };
    
    const CGPoint *offsets = m_staggerX ? offsetsStaggerX : offsetsStaggerY;
    return CGPointMake(referencePoint.x + offsets[nearest].x, referencePoint.y + offsets[nearest].y);
}



@end
