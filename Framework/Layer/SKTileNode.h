//
//  SKTileNode.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/27.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TMXTile.h"

@interface SKTileNode : SKSpriteNode

@property (nonatomic, strong) TMXTile *tile;


@end
