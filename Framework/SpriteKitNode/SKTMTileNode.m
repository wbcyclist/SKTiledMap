//
//  SKTMTileNode.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMTileNode.h"

@implementation SKTMTileNode

+ (instancetype)nodeWithModel:(TMXTile *)model {
    SKTMTileNode *node = [[self class] spriteNodeWithTexture:model.texture];
    if (node) {
        node.model = model;
    }
    return node;
}

- (instancetype)initWithModel:(TMXTile *)model {
    self = [self initWithTexture:model.texture];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)setModel:(TMXTile *)model {
    if (_model != model) {
        _model = model;
        [self setupModel];
    }
}

- (void)setupModel {
//    self.texture = self.model.texture;    // not work
    if (self.texture!=self.model.texture) {
        [self runAction:[SKAction setTexture:self.model.texture resize:YES]];
    }
    self.tileOffset = CGPointMake(self.size.width/2.0, -self.size.height/2.0);
    [self updateTileFlippedFlags];
}

- (void)updateTileFlippedFlags {
    self.zRotation = 0.0;
    self.xScale = self.yScale = 1.0;
    
    BOOL flipX = self.model.flippedHorizontally;
    BOOL flipY = self.model.flippedVertically;
    BOOL flipDiag = self.model.flippedAntiDiagonally;
    
    CGFloat zRotation = 0.0;
    if (flipDiag) {
        zRotation = TMX_ROTATION(90);
        flipX = self.model.flippedVertically;
        flipY = !self.model.flippedHorizontally;
    }
    flipX ? self.xScale *= -1 : NO;
    flipY ? self.yScale *= -1 : NO;
    self.zRotation = zRotation;
}



@end
