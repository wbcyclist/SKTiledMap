//
//  SKObjectGroupLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKObjectGroupLayer : SKNode

@property (nonatomic, readonly) int minZPosition;
@property (nonatomic, readonly) int maxZPosition;

@end
