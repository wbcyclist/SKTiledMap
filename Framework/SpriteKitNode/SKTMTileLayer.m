//
//  SKTMTileLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMTileLayer.h"

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


@end
