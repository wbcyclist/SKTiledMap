//
//  TMXTileLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"

@class TMXMap;

@interface TMXTileLayer : TMXObject

@property (nonatomic, weak) TMXMap *map;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) float opacity;
@property (nonatomic, assign) BOOL visible;

@property (nonatomic, assign) uint32_t *tiles;


@end
