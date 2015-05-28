//
//  SKColor+TMXColorWithHex.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKitBase.h>

@interface SKColor (TMXColorWithHex)

+ (CGFloat) tmxColorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

+ (SKColor*)tmxColorWithHex:(NSString *)hexString;

- (NSString *)hexString;

@end
