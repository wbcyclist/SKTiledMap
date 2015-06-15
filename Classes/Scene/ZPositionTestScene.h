//
//  ZPositionTestScene.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/15.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#if TARGET_OS_IPHONE
    #import "WBGamePad.h"
#else

#endif

@interface ZPositionTestScene : SKScene
#if TARGET_OS_IPHONE
<WBGamePadDelegate>
#endif

#if TARGET_OS_IPHONE
@property (nonatomic, weak)WBGamePad *gamePad;
#endif


- (instancetype)initWithSize:(CGSize)size mapFile:(NSString *)filePath;


@end
