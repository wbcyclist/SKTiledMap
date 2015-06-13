//
//  SKMapRenderer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class SKTMTileLayer, SKTMObjectGroupLayer, SKTMImageLayer, TMXMap, TMXTileLayer, TMXObjectGroup, TMXImageLayer;


@interface SKMapRenderer : NSObject

@property (nonatomic, weak) TMXMap *map;

@property (nonatomic, assign) int tileWidth;
@property (nonatomic, assign) int tileHeight;
@property (nonatomic, assign) int mapWidth;
@property (nonatomic, assign) int mapHeight;
@property (nonatomic, assign) CGSize mapPixelSize;

@property (nonatomic, assign) int *tileZPositions;

- (void)setupTileZPosition;

- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer*)layerData;
- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData;
- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer*)layerData;


/// 返回tile格子的Z值
- (int)zPositionInTileCoords:(CGPoint)pos;

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




- (void)updateRenderParams;

@end
