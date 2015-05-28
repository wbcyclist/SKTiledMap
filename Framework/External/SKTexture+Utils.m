//
//  SKTexture+Utils.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/22.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTexture+Utils.h"

@implementation SKTexture (Utils)

+ (instancetype)textureWithNodeRect:(CGRect)rect inTexture:(SKTexture *)texture {
    
    CGFloat unitX = rect.origin.x / texture.size.width;
    CGFloat unitY = rect.origin.y / texture.size.height;
    CGFloat unitW = rect.size.width / texture.size.width;
    CGFloat unitH = rect.size.height / texture.size.height;
    
    // IMPORTANT: textureWithRect: uses 1 as 100% of the sprite.
    SKTexture* cutter = [SKTexture textureWithRect:CGRectMake(unitX, unitY, unitW, unitH) inTexture:texture];
    return cutter;
}

@end
