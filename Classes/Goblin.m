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

@interface Goblin ()
@property (nonatomic, assign) CGVector autoWalkVec;

@end

@implementation Goblin {
    BOOL m_autoWalking;
}

- (instancetype)initWithDirection:(CharacterDirection)direction {
    [[self class] loadSharedAssets];
    Goblin *tmp = [[self class] new];
    tmp.direction = direction;
    NSArray *texframes = [tmp idleFrames];
    self = [super initWithTexture:texframes.firstObject];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.2);
        self.direction = direction;
        self.walkSpeed = DEFAULT_SPEED;
        [self initPhysicsBody];
    }
    return self;
}

- (void)initPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/6 center:CGPointMake(0, 10)];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = 0;
    self.physicsBody.friction = 1;
    self.physicsBody.linearDamping = 1;
    self.physicsBody.affectedByGravity = NO;
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
    }
}

- (void)setTargetPos:(CGPoint)targetPos {
    
    if (!CGPointEqualToPoint(targetPos, _targetPos)) {
        _targetPos = targetPos;
        if (self.dPadActive) {
            return;
        }
        m_autoWalking = YES;
        self.direction = [self faceToPostion:targetPos];
        self.autoWalkVec = [self autoWalkVec:targetPos];
        self.physicsBody.velocity = self.autoWalkVec;
    }
}

- (CGVector)autoWalkVec:(CGPoint)targetPos {
    CGFloat ang = WB_RadiansBetweenPoints(self.position, targetPos);
    CGFloat x = self.walkSpeed*cos(ang);
    CGFloat y = self.walkSpeed*sin(ang);
    return CGVectorMake(x, y);
}

- (BOOL)isStopAutoWalk {
    if (self.direction==CharacterDirection_Up) {
        return self.position.y >= self.targetPos.y;
    }
    
    if (self.direction==CharacterDirection_RightUp) {
        return self.position.y >= self.targetPos.y || self.position.x >= self.targetPos.x;
    }
    
    if (self.direction==CharacterDirection_Right) {
        return self.position.x >= self.targetPos.x;
    }
    
    if (self.direction==CharacterDirection_RightDown) {
        return self.position.y <= self.targetPos.y || self.position.x >= self.targetPos.x;
    }
    
    if (self.direction==CharacterDirection_Down) {
        return self.position.y <= self.targetPos.y;
    }
    
    if (self.direction==CharacterDirection_LeftDown) {
        return self.position.y <= self.targetPos.y || self.position.x <= self.targetPos.x;
    }
    
    if (self.direction==CharacterDirection_Left) {
        return self.position.x <= self.targetPos.x;
    }
    
    if (self.direction==CharacterDirection_LeftUp) {
        return self.position.y >= self.targetPos.y || self.position.x <= self.targetPos.x;
    }
    
    return YES;
//    return self.direction != [self faceToPostion:self.targetPos];
}

- (CharacterDirection)faceToPostion:(CGPoint)targetPos {
    CGFloat ang = WB_RadiansBetweenPoints(self.position, targetPos);
    if (ang < 0) {
        ang += 2*M_PI;
    }
    static const CGFloat piece1 = M_PI/8.0;
    static const CGFloat piece2 = 3*piece1;
    static const CGFloat piece3 = 5*piece1;
    static const CGFloat piece4 = 7*piece1;
    static const CGFloat piece5 = 9*piece1;
    static const CGFloat piece6 = 11*piece1;
    static const CGFloat piece7 = 13*piece1;
    static const CGFloat piece8 = 15*piece1;
    
    if (ang > piece1 && ang <= piece2) {
        return CharacterDirection_RightUp;
    }
    if (ang > piece2 && ang <= piece3) {
        return CharacterDirection_Up;
    }
    if (ang > piece3 && ang <= piece4) {
        return CharacterDirection_LeftUp;
    }
    if (ang > piece4 && ang <= piece5) {
        return CharacterDirection_Left;
    }
    if (ang > piece5 && ang <= piece6) {
        return CharacterDirection_LeftDown;
    }
    if (ang > piece6 && ang <= piece7) {
        return CharacterDirection_Down;
    }
    if (ang > piece7 && ang <= piece8) {
        return CharacterDirection_RightDown;
    }
    return CharacterDirection_Right;
}

- (void)setDPadActive:(BOOL)dPadActive {
    if (_dPadActive != dPadActive) {
        _dPadActive = dPadActive;
        if (dPadActive) {
             m_autoWalking = NO;
        } else {
            self.physicsBody.velocity = CGVectorMake(0, 0);
        }
    }
}




- (CGPoint)walkDistanceWithDirection:(CharacterDirection)direct time:(NSTimeInterval)t {
    CGFloat dis = self.walkSpeed * t;
    CGFloat x = dis*0.707106769; // cos(M_PI_4);
    CGFloat y = dis*0.707106769; // sin(M_PI_4);
    
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

- (CGVector)velocityWithDirection:(CharacterDirection)direct {
    CGFloat x = self.walkSpeed*0.707106769; // cos(M_PI_4);
    CGFloat y = self.walkSpeed*0.707106769; // sin(M_PI_4);
    
    switch (self.direction) {
        case CharacterDirection_LeftDown:
            return CGVectorMake(-x, -y);
            break;
        case CharacterDirection_RightDown:
            return CGVectorMake(x, -y);
            break;
        case CharacterDirection_Left:
            return CGVectorMake(-self.walkSpeed, 0);
            break;
        case CharacterDirection_Right:
            return CGVectorMake(self.walkSpeed, 0);
            break;
        case CharacterDirection_LeftUp:
            return CGVectorMake(-x, y);
            break;
        case CharacterDirection_RightUp:
            return CGVectorMake(x, y);
            break;
        case CharacterDirection_Up:
            return CGVectorMake(0, self.walkSpeed);
            break;
        case CharacterDirection_Down:
            return CGVectorMake(0, -self.walkSpeed);
            break;
        default:
            return CGVectorMake(0, 0);
            break;
    }
}


// 1.0/60.0
#define kMinTimeInterval 0.01666666667
#pragma mark - Game Loop Update
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval {
    
    if (self.dPadActive) {
        [self runWalkAction];
        self.physicsBody.velocity = [self velocityWithDirection:self.direction];
        
    } else {
        if (!m_autoWalking) {
            [self stopWalkAction];
            return;
        }
        
        if (m_autoWalking) {
            if ([self isStopAutoWalk]) {
                self.physicsBody.velocity = CGVectorMake(0, 0);
                m_autoWalking = NO;
            } else {
                [self runWalkAction];
                self.physicsBody.velocity = self.autoWalkVec;
            }
        }
    }
}


- (void)runWalkAction {
    SKAction *walkAct = [self actionForKey:WALK_ACTION_KEY];
    if (!walkAct) {
        walkAct = [SKAction animateWithTextures:[self walkFrames]
                                   timePerFrame:(DEFAULT_SPEED/self.walkSpeed) * ANIMATE_TIMEPER];
        [self runAction:walkAct withKey:WALK_ACTION_KEY];
    }
}

- (void)stopWalkAction {
    SKAction *walkAct = [self actionForKey:WALK_ACTION_KEY];
    if (walkAct) {
        [self removeActionForKey:WALK_ACTION_KEY];
        [self runAction:[SKAction setTexture:[self idleFrames].firstObject]];
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
