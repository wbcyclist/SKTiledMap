//
//  ZoomExampleScene.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/11.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "ZoomExampleScene.h"
#import "SKTiledMap.h"
#import "WBGameUtilities.h"
#import "SelectTileNode.h"

CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CGPoint CGPointSubtract(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

@interface ZoomExampleScene ()

#if TARGET_OS_IPHONE
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
#endif
@property (nonatomic, strong) SKTMMapLayer *mapLayer;
@property (nonatomic, strong) SelectTileNode *selectTileNode;

@end

@implementation ZoomExampleScene {
    CGPoint lastMovedPoint;
    CGPoint lastInPoint;
    BOOL m_contentCreated;
}


- (instancetype)initWithSize:(CGSize)size mapFile:(NSString *)filePath {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor grayColor];
        
        self.mapLayer = [[SKTMMapLayer alloc] initWithContentsOfFile:filePath];
        self.backgroundColor = self.mapLayer.model.backgroundColor;
        [self addChild:self.mapLayer];
        
        self.selectTileNode = [[SelectTileNode alloc] initWithMapRenderer:self.mapLayer.mapRenderer];
        self.selectTileNode.zPosition = self.mapLayer.maxZPosition;
        [self.mapLayer addChild:self.selectTileNode];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    if (!m_contentCreated) {
        m_contentCreated = YES;
#if TARGET_OS_IPHONE
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        [view addGestureRecognizer:self.panGestureRecognizer];
        self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoomFrom:)];
        [view addGestureRecognizer:self.pinchGestureRecognizer];
#endif
    }
}


#if TARGET_OS_IPHONE
#pragma mark - Event Handling - iOS
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    [self touchIn:touchPoint];
}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInNode:self];
//    [self touchMoved:touchPoint];
//}
//
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    [self touchEnd:touchPoint];
}
//
//// phone call or back home screen
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInNode:self];
//    [self touchEnd:touchPoint];
//}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat factor = 2;
        translation = CGPointMake(-(int)(translation.x*factor), (int)(translation.y*factor));
        
        self.mapLayer.position = CGPointSubtract(self.mapLayer.position, translation);
        
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (void)handleZoomFrom:(UIPinchGestureRecognizer *)recognizer
{
    CGPoint anchorPoint = [recognizer locationInView:recognizer.view];
    anchorPoint = [self convertPointFromView:anchorPoint];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint anchorPointInMySkNode = [self.mapLayer convertPoint:anchorPoint fromNode:self];
        
        // 将缩放系数转为偶数较少出现拼tile格子时出现的间隙
        float scale = 0.0002;
        int tmp = self.mapLayer.xScale * recognizer.scale * 1000;
        if (tmp > 0) {
            if ((tmp&1) != 0) {
                tmp ++;
            }
            scale = tmp*0.001;
        }
        
        [self.mapLayer setScale:scale];
        
        CGPoint mySkNodeAnchorPointInScene = [self convertPoint:anchorPointInMySkNode fromNode:self.mapLayer];
        CGPoint translationOfAnchorInScene = CGPointSubtract(anchorPoint, mySkNodeAnchorPointInScene);
        
        self.mapLayer.position = CGPointAdd(self.mapLayer.position, translationOfAnchorInScene);
        
        recognizer.scale = 1.0;
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}


#else

#pragma mark - Event Handling - OS X
-(void)mouseDown:(NSEvent *)theEvent {
    CGPoint location = [theEvent locationInNode:self];
    [self touchIn:location];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    CGPoint location = [theEvent locationInNode:self];
    [self touchMoved:location];
}

- (void)mouseUp:(NSEvent *)theEvent {
    CGPoint location = [theEvent locationInNode:self];
    [self touchEnd:location];
}

- (void)keyDown:(NSEvent *)event {
    [self handleKeyEvent:event keyDown:YES];
}

- (void)handleKeyEvent:(NSEvent *)event keyDown:(BOOL)downOrUp {
    // w:13 a:0 s:1 d:2 space:49  ←:123 →:124 ↓:125 ↑:126
    unsigned short keyCode = [event keyCode];
    
    if (keyCode==13 || keyCode==126) {
        self.selectTileNode.tilePoint = CGPointMake(self.selectTileNode.tilePoint.x, self.selectTileNode.tilePoint.y - 1);
    } else if (keyCode==1 || keyCode==125) {
        self.selectTileNode.tilePoint = CGPointMake(self.selectTileNode.tilePoint.x, self.selectTileNode.tilePoint.y + 1);
    } else if (keyCode==0 || keyCode==123) {
        self.selectTileNode.tilePoint = CGPointMake(self.selectTileNode.tilePoint.x - 1, self.selectTileNode.tilePoint.y);
    } else if (keyCode==2 || keyCode==124) {
        self.selectTileNode.tilePoint = CGPointMake(self.selectTileNode.tilePoint.x + 1, self.selectTileNode.tilePoint.y);
    }
}

- (void)scrollWheel:(NSEvent *)theEvent {
    CGFloat deltaY = [theEvent scrollingDeltaY];
    if (deltaY > 0) {
        [self.mapLayer setScale:self.mapLayer.xScale + 0.02];
    } else {
        [self.mapLayer setScale:self.mapLayer.xScale - 0.02];
    }
}

#endif


- (void)touchIn:(CGPoint)point {
    lastMovedPoint = point;
    lastInPoint = point;
}

- (void)touchMoved:(CGPoint)point {
    CGFloat dx = (lastMovedPoint.x - point.x) * 1.;
    CGFloat dy = (lastMovedPoint.y - point.y) * 1.;
    lastMovedPoint = point;
    
    self.mapLayer.position = CGPointMake(self.mapLayer.position.x - dx, self.mapLayer.position.y - dy);
}

- (void)touchEnd:(CGPoint)point {
    int dx = fabs(lastInPoint.x - point.x);
    int dy = fabs(lastInPoint.y - point.y);
    int offset = 10; //移动位置的偏差
    if (dx < offset && dy < offset) {
        point = [self.mapLayer convertPoint:point fromNode:self];
        point = [self.mapLayer.mapRenderer screenToTileCoords:point];
        self.selectTileNode.tilePoint = point;
    }
}



@end
