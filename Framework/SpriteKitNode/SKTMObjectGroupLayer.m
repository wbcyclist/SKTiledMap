//
//  SKTMObjectGroupLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMObjectGroupLayer.h"

@implementation SKTMObjectGroupLayer

- (ObjectType)nodeType {
    static const ObjectType s_nodeType = ObjectType_ObjectGroup;
    return s_nodeType;
}

- (void)setModel:(TMXObjectGroup *)model {
    if (_model != model) {
        _model = model;
        self.name = model.name;
        self.hidden = !model.visible;
        self.alpha = model.opacity;
    }
}






@end
