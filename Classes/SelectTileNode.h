//
//  SelectTileNode.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/11.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKTiledMap.h"

@interface SelectTileNode : SKNode
@property (nonatomic, weak) SKMapRenderer *mapRanderer;
@property (nonatomic, assign) CGPoint tilePoint;

- (instancetype)initWithMapRenderer:(SKMapRenderer *)mapranderer;

@end
