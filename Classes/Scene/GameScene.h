//
//  GameScene.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/4/10.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


#if __IPHONE_OS_VERSION_MIN_REQUIRED
    #ifndef __IPHONE_8_0
        #warning "This project uses features only available in iOS SDK 8.0 and later."
    #endif

#else
    #define NSStringFromCGPoint(x) NSStringFromPoint(NSPointFromCGPoint(x))
    #define NSStringFromCGSize(x) NSStringFromSize(NSSizeFromCGSize(x))
    #define NSStringFromCGRect(x) NSStringFromRect(NSRectFromCGRect(x))
#endif


@interface GameScene : SKScene

@end
