//
//  Goblin.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/7.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "Goblin.h"
#import "WBGameUtilities.h"

#define WALK_ACTION_KEY @"walkAction"
#define ANIMATE_TIMEPER 0.05
#define DEFAULT_SPEED 180.0

@implementation Goblin

- (instancetype)initWithDirection:(CharacterDirection)direction {
    [[self class] loadSharedAssets];
    Goblin *tmp = [[self class] new];
    tmp.direction = direction;
    NSArray *texframes = [tmp idleFrames];
    self = [super initWithTexture:texframes.firstObject];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0);
        self.direction = direction;
        self.walkSpeed = DEFAULT_SPEED;
    }
    return self;
}

- (void)setDirection:(CharacterDirection)direction {
    if (_direction != direction) {
        _direction = direction;
        if (direction == CharacterDirection_RightDown
            || direction == CharacterDirection_Right
            || direction == CharacterDirection_RightUp) {
            self.xScale = fabs(self.xScale) * -1.0;
        } else {
            self.xScale = fabs(self.xScale);
        }
        [self removeActionForKey:WALK_ACTION_KEY];
        [self runAction:[SKAction setTexture:[self idleFrames].firstObject]];
    }
}

- (void)setTargetPos:(CGPoint)targetPos {
    if (!CGPointEqualToPoint(targetPos, _targetPos)) {
        _targetPos = targetPos;
        self.direction = [self degreesToDirection:WB_DegreesBetweenPoints(targetPos, self.position)];
        
        NSTimeInterval t = WB_DistanceBetweenPoints(targetPos, self.position) / self.walkSpeed;
        
        SKAction *walkAct = [SKAction group:@[[SKAction moveTo:targetPos duration:t],
                                              [SKAction repeatActionForever:[SKAction animateWithTextures:[self walkFrames]
                                                                                             timePerFrame:(DEFAULT_SPEED/self.walkSpeed) * ANIMATE_TIMEPER]]]];
        
        [self runAction:walkAct withKey:WALK_ACTION_KEY];
    }
}

- (CharacterDirection)degreesToDirection:(CGFloat)degrees {
    if (degrees>=22.5 && degrees<67.5) {
        return CharacterDirection_LeftUp;
    }
    if (degrees>=67.5 && degrees<112.5) {
        return CharacterDirection_Left;
    }
    if (degrees>=112.5 && degrees<157.5) {
        return CharacterDirection_LeftDown;
    }
    if (degrees>=157.5 && degrees<202.5) {
        return CharacterDirection_Down;
    }
    if (degrees>=202.5 && degrees<247.5) {
        return CharacterDirection_RightDown;
    }
    if (degrees>=247.5 && degrees<292.5) {
        return CharacterDirection_Right;
    }
    if (degrees>=292.5 && degrees<337.5) {
        return CharacterDirection_RightUp;
    } else {
        return CharacterDirection_Up;
    }
//    if (degrees>=337.5 || degrees<22.5) {
//        return CharacterDirection_Up;
//    }
}

- (void)setDPadActive:(BOOL)dPadActive {
    if (_dPadActive != dPadActive) {
        _dPadActive = dPadActive;
        if (!dPadActive) {
            self.direction = CharacterDirection_NoDirection;
        }
    }
}




- (CGPoint)walkDistanceWithDirection:(CharacterDirection)direct time:(NSTimeInterval)t {
    CGFloat dis = self.walkSpeed * t;
    CGFloat x = dis*cos(45);
    CGFloat y = dis*sin(45);
    
    switch (self.direction) {
        case CharacterDirection_LeftDown:
            return CGPointMake(-x, -y);
            break;
        case CharacterDirection_RightDown:
            return CGPointMake(x, -y);
            break;
        case CharacterDirection_Left:
            return CGPointMake(-dis, 0);
            break;
        case CharacterDirection_Right:
            return CGPointMake(dis, 0);
            break;
        case CharacterDirection_LeftUp:
            return CGPointMake(-x, y);
            break;
        case CharacterDirection_RightUp:
            return CGPointMake(x, y);
            break;
        case CharacterDirection_Up:
            return CGPointMake(0, dis);
            break;
        case CharacterDirection_Down:
            return CGPointMake(0, -dis);
            break;
        default:
            return CGPointZero;
            break;
    }
}

