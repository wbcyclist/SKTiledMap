//
//  GameScene.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/4/10.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


#if TARGET_OS_IPHONE
    #import "WBGamePad.h"
#else
    #define NSStringFromCGPoint(x) NSStringFromPoint(NSPointFromCGPoint(x))
    #define NSStringFromCGSize(x) NSStringFromSize(NSSizeFromCGSize(x))
    #define NSStringFromCGRect(x) NSStringFromRect(NSRectFromCGRect(x))
#endif


@interface GameScene : SKScene
#if TARGET_OS_IPHONE
<WBGamePadDelegate>
#endif

#if TARGET_OS_IPHONE
@property (nonatomic, weak)WBGamePad *gamePad;
#endif



@end
