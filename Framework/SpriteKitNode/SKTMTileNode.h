//
//  SKTMTileNode.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TMXBase.h"

@interface SKTMTileNode : SKSpriteNode

@property (nonatomic, strong) TMXTile *model;
@property (nonatomic, assign)CGPoint pixelPos;

+ (instancetype)nodeWithModel:(TMXTile *)model position:(CGPoint)pos origin:(Origin)origin;
- (instancetype)initWithModel:(TMXTile *)model position:(CGPoint)pos origin:(Origin)origin;


@end
