//
//  SKMapRenderer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMXBase.h"
#import "SKTMBase.h"


@interface SKMapRenderer : NSObject

- (SKTMTileLayer *)drawTileLayer:(TMXTileLayer*)layerData;
- (SKTMObjectGroupLayer *)drawObjectGroupLayer:(TMXObjectGroup *)layerData;
- (SKTMImageLayer *)drawImageLayer:(TMXImageLayer*)layerData;

- (CGPoint)tileToScreenCoords:(CGPoint)tPoint withMapSize:(CGSize)mapSize;


@end
