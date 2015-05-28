//
//  SKTMImageLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMLayer.h"

@interface SKTMImageLayer : SKTMLayer

@property (nonatomic, strong) TMXImageLayer *model;
@property (nonatomic, strong) SKSpriteNode *sprite;

@end
