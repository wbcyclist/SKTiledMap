//
//  GameScene.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/4/10.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "GameScene.h"
#import "SKTiledMap.h"
#import "Goblin.h"
#import "WBGameUtilities.h"


typedef struct{
    int left;
    int right;
    int top;
    int bottom;
} kMinPlayerToEdgeDistance;


@interface GameScene ()

@property (nonatomic, strong)SKNode *worldNode;
@property (nonatomic, strong) SKTMMapLayer *mapLayer;
@property (nonatomic, strong) Goblin *player;
@property (nonatomic, assign)kMinPlayerToEdgeDistance worldMovedDistance;

@end


@implementation GameScene {
    BOOL m_contentCreated;
    NSTimeInterval lastUpdateTimeInterval;
}


- (instancetype)initWithSize:(CGSize)size {
    NSLog(@"GameScene initWithSize = %@", NSStringFromCGSize(size));
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor grayColor];
        
        _worldMovedDistance.left = 200.0/1120 * size.width;
        _worldMovedDistance.right = 200.0/1120 * size.width;
        _worldMovedDistance.top = 200.0/640 * size.height;
        _worldMovedDistance.bottom = 200.0/640 * size.height;
        
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    if (!m_contentCreated) {
        m_contentCreated = YES;
        
        //world node
        self.worldNode = [SKNode node];
        self.worldNode.name = @"world";
        [self addChild:self.worldNode];
        
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Orthogonal/01.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Orthogonal/02.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Orthogonal/03.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Orthogonal/04.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Orthogonal/05.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Orthogonal/06.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Orthogonal/07.tmx"];
//
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Isometric/01.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Isometric/02.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Isometric/03.tmx"];
//
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Staggered/01.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Staggered/02.tmx"];
        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Staggered/03.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Staggered/04.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Staggered/05.tmx"];
        
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Hexagonal/01.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Hexagonal/02.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Hexagonal/03.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Hexagonal/04.tmx"];
//        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:@"TiledMap/Hexagonal/05.tmx"];
        
        self.backgroundColor = self.mapLayer.model.backgroundColor;
        [self.worldNode addChild:self.mapLayer];
        
        
//        Goblin *player = [Goblin spriteNodeWithTexture:animateFrames[0]];
//        [player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:animateFrames timePerFrame:0.05]]];
        self.player = [[Goblin alloc] initWithDirection:CharacterDirection_NoDirection];
        self.player.zPosition = self.mapLayer.maxZPosition;
        self.player.anchorPoint = CGPointMake(0.5, 0.2);
        self.player.position = CGPointMake(self.mapLayer.mapRenderer.mapPixelSize.width/2, self.mapLayer.mapRenderer.mapPixelSize.height/2);
        [self.worldNode addChild:self.player];
        
    }
}


- (CGFloat)tileGlobalZPositionAtTileCoords:(CGPoint)pos withLayerName:(NSString*)name {
    SKTMTileNode *tileNode = [[self.mapLayer tileLayerWithName:name] tileNodeWithTileCoords:pos];
    return [tileNode getGlobalZPosition];
}
- (CGFloat)tileGlobalZPositionAtTileCoords:(CGPoint)pos withLayerIndex:(NSUInteger)index {
    SKTMTileNode *tileNode = [[self.mapLayer tileLayerAtIndex:index] tileNodeWithTileCoords:pos];
    return [tileNode getGlobalZPosition];
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
#endif

CGPoint lastMovedPoint;
- (void)touchIn:(CGPoint)point {
    lastMovedPoint = point;
    self.player.targetPos = point;
    
    CGPoint testPoint = [self.mapLayer convertPoint:point fromNode:self.worldNode];
    NSLog(@"%@", NSStringFromCGPoint([self.mapLayer.mapRenderer screenToTileCoords:testPoint]));
}

- (void)touchMoved:(CGPoint)point {
    lastMovedPoint = point;
    
//    self.player.targetPos = point;
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










@end
