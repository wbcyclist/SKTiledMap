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
    Origin m_origin;
}

+ (instancetype)nodeWithModel:(TMXObjectGroupNode *)model position:(CGPoint)pos origin:(Origin)origin {
//    SKTMObjectGroupTile *node = [[self class] spriteNodeWithTexture:model.tile.texture size:model.size];
    SKTMObjectGroupTile *node = [[[self class] alloc] initWithModel:model position:pos origin:origin];
    return node;
}

- (instancetype)initWithModel:(TMXObjectGroupNode *)model position:(CGPoint)pos origin:(Origin)origin {
    self = [self initWithTexture:model.tile.texture color:nil size:model.size];
    if (self) {
        m_origin = origin;
        self.model = model;
        
        OrientationStyle style = model.objectGroup.map.orientation;
        if (style == OrientationStyle_Isometric) {
            [self renderISONode:model position:pos];
        } else {
            [self renderNode:model position:pos origin:origin];
        }
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
//    m_radius = sqrt(pow(self.size.width/2.0, 2) + pow(self.size.height/2.0, 2));
    [self runTileAnimation:self.model.tile];
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



- (void)renderNode:(TMXObjectGroupNode *)model position:(CGPoint)pos origin:(Origin)origin {
    CGSize imageSize = model.tile.texture.size;
    CGSize objectSize = self.size;
    CGPoint scale = CGPointMake(objectSize.width/imageSize.width, objectSize.height/imageSize.height);
    CGPoint offset = model.tile.tileset.tileOffset;
    CGSize sizeHalf = CGSizeMake(objectSize.width/2.0, objectSize.height/2.0);
    
    CGPoint p = CGPointMake(pos.x + (offset.x*scale.x) + sizeHalf.width,
                            pos.y + (offset.y*scale.y) + sizeHalf.height - objectSize.height);
    
    BOOL flipX = model.tile.flippedHorizontally;
    BOOL flipY = model.tile.flippedVertically;
    
    if (origin == BottomCenter) {
        p.x -= sizeHalf.width;
    }
    
    // already scale
//    self.xScale = scale.x * (flipX ? -1 : 1);
//    self.yScale = scale.y * (flipY ? -1 : 1);
    self.xScale = flipX ? -1 : 1;
    self.yScale = flipY ? -1 : 1;
    
    self.pixelPos = p;
}

- (void)renderISONode:(TMXObjectGroupNode *)model position:(CGPoint)pos {
    CGSize imageSize = model.tile.texture.size;
    CGSize objectSize = self.size;
    CGPoint scale = CGPointMake(objectSize.width/imageSize.width, objectSize.height/imageSize.height);
    CGPoint offset = model.tile.tileset.tileOffset;
    
    pos.x += (offset.x*scale.x);
    pos.y -= (offset.y*scale.y);
    
    BOOL flipX = model.tile.flippedHorizontally;
    BOOL flipY = model.tile.flippedVertically;
    self.xScale = flipX ? -1 : 1;
    self.yScale = flipY ? -1 : 1;
    
    pos.y += self.size.height/2.0;
    
    self.position = pos;
    [self updateTileRotation:TMX_ROTATION(model.rotation)]; //FIXME: not perfect, some position offset.
}







@end
