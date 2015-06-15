//
//  ZPositionTestScene.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/4/10.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "ZPositionTestScene.h"
#import "SKTiledMap.h"
#import "Goblin.h"
#import "WBGameUtilities.h"


typedef struct{
    int left;
    int right;
    int top;
    int bottom;
} kMinPlayerToEdgeDistance;


@interface ZPositionTestScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong)SKNode *worldNode;
@property (nonatomic, strong) SKTMMapLayer *mapLayer;
@property (nonatomic, strong) Goblin *player;
@property (nonatomic, assign)kMinPlayerToEdgeDistance worldMovedDistance;

@property (nonatomic, weak) SKTMObjectGroupLayer *overlapLayer;
@property (nonatomic, strong) NSMutableArray *overlapRects;
@property (nonatomic, assign) int overlapZPosition;

@end


@implementation ZPositionTestScene {
    BOOL m_leftKey;
    BOOL m_rightKey;
    BOOL m_upKey;
    BOOL m_downKey;
    BOOL m_contentCreated;
    NSTimeInterval lastUpdateTimeInterval;
    CGPoint lastMovedPoint;
}


- (instancetype)initWithSize:(CGSize)size mapFile:(NSString *)filePath {
    NSLog(@"ZPositionTestScene initWithSize = %@", NSStringFromCGSize(size));
    if (self = [self initWithSize:size]) {
        self.backgroundColor = [SKColor grayColor];
        
        // camera range
        _worldMovedDistance.left = 200.0/1120 * size.width;
        _worldMovedDistance.right = 200.0/1120 * size.width;
        _worldMovedDistance.top = 200.0/640 * size.height;
        _worldMovedDistance.bottom = 200.0/640 * size.height;
        
        //physics
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        //world node
        self.worldNode = [SKNode node];
        self.worldNode.name = @"world";
        [self addChild:self.worldNode];
        
        // load map layer
        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:filePath];
        self.backgroundColor = self.mapLayer.model.backgroundColor;
        [self.worldNode addChild:self.mapLayer];
        
        // overlap
        self.overlapLayer = [self.mapLayer objectLayerWithName:@"overlap"];
        [self syncOverlapRects:self.overlapLayer];
        int zpos = [self.overlapLayer globalZPosition];
        
        // player
        SKTMObjectGroupLayer *characLayer = [self.mapLayer objectLayerWithName:@"Character"];
        SKNode *objNode = [characLayer childNodeWithName:@"player"];
        self.player = [[Goblin alloc] initWithDirection:CharacterDirection_NoDirection];
        self.player.position = objNode.position;
        [characLayer addChild:self.player];
        
        // overlapZPosition
        [self.player setupGlobalZPosition:zpos];
        self.overlapZPosition = self.player.zPosition;
        self.player.zPosition = 0;
    }
    
    return self;
}

- (void)didChangeSize:(CGSize)oldSize {
    if (CGSizeEqualToSize(oldSize, self.size)) {
        return;
    }
    _worldMovedDistance.left = 200.0/1120 * self.size.width;
    _worldMovedDistance.right = 200.0/1120 * self.size.width;
    _worldMovedDistance.top = 200.0/640 * self.size.height;
    _worldMovedDistance.bottom = 200.0/640 * self.size.height;
}

- (NSMutableArray *)overlapRects {
    if (!_overlapRects) {
        _overlapRects = [NSMutableArray array];
    }
    return _overlapRects;
}

- (void)syncOverlapRects:(SKTMObjectGroupLayer *)overlapLayer {
    [self.overlapRects removeAllObjects];
    for (SKNode *node in overlapLayer.children) {
        CGRect rect = node.calculateAccumulatedFrame;
        [self.overlapRects addObject:WB_CGRectToNSValue(rect)];
    }
}

-(void)didMoveToView:(SKView *)view {
    if (!m_contentCreated) {
        m_contentCreated = YES;
        
        [self setupPhysicsBody];
    }
}

- (void)setupPhysicsBody {
    SKTMObjectGroupLayer *blockLayer = [self.mapLayer objectLayerWithName:@"block"];
    for (SKNode *node in blockLayer.children) {
        if ([node isKindOfClass:[SKTMObjectGroupShape class]]) {
            SKTMObjectGroupShape *shapeNode = (SKTMObjectGroupShape *)node;
            shapeNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:shapeNode.path];
            shapeNode.physicsBody.dynamic = NO;
            shapeNode.physicsBody.restitution = 0;
        }
    }
}



- (CGFloat)tileGlobalZPositionAtTileCoords:(CGPoint)pos withLayerName:(NSString*)name {
    SKTMTileNode *tileNode = [[self.mapLayer tileLayerWithName:name] tileNodeWithTileCoords:pos];
    return [tileNode globalZPosition];
}
- (CGFloat)tileGlobalZPositionAtTileCoords:(CGPoint)pos withLayerIndex:(NSUInteger)index {
    SKTMTileNode *tileNode = [[self.mapLayer tileLayerAtIndex:index] tileNodeWithTileCoords:pos];
    return [tileNode globalZPosition];
}

- (CGPoint)screenToTileCoords:(CGPoint)pos {
    //    pos = [self.mapLayer convertPoint:pos fromNode:self.worldNode];
    return [self.mapLayer.mapRenderer screenToTileCoords:pos];
}

#if TARGET_OS_IPHONE
#pragma mark - Event Handling - iOS
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.worldNode];
    [self touchIn:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.worldNode];
    [self touchMoved:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    [self touchEnd:touchPoint];
}

// phone call or back home screen
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.worldNode];
    [self touchEnd:touchPoint];
}




- (void)setGamePad:(WBGamePad *)gamePad {
    _gamePad = gamePad;
    _gamePad.delegate = self;
}

