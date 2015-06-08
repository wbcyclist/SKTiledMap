//
//  SKTMTileLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMTileLayer.h"
#import "SKTMTileNode.h"

@implementation SKTMTileLayer

- (ObjectType)nodeType {
    static const ObjectType s_nodeType = ObjectType_TileLayer;
    return s_nodeType;
}

- (void)setModel:(TMXTileLayer *)model {
    if (_model != model) {
        _model = model;
        self.name = model.name;
        self.hidden = !model.visible;
        self.alpha = model.opacity;
    }
}

- (SKTMTileNode *)tileNodeWithTileCoords:(CGPoint)pos {
    NSString *name = [NSString stringWithFormat:@"%d,%d", (int)pos.x, (int)pos.y];
    return (SKTMTileNode *)[self childNodeWithName:name];
}


@end
