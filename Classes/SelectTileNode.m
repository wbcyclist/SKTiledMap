//
//  SelectTileNode.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/11.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SelectTileNode.h"


#define PointToString(p) [NSString stringWithFormat:@"%d, %d", (int)p.x, (int)p.y]

#if TARGET_OS_IPHONE
    #define WBFont UIFont
#else
    #define WBFont NSFont
#endif

@interface SelectTileNode ()
@property (nonatomic, strong) SKShapeNode *shapeNode;
@property (nonatomic, strong) SKLabelNode *tileLabNode;
@property (nonatomic, strong) SKLabelNode *positionLabNode;

@end


@implementation SelectTileNode

- (instancetype)initWithMapRenderer:(SKMapRenderer *)mapranderer {
    if (self = [self init]) {
        self.mapRanderer = mapranderer;
        self.shapeNode = [self createTileShape];
        [self addChild:self.shapeNode];
        
        self.tileLabNode = [SKLabelNode labelNodeWithFontNamed:[WBFont boldSystemFontOfSize:17.0].fontName];
        self.tileLabNode.text = @"0, 0";
        self.tileLabNode.fontSize = [self fontSize:30 fitFont:[WBFont boldSystemFontOfSize:17.0] fitText:@"0, 0" fitWidth:mapranderer.tileWidth];
        
        self.positionLabNode = [SKLabelNode labelNodeWithFontNamed:[WBFont boldSystemFontOfSize:17.0].fontName];
        self.positionLabNode.text = @"0, 0";
        
        self.positionLabNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        self.positionLabNode.fontSize = [self fontSize:30 fitFont:[WBFont boldSystemFontOfSize:17.0] fitText:@"0, 0" fitWidth:mapranderer.tileWidth];
        
        [self addChild:self.tileLabNode];
        [self addChild:self.positionLabNode];
        
        if (self.mapRanderer.map.orientation == OrientationStyle_Isometric) {
            self.tileLabNode.position = CGPointMake(0, 0);
            self.positionLabNode.position = CGPointMake(0, -mapranderer.tileHeight);
        } else {
            self.tileLabNode.position = CGPointMake(mapranderer.tileWidth/2.0, 0);
            self.positionLabNode.position = CGPointMake(mapranderer.tileWidth/2.0, -mapranderer.tileHeight);
        }
        
        self.position = [self.mapRanderer tileToScreenCoords:self.tilePoint];
        self.positionLabNode.text = PointToString(self.position);
    }
    return self;
}

- (float)fontSize:(float)largestFontSize fitFont:(WBFont*)font fitText:(NSString*)text fitWidth:(float)width {
    while ([text sizeWithAttributes:@{NSFontAttributeName:[WBFont fontWithName:font.fontName size:largestFontSize]}].width > width) {
        largestFontSize--;
    }
    return largestFontSize;
}


- (void)setTilePoint:(CGPoint)tilePoint {
    if (!CGPointEqualToPoint(tilePoint, _tilePoint)) {
        _tilePoint = tilePoint;
        self.position = [self.mapRanderer tileToScreenCoords:tilePoint];
        
        self.tileLabNode.text = PointToString(tilePoint);
        self.positionLabNode.text = PointToString(self.position);
    }
}



- (SKShapeNode *)createTileShape {
    SKShapeNode *shapeNode = nil;
    if (self.mapRanderer.map.orientation == OrientationStyle_Isometric) {
        CGRect rect = {0, 0, self.mapRanderer.tileHeight, self.mapRanderer.tileHeight};
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        CGPoint p1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGPoint p2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGPoint p3 = CGPointMake(CGRectGetMaxX(rect), -CGRectGetMaxY(rect));
        CGPoint p4 = CGPointMake(CGRectGetMinX(rect), -CGRectGetMaxY(rect));
        
        p1 = [self.mapRanderer pixelToScreenCoords:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
        p2 = [self.mapRanderer pixelToScreenCoords:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
        p3 = [self.mapRanderer pixelToScreenCoords:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        p4 = [self.mapRanderer pixelToScreenCoords:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
        
        p2.x -=p1.x;
        p3.x -=p1.x;
        p4.x -=p1.x;
        
        p2.y -=p1.y;
        p3.y -=p1.y;
        p4.y -=p1.y;
        
        p1 = CGPointZero;
        
        CGPathMoveToPoint(pathRef, NULL, p1.x, p1.y);
        CGPathAddLineToPoint(pathRef, NULL, p2.x, p2.y);
        CGPathAddLineToPoint(pathRef, NULL, p3.x, p3.y);
        CGPathAddLineToPoint(pathRef, NULL, p4.x, p4.y);
        CGPathCloseSubpath (pathRef);
        
        shapeNode = [SKShapeNode shapeNodeWithPath:pathRef];
        CGPathRelease(pathRef);
    } else {
        shapeNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0, -self.mapRanderer.tileHeight, self.mapRanderer.tileWidth, self.mapRanderer.tileHeight)];
    }
    
    
    
    shapeNode.antialiased = NO;
    shapeNode.fillColor = [[SKColor purpleColor] colorWithAlphaComponent:0.3];
    shapeNode.strokeColor = [SKColor whiteColor];
    return shapeNode;
}
















@end
