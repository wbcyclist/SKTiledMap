//
//  SKMapRenderer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class SKTMTileLayer, SKTMObjectGroupLayer, SKTMImageLayer, TMXTileLayer, TMXObjectGroup, TMXImageLayer;


@interface SKMapRenderer : NSObject

@property (nonatomic, assign) uint32_t tileWidth;
@property (nonatomic, assign) uint32_t tileHeight;
@property (nonatomic, assign) uint32_t mapWidth;
@property (nonatomic, assign) uint32_t mapHeight;
@property (nonatomic, assign) CGSize mapPixelSize;

- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer*)layerData;
- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData;
- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer*)layerData;


#pragma mark - Coordinates System Convert 
// 注意 int单位的tileCoord 与 其他Coords的float转换
/**
 * Returns the tile coordinates matching the given pixel position.
 *
 * 返回像素位置在地图中哪个tile格子
 */
- (CGPoint)pixelToTileCoords:(CGPoint)pos;

/**
 * Returns the SpriteKit Coordinates matching the given pixel position.
 *
 * 返回像素位置在SpriteKit系统坐标中的位置
 */
- (CGPoint)pixelToScreenCoords:(CGPoint)pos;

/**
 * Returns the pixel coordinates matching the given tile coordinates.
 *
 * 返回tile格子在地图中的像素位置
 */
- (CGPoint)tileToPixelCoords:(CGPoint)pos;

/**
 * Returns the SpriteKit Coordinates position matching the given tile coordinates.
 *
 * 返回tile格子在SpriteKit系统坐标中的位置
 */
- (CGPoint)tileToScreenCoords:(CGPoint)pos;

/**
 * Returns the tile coordinates matching the given screen position.
 *
 * 返回SpriteKit系统坐标 在 地图中哪个tile格子
 */
- (CGPoint)screenToTileCoords:(CGPoint)pos;

/**
 * Returns the pixel position matching the given screen position.
 *
 * 返回SpriteKit系统坐标 在 地图中的像素位置
 */
- (CGPoint)screenToPixelCoords:(CGPoint)pos;


//- (CGFloat)pixelLengthToScreen:(CGFloat)length;




- (void)updateMapPixelSize;

@end
