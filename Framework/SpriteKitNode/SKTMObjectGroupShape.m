//
//  SKTMObjectGroupShape.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/29.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMObjectGroupShape.h"

@implementation SKTMObjectGroupShape

- (ObjectType)nodeType {
    static const ObjectType s_nodeType = ObjectType_ObjectGroupNode;
    return s_nodeType;
}

- (void)setModel:(TMXObjectGroupNode *)model {
    if (_model != model) {
        _model = model;
        self.name = model.name;
        self.hidden = !model.visible;
        [self setupModel];
    }
}

- (void)setupModel {
    [self removeAllChildren];
    self.shape = nil;
    
    if (!self.model) return;
    
    if (self.model.objGroupType == ObjectGroupType_Tile) {
        return;
    } else {
        [self createShape];
    }
}

- (void)createShape {
    if (![self.model isShowShape]) {
        return;
    }
    CGPathRef pathRef = (__bridge_retained CGPathRef)([self.model getPathRef]);
    if (!pathRef) {
        return;
    }
    self.shape = [SKShapeNode shapeNodeWithPath:pathRef];
    if (self.model.objGroupType != ObjectGroupType_Polyline) {
        self.shape.fillColor = self.model.objectGroup.color;
    }
    self.shape.strokeColor = self.model.objectGroup.color;
    [self addChild:self.shape];
    CGPathRelease(pathRef);
}



@end
