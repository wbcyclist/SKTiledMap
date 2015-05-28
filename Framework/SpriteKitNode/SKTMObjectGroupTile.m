//
//  SKTMObjectGroupTile.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/29.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMObjectGroupTile.h"

@implementation SKTMObjectGroupTile {
    CGFloat m_radius;
}

+ (instancetype)nodeWithModel:(TMXObjectGroupNode *)model {
    SKTMObjectGroupTile *node = [[self class] spriteNodeWithTexture:model.tile.texture];
    if (node) {
        node.model = model;
    }
    return node;
}

- (instancetype)initWithModel:(TMXObjectGroupNode *)model {
    self = [self initWithTexture:model.tile.texture];
    if (self) {
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
    if (self.texture!=self.model.tile.texture) {
        [self runAction:[SKAction setTexture:self.model.tile.texture resize:YES]];
    }
    self.tileOffset = CGPointMake(self.size.width/2.0, -self.size.height/2.0);
//    m_radius = sqrt(pow(self.size.width/2.0, 2) + pow(self.size.height/2.0, 2));
    [self updateTileFlippedFlags];
}

- (void)updateTileFlippedFlags {
    self.xScale = self.yScale = 1.0;
    
    TMXTile *tile = self.model.tile;
    BOOL flipX = tile.flippedHorizontally;
    BOOL flipY = tile.flippedVertically;
    
    flipX ? self.xScale *= -1 : NO;
    flipY ? self.yScale *= -1 : NO;
}

- (void)updateTileRotation:(CGFloat)zRotation {
    self.zRotation = zRotation;
    CGFloat x1 = self.position.x;
    CGFloat y1 = self.position.y;
    CGFloat x2 = x1 - self.size.width/2.0;
    CGFloat y2 = y1 - self.size.height/2.0;
    CGFloat x = (x1 - x2)*cos(zRotation) - (y1 - y2)*sin(zRotation) + x2;
    CGFloat y = (y1 - y2)*cos(zRotation) + (x1 - x2)*sin(zRotation) + y2;
    self.position = CGPointMake(x, y);
}




@end
