//
//  SKMapLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TMXBase.h"


@class SKTileLayer;
@class SKObjectGroupLayer;
@class SKImageLayer;

@interface SKMapLayer : SKNode

@property (nonatomic, strong) TMXMap *map;

@property (nonatomic, readonly) int minZPosition;
@property (nonatomic, readonly) int maxZPosition;
@property (nonatomic, assign) int zPositionIncrease;


+ (instancetype)tilemapWithContentsOfFile:(NSString*)tmxFile;
- (instancetype)initWithContentsOfFile:(NSString*)tmxFile;


@end
