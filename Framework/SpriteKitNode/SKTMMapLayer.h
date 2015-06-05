//
//  SKTMMapLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMLayer.h"
#import "SKMapRenderer.h"
#import "OrthogonalRenderer.h"
#import "IsometricRenderer.h"
#import "StaggeredRenderer.h"
#import "HexagonalRenderer.h"

@interface SKTMMapLayer : SKTMLayer

@property (nonatomic, strong) TMXMap *model;
@property (nonatomic, strong) SKMapRenderer *mapRenderer;
@property (nonatomic, assign) CGSize tileSize;  // 一个tile的长宽
@property (nonatomic, assign) CGSize mapSize;   // 地图有多少行多少列

+ (instancetype)tilemapWithContentsOfFile:(NSString*)tmxFile;
- (instancetype)initWithContentsOfFile:(NSString*)tmxFile;


@end
