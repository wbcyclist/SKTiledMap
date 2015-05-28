//
//  SKTMObjectGroupTile.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/29.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TMXBase.h"

@interface SKTMObjectGroupTile : SKSpriteNode

@property (nonatomic, strong) TMXObjectGroupNode *model;
@property (nonatomic, assign) CGPoint tileOffset;

+ (instancetype)nodeWithModel:(TMXObjectGroupNode *)model;
- (instancetype)initWithModel:(TMXObjectGroupNode *)model;

- (void)updateTileFlippedFlags;
- (void)updateTileRotation:(CGFloat)zRotation;

@end
