//
//  SKTMImageLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMImageLayer.h"

@implementation SKTMImageLayer

- (ObjectType)nodeType {
    static const ObjectType s_nodeType = ObjectType_ImageLayer;
    return s_nodeType;
}

- (void)setModel:(TMXImageLayer *)model {
    if (_model != model) {
        _model = model;
        self.name = model.name;
        self.hidden = !model.visible;
        self.alpha = model.opacity;
        [self createImageSprite];
    }
}

- (void)createImageSprite {
    [self removeAllChildren];
    self.sprite = nil;
    self.sprite = [SKSpriteNode spriteNodeWithTexture:self.model.texture];
    self.sprite.position = CGPointMake(self.sprite.size.width/2.0, -self.sprite.size.height/2.0);
    [self addChild:self.sprite];
}




@end