#pragma mark - WBGamePadDelegate
- (void)gamePadDPadDidActive:(BOOL)active {
    self.player.dPadActive = active;
}

- (void)gamePadDPadDidUpdateDirection:(WBGamepadDirection)direction {
    if (self.player.dPadActive) {
        self.player.direction = (CharacterDirection)direction;
    }
}

- (void)gamePadButtonDidPressed:(BOOL)isPressed withId:(int)buttonId {
}

#else

#pragma mark - Event Handling - OS X
-(void)mouseDown:(NSEvent *)theEvent {
    CGPoint location = [theEvent locationInNode:self.worldNode];
    [self touchIn:location];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    CGPoint location = [theEvent locationInNode:self.worldNode];
    [self touchMoved:location];
}

- (void)mouseUp:(NSEvent *)theEvent {
    CGPoint location = [theEvent locationInNode:self.worldNode];
    [self touchEnd:location];
}

- (void)keyDown:(NSEvent *)event {
    [self handleKeyEvent:event keyDown:YES];
}

- (void)keyUp:(NSEvent *)event {
    [self handleKeyEvent:event keyDown:NO];
}

- (void)handleKeyEvent:(NSEvent *)event keyDown:(BOOL)downOrUp {
    // w:13 a:0 s:1 d:2 space:49  ←:123 →:124 ↓:125 ↑:126
    unsigned short keyCode = [event keyCode];
    
    if (keyCode==13 || keyCode==126) {
        m_upKey = downOrUp;
    } else if (keyCode==1 || keyCode==125) {
        m_downKey = downOrUp;
    } else if (keyCode==0 || keyCode==123) {
        m_leftKey = downOrUp;
    } else if (keyCode==2 || keyCode==124) {
        m_rightKey = downOrUp;
    }
    [self checkPlayerDirection:self.player];
}

- (void)checkPlayerDirection:(Goblin *)player {
    if (m_upKey) {
        if (m_leftKey) {
            player.direction = CharacterDirection_LeftUp;
        } else if (m_rightKey) {
            player.direction = CharacterDirection_RightUp;
        } else {
            player.direction = CharacterDirection_Up;
        }
    } else if (m_downKey) {
        if (m_leftKey) {
            player.direction = CharacterDirection_LeftDown;
        } else if (m_rightKey) {
            player.direction = CharacterDirection_RightDown;
        } else {
            player.direction = CharacterDirection_Down;
        }
    } else if (m_leftKey) {
        player.direction = CharacterDirection_Left;
    } else if (m_rightKey) {
        player.direction = CharacterDirection_Right;
    }
    self.player.dPadActive = m_upKey || m_downKey || m_leftKey || m_rightKey;
}

#endif

- (void)touchIn:(CGPoint)point {
    lastMovedPoint = point;
    self.player.targetPos = point;
}

- (void)touchMoved:(CGPoint)point {
    lastMovedPoint = point;
    
    self.player.targetPos = point;
    //    CGFloat dx = (lastMovedPoint.x - point.x) * 1.;
    //    CGFloat dy = (lastMovedPoint.y - point.y) * 1.;
    //    self.mapLayer.position = CGPointMake(self.mapLayer.position.x - dx, self.mapLayer.position.y - dy);
}

- (void)touchEnd:(CGPoint)point {
    
}


#pragma mark - Game Loop
// 1.0/60.0
#define kMinTimeInterval 0.01666666667
- (void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered */
    NSTimeInterval timeSinceLast = currentTime - lastUpdateTimeInterval;
    lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = kMinTimeInterval;
        lastUpdateTimeInterval = currentTime;
    }
    
    [self.player updateWithTimeSinceLastUpdate:currentTime];
    
    // check player zposition
    [self checkCharacterZPosition:self.player];
}


- (void)checkCharacterZPosition:(SKNode *)charac {
    CGPoint overlapPoint = [charac.parent convertPoint:charac.position toNode:self.overlapLayer];
    
    for (NSValue *value in self.overlapRects) {
        if (CGRectContainsPoint(WB_NSValueToCGRect(value), overlapPoint)) {
            charac.zPosition = self.overlapZPosition;
            return;
        }
    }
    
    charac.zPosition = 0;
}

- (void)didSimulatePhysics {
    
}

- (void)didFinishUpdate {
    [self.player didFinishUpdateInScene];
    
    // camera update
    [self updateWorldMoved:self.player.position];
}

- (void)updateWorldMoved:(CGPoint)targetPos{
    CGPoint worldPos = self.worldNode.position;
    
    //left && right
    CGFloat xCoordinate = worldPos.x + targetPos.x;
    if (xCoordinate < self.worldMovedDistance.left) {
        worldPos.x = worldPos.x - xCoordinate + self.worldMovedDistance.left;
    } else if (xCoordinate > (self.frame.size.width - self.worldMovedDistance.right)) {
        worldPos.x = worldPos.x + (self.frame.size.width - xCoordinate) - self.worldMovedDistance.right;
    }
    
    //bottom && top
    CGFloat yCoordinate = worldPos.y + targetPos.y;
    if (yCoordinate < self.worldMovedDistance.bottom) {
        worldPos.y = worldPos.y - yCoordinate + self.worldMovedDistance.bottom;
    } else if (yCoordinate > (self.frame.size.height - self.worldMovedDistance.top)) {
        worldPos.y = worldPos.y + (self.frame.size.height - yCoordinate) - self.worldMovedDistance.top;
    }
    
    self.worldNode.position = worldPos;
}



#pragma mark - SKPhysicsContactDelegate
- (void)didContactWall:(SKPhysicsBody *)body andContact:(SKPhysicsContact *)contact {
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
}






@end