// 1.0/60.0
#define kMinTimeInterval 0.01666666667
#pragma mark - Game Loop Update
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval {
    
    SKAction *walkAct = [self actionForKey:WALK_ACTION_KEY];
    if (self.dPadActive) {
        if (!walkAct) {
            walkAct = [SKAction repeatActionForever:[SKAction animateWithTextures:[self walkFrames]
                                                                     timePerFrame:(DEFAULT_SPEED/self.walkSpeed) * ANIMATE_TIMEPER]];
            [self runAction:walkAct withKey:WALK_ACTION_KEY];
        }
        CGPoint disp = [self walkDistanceWithDirection:self.direction time:kMinTimeInterval];
        self.position = WB_PointByAddingCGPoints(disp, self.position);
    } else {
        if (self.direction == CharacterDirection_NoDirection) {
            if (walkAct) {
                [self removeActionForKey:WALK_ACTION_KEY];
            }
        } else {
            if (CGPointEqualToPoint(self.targetPos, self.position)) {
                if (walkAct) {
                    [self removeActionForKey:WALK_ACTION_KEY];
                }
            }
        }
    }
    
    
}

- (void)didFinishUpdateInScene {
    
}




#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedIdleFrames = WB_LoadFramesFromAtlas(@"goblin2_idle", @"goblin2_idle_", 5);
        
        sSharedWalkFrames0 = WB_LoadFramesFromAtlas(@"goblin2_run_0", @"goblin2_run_0_", 8);
        sSharedWalkFrames1 = WB_LoadFramesFromAtlas(@"goblin2_run_1", @"goblin2_run_1_", 8);
        sSharedWalkFrames2 = WB_LoadFramesFromAtlas(@"goblin2_run_2", @"goblin2_run_2_", 8);
        sSharedWalkFrames3 = WB_LoadFramesFromAtlas(@"goblin2_run_3", @"goblin2_run_3_", 8);
        sSharedWalkFrames4 = WB_LoadFramesFromAtlas(@"goblin2_run_4", @"goblin2_run_4_", 8);
        
        [sSharedIdleFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((SKTexture *)obj).filteringMode = SKTextureFilteringNearest;
        }];
        [sSharedWalkFrames0 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((SKTexture *)obj).filteringMode = SKTextureFilteringNearest;
        }];
        [sSharedWalkFrames1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((SKTexture *)obj).filteringMode = SKTextureFilteringNearest;
        }];
        [sSharedWalkFrames2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((SKTexture *)obj).filteringMode = SKTextureFilteringNearest;
        }];
        [sSharedWalkFrames3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((SKTexture *)obj).filteringMode = SKTextureFilteringNearest;
        }];
        [sSharedWalkFrames4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((SKTexture *)obj).filteringMode = SKTextureFilteringNearest;
        }];
    });
}


static NSArray *sSharedIdleFrames = nil;
- (NSArray *)idleFrames {
    switch (self.direction) {
        case CharacterDirection_LeftDown:
            return @[sSharedIdleFrames[0]];
            break;
        case CharacterDirection_RightDown:
            return @[sSharedIdleFrames[0]];
            break;
        case CharacterDirection_Left:
            return @[sSharedIdleFrames[1]];
            break;
        case CharacterDirection_Right:
            return @[sSharedIdleFrames[1]];
            break;
        case CharacterDirection_LeftUp:
            return @[sSharedIdleFrames[2]];
            break;
        case CharacterDirection_RightUp:
            return @[sSharedIdleFrames[2]];
            break;
        case CharacterDirection_Up:
            return @[sSharedIdleFrames[3]];
            break;
        case CharacterDirection_Down:
            return @[sSharedIdleFrames[4]];
            break;
        default:
            break;
    }
    return @[sSharedIdleFrames[0]];;
}


static NSArray *sSharedWalkFrames0 = nil;
static NSArray *sSharedWalkFrames1 = nil;
static NSArray *sSharedWalkFrames2 = nil;
static NSArray *sSharedWalkFrames3 = nil;
static NSArray *sSharedWalkFrames4 = nil;
- (NSArray *)walkFrames {
    if (self.direction == CharacterDirection_LeftDown || self.direction == CharacterDirection_RightDown) {
        return sSharedWalkFrames0;
    }
    if (self.direction == CharacterDirection_Left || self.direction == CharacterDirection_Right) {
        return sSharedWalkFrames1;
    }
    if (self.direction == CharacterDirection_LeftUp || self.direction == CharacterDirection_RightUp) {
        return sSharedWalkFrames2;
    }
    if (self.direction == CharacterDirection_Up) {
        return sSharedWalkFrames3;
    }
    if (self.direction == CharacterDirection_Down) {
        return sSharedWalkFrames4;
    }
    return [self idleFrames];
}






@end
