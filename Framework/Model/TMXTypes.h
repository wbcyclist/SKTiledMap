//
//  TMXTypes.h
//
//  Created by JasioWoo on 14/9/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#ifndef _TMXTYPES_
    #define _TMXTYPES_

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#if TARGET_OS_IPHONE
    #define SKTM_CGPointToNSValue(p) [NSValue valueWithCGPoint:p]
    #define SKTM_NSValueToCGPoint(v) v.CGPointValue
#else
    #define SKTM_CGPointToNSValue(p) [NSValue valueWithPoint:p]
    #define SKTM_NSValueToCGPoint(v) v.pointValue

    #ifndef NSStringFromCGPoint
        #define NSStringFromCGPoint(p) NSStringFromPoint(p)
    #endif
    #ifndef NSStringFromCGSize
        #define NSStringFromCGSize(s) NSStringFromSize(s)
    #endif
    #ifndef NSStringFromCGRect
        #define NSStringFromCGRect(r) NSStringFromRect(r)
    #endif
#endif


#ifdef DEBUG
    #define SKTMLog(...) NSLog(__VA_ARGS__)
    #define SKTMMethodLog() NSLog(@"%s", __func__)
#else
    #define SKTMLog(...) /* */
    #define SKTMMethodLog() /* */
#endif


/** Radians to Degrees and vice versa */
#define M_PI_180			0.01745329251994	/* pi/180           */
#define M_180_PI			57.29577951308233	/* 180/pi           */
#define TMX_ROTATION(rotation) ((rotation) * M_PI_180 * -1)

/** gid (globally unique tile index) is an unsigned int (32 bit) value */
//typedef uint32_t TMXGID;

// Bits on the far end of the 32-bit global tile ID are used for tile flags
typedef NS_ENUM(uint32_t, TMXTileFlags) {
    kTileDiagonalFlag		= 0x20000000,
    kTileVerticalFlag		= 0x40000000,
    kTileHorizontalFlag		= 0x80000000,
    kFlippedAll				= (kTileHorizontalFlag | kTileVerticalFlag | kTileDiagonalFlag),
    kFlippedMask			= ~(kFlippedAll),
};

/**
 * The orientation of the map determines how it should be rendered. An
 * Orthogonal map is using rectangular tiles that are aligned on a
 * straight grid. An Isometric map uses diamond shaped tiles that are
 * aligned on an isometric projected grid. A Hexagonal map uses hexagon
 * shaped tiles that fit into each other by shifting every other row.
 */
typedef NS_ENUM(NSUInteger, OrientationStyle) {
    OrientationStyle_Unknown = 0,
    OrientationStyle_Orthogonal,
    OrientationStyle_Isometric,
    OrientationStyle_Staggered,
    OrientationStyle_Hexagonal
};

/**
 * The different formats in which the tile layer data can be stored.
 */
typedef NS_ENUM(NSUInteger, LayerDataFormat) {
    LayerDataFormat_XML         = 0,
    LayerDataFormat_Base64      = 1 << 0,
    LayerDataFormat_Base64Gzip  = 1 << 1,
    LayerDataFormat_Base64Zlib  = 1 << 2,
    LayerDataFormat_CSV         = 1 << 3
};


/**
 * The order in which tiles are rendered on screen.
 * since Tiled 0.10, but only supported for orthogonal maps at the moment
 */
typedef NS_ENUM(NSUInteger, RenderOrder) {
    RenderOrder_RightDown,
    RenderOrder_RightUp,
    RenderOrder_LeftDown,
    RenderOrder_LeftUp
};

/**
 * Which axis is staggered. 
 * Only used by the isometric staggered and hexagonal map renderers.
 */
typedef NS_ENUM(NSUInteger, StaggerAxis) {
    StaggerAxis_StaggerX,
    StaggerAxis_StaggerY
};

/**
 * When staggering, specifies whether the odd or the even rows/columns are
 * shifted half a tile right/down. Only used by the isometric staggered and
 * hexagonal map renderers.
 */
typedef NS_ENUM(NSUInteger, StaggerIndex) {
    StaggerIndex_StaggerOdd  = 0,
    StaggerIndex_StaggerEven = 1
};

typedef NS_ENUM(NSUInteger, ObjectType) {
    ObjectType_Tile = 0,
    ObjectType_Terrain,
    ObjectType_Tileset,
    ObjectType_TileLayer,
    ObjectType_ObjectGroup,
    ObjectType_ObjectGroupNode,
    ObjectType_ImageLayer,
    ObjectType_Map
    
};

typedef NS_ENUM(NSUInteger, ObjectGroupType) {
    ObjectGroupType_Rectangle,
    ObjectGroupType_Ellipse,
    ObjectGroupType_Polygon,
    ObjectGroupType_Polyline,
    ObjectGroupType_Tile
};

/**
 * Objects within an object group can either be drawn top down (sorted
 * by their y-coordinate) or by index (manual stacking order).
 *
 * The default is top down.
 */
typedef NS_ENUM(NSUInteger, DrawOrderType) {
    DrawOrderType_TopDown,
    DrawOrderType_IndexOrder
};



typedef NS_ENUM(int, Origin) {
    BottomLeft,
    BottomCenter
};











#endif /* _TMXTYPES_ */
