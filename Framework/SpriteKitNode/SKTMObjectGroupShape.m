//
//  SKTMObjectGroupShape.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/29.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMObjectGroupShape.h"
#import "SKMapRenderer.h"

@interface SKTMObjectGroupShape ()

@property (nonatomic, weak)SKMapRenderer *renderer;

@end

@implementation SKTMObjectGroupShape

- (ObjectType)nodeType {
    static const ObjectType s_nodeType = ObjectType_ObjectGroupNode;
    return s_nodeType;
}

+ (instancetype)nodeWithModel:(TMXObjectGroupNode *)model renderer:(SKMapRenderer *)renderer {
    return [[self alloc] initWithModel:model renderer:renderer];
}

- (instancetype)initWithModel:(TMXObjectGroupNode *)model renderer:(SKMapRenderer *)renderer {
    self = [super init];
    if (self) {
        self.renderer = renderer;
        self.model = model;
    }
    return self;
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
    CGPathRef pathRef = (__bridge_retained CGPathRef)([self.model getPathRef:self.renderer]);
    if (!pathRef) {
        return;
    }
    self.shape = [SKShapeNode shapeNodeWithPath:pathRef];
    if (self.model.objGroupType != ObjectGroupType_Polyline) {
        self.shape.fillColor = self.model.objectGroup.color;
    }
    self.shape.strokeColor = self.model.objectGroup.color;
//    self.shape.lineWidth = 0;
    [self addChild:self.shape];
    CGPathRelease(pathRef);
}



@end
