//
//  SKTMTileLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMLayer.h"

@class SKTMTileNode;

@interface SKTMTileLayer : SKTMLayer

@property (nonatomic, strong) TMXTileLayer *model;

- (SKTMTileNode*)tileNodeWithTileCoords:(CGPoint)pos;

@end
