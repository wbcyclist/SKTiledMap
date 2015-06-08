//
//  SKTMObjectGroupLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMLayer.h"

@class SKTMObjectGroupShape, SKTMObjectGroupTile;

@interface SKTMObjectGroupLayer : SKTMLayer

@property (nonatomic, strong) TMXObjectGroup *model;


- (SKTMObjectGroupShape *)shapeWithName:(NSString *)name;
- (SKTMObjectGroupTile *)tileWithName:(NSString *)name;

@end
