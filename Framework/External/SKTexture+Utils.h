//
//  SKTexture+Utils.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/22.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTexture (Utils)

+ (instancetype)textureWithNodeRect:(CGRect)rect inTexture:(SKTexture *)texture;

@end
