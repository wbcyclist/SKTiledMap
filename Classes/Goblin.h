//
//  Goblin.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/7.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(int, CharacterDirection) {
    CharacterDirection_NoDirection = 0,
    CharacterDirection_Up,
    CharacterDirection_Down,
    CharacterDirection_Right,
    CharacterDirection_Left,
    CharacterDirection_RightUp,
    CharacterDirection_LeftUp,
    CharacterDirection_RightDown,
    CharacterDirection_LeftDown,
};


@interface Goblin : SKSpriteNode

@property (nonatomic, assign) CharacterDirection direction;
@property (nonatomic, assign) CGPoint targetPos;
@property (nonatomic, assign) CGFloat walkSpeed;
@property (nonatomic, assign) BOOL dPadActive;


- (instancetype)initWithDirection:(CharacterDirection)direction;


#pragma mark - Game Loop Update
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;
- (void)didFinishUpdateInScene;






@end
