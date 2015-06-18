//
//  SKTMMapLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMLayer.h"
#import "SKTMTileLayer.h"
#import "SKTMObjectGroupLayer.h"
#import "SKTMImageLayer.h"

@class SKMapRenderer;

@interface SKTMMapLayer : SKTMLayer

@property (nonatomic, strong) TMXMap *model;
@property (nonatomic, strong) SKMapRenderer *mapRenderer;
@property (nonatomic, assign) CGSize tileSize;  // 一个tile的长宽
@property (nonatomic, assign) CGSize mapSize;   // 地图有多少行多少列

+ (instancetype)tilemapWithContentsOfFile:(NSString*)tmxFile;
- (instancetype)initWithContentsOfFile:(NSString*)tmxFile;


- (SKTMLayer *)allLayerWithName:(NSString *)name;
- (SKTMLayer *)allLayerAtIndex:(NSUInteger)index;

- (SKTMTileLayer *)tileLayerWithName:(NSString *)name;
- (SKTMTileLayer *)tileLayerAtIndex:(NSUInteger)index;

- (SKTMObjectGroupLayer *)objectLayerWithName:(NSString *)name;
- (SKTMObjectGroupLayer *)objectLayerAtIndex:(NSUInteger)index;

- (SKTMImageLayer *)imageLayerWithName:(NSString *)name;
- (SKTMImageLayer *)imageLayerAtIndex:(NSUInteger)index;




@end
