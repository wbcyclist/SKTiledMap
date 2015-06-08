//
//  SKTMTileNode.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMTileNode.h"

@implementation SKTMTileNode {
    Origin m_origin;
}

+ (instancetype)nodeWithModel:(TMXTile *)model position:(CGPoint)pos origin:(Origin)origin {
    SKTMTileNode *node = [[[self class] alloc] initWithModel:model position:pos origin:origin];
    return node;
}

- (instancetype)initWithModel:(TMXTile *)model position:(CGPoint)pos origin:(Origin)origin {
    self = [self initWithTexture:model.texture];
    if (self) {
        m_origin = origin;
        self.model = model;
        
        OrientationStyle style = model.tileset.map.orientation;
        if (style == OrientationStyle_Isometric) {
            [self renderISONode:model position:pos];
        } else {
            [self renderNode:model position:pos origin:origin];
        }
        
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
    [self runTileAnimation:self.model];
}

- (void)runTileAnimation:(TMXTile *)tile {
    if (tile.animatedFrames.count < 1) {
        [self removeActionForKey:@"TileAnimation"];
        return;
    }
    
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:tile.animatedFrames.count];
    NSTimeInterval duration = 0;;
    
    for (TMXAnimatedFrame *frameObj in tile.animatedFrames) {
        TMXTile *tmp = [tile.tileset tileAtIndex:frameObj.tileId];
        if (tmp.texture) {
            duration = frameObj.duration * 0.001;
            [frames addObject:tmp.texture];
        }
    }
    
    if (frames.count > 0) {
        SKAction *act = [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:duration resize:NO restore:YES]];
        [self runAction:act withKey:@"TileAnimation"];
    } else {
        [self removeActionForKey:@"TileAnimation"];
    }
}


- (void)renderNode:(TMXTile *)model position:(CGPoint)pos origin:(Origin)origin {
    CGSize imageSize = model.texture.size;
    CGSize objectSize = self.size;
    CGPoint scale = CGPointMake(objectSize.width/imageSize.width, objectSize.height/imageSize.height);
    CGPoint offset = model.tileset.tileOffset;
    CGSize sizeHalf = CGSizeMake(objectSize.width/2.0, objectSize.height/2.0);
    
    CGPoint p = CGPointMake(pos.x + (offset.x*scale.x) + sizeHalf.width,
                            pos.y + (offset.y*scale.y) + sizeHalf.height - objectSize.height);
    
    BOOL flipX = model.flippedHorizontally;
    BOOL flipY = model.flippedVertically;
    BOOL flipDiag = model.flippedAntiDiagonally;
    
    if (origin == BottomCenter) {
        p.x -= sizeHalf.width;
    }
    
    CGFloat zRotation = 0.0;
    if (flipDiag) {
        zRotation = TMX_ROTATION(90);
        flipX = model.flippedVertically;
        flipY = !model.flippedHorizontally;
        
        // Compensate for the swap of image dimensions
        CGFloat halfDiff = sizeHalf.height - sizeHalf.width;
        p.y += halfDiff;
        if (origin != BottomCenter)
            p.x += halfDiff;
    }
    
    self.xScale = scale.x * (flipX ? -1 : 1);
    self.yScale = scale.y * (flipY ? -1 : 1);
    self.zRotation = zRotation;
    
    self.pixelPos = p;
}

- (void)renderISONode:(TMXTile *)model position:(CGPoint)pos {
    
    CGPoint offset = model.tileset.tileOffset;
    pos.x += offset.x;
    pos.y -= offset.y;
    
    BOOL flipX = model.flippedHorizontally;
    BOOL flipY = model.flippedVertically;
    BOOL flipDiag = model.flippedAntiDiagonally;
    
    CGFloat zRotation = 0.0;
    if (flipDiag) {
        zRotation = TMX_ROTATION(90);
        flipX = model.flippedVertically;
        flipY = !model.flippedHorizontally;
        pos.y += self.size.width/2.0;
        pos.x += self.size.height/2.0 - model.tileset.map.tileWidth/2.0;
    } else {
        pos.y += self.size.height/2.0;
    }
    self.xScale *= (flipX ? -1 : 1);
    self.yScale *= (flipY ? -1 : 1);
    self.zRotation = zRotation;
    
    self.position = pos;
}












@end
