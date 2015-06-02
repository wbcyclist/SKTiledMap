//
//  TMXObjectGroupNode.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/24.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObjectGroupNode.h"
#import "TMXTile.h"
#import "TMXObjectGroup.h"
#import "TMXMap.h"
#import "SKMapRenderer.h"


@interface TMXObjectGroupNode ()

@end

@implementation TMXObjectGroupNode

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_ObjectGroupNode;
}

-(void)dealloc {
    
}

- (NSMutableArray *)points {
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (void)createPointsFromString:(NSString*)string {
    [self.points removeAllObjects];
    
    NSArray* pointStrings = [string componentsSeparatedByString:@" "];
    
    for (NSString* pointString in pointStrings) {
#if TARGET_OS_IPHONE
        CGPoint point = CGPointFromString([NSString stringWithFormat:@"{%@}", pointString]);
#else
        CGPoint point = NSPointFromString([NSString stringWithFormat:@"{%@}", pointString]);
#endif
//        point.y *= -1.0f;
        [self.points addObject:SKTM_CGPointToNSValue(point)];
    }
}

- (id)getPathRef:(SKMapRenderer *)renderer {
    CGPathRef resultPath = nil;
    CGRect rect = {CGPointZero, _size};
    
    OrientationStyle style = self.objectGroup.map.orientation;
    
    switch (self.objGroupType) {
        case ObjectGroupType_Rectangle: {
            if (_size.width>0 && _size.height>0) {
                CGMutablePathRef pathRef = CGPathCreateMutable();
                /*
                 CGPathMoveToPoint(pathRef, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
                 CGPathAddLineToPoint(pathRef, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
                 CGPathAddLineToPoint(pathRef, NULL, CGRectGetMaxX(rect), -CGRectGetMaxY(rect));
                 CGPathAddLineToPoint(pathRef, NULL, CGRectGetMinX(rect), -CGRectGetMaxY(rect));
                 */
                
                CGPoint p1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
                CGPoint p2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
                CGPoint p3 = CGPointMake(CGRectGetMaxX(rect), -CGRectGetMaxY(rect));
                CGPoint p4 = CGPointMake(CGRectGetMinX(rect), -CGRectGetMaxY(rect));
                
                if (renderer && style==OrientationStyle_Isometric) {
                    p1 = [renderer pixelToScreenCoords:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
                    p2 = [renderer pixelToScreenCoords:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
                    p3 = [renderer pixelToScreenCoords:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
                    p4 = [renderer pixelToScreenCoords:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
                    
                    p2.x -=p1.x;
                    p3.x -=p1.x;
                    p4.x -=p1.x;
                    
                    p2.y -=p1.y;
                    p3.y -=p1.y;
                    p4.y -=p1.y;
                    
                    p1 = CGPointZero;
                }
                
                CGPathMoveToPoint(pathRef, NULL, p1.x, p1.y);
                CGPathAddLineToPoint(pathRef, NULL, p2.x, p2.y);
                CGPathAddLineToPoint(pathRef, NULL, p3.x, p3.y);
                CGPathAddLineToPoint(pathRef, NULL, p4.x, p4.y);
                CGPathCloseSubpath (pathRef);
                
                resultPath = CGPathCreateCopy(pathRef);
                CGPathRelease(pathRef);
            }
            break;
            
        } case ObjectGroupType_Ellipse: {
            CGAffineTransform transform;
            if (renderer && style==OrientationStyle_Isometric) { //TODO: Not Implemented
                transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(rect)/2.0, -CGRectGetHeight(rect));
            } else {
                transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(rect));
            }
            
            resultPath = CGPathCreateWithEllipseInRect(rect, &transform);
            break;
            
        } case ObjectGroupType_Polygon: {
            if (self.points.count>0) {
                CGMutablePathRef pathRef = CGPathCreateMutable();
                
                if (renderer && style==OrientationStyle_Isometric) {
                    CGPoint p1;
                    for (int i=0; i < self.points.count; i++) {
                        NSValue *value = self.points[i];
                        CGPoint point = SKTM_NSValueToCGPoint(value);
                        point = [renderer pixelToScreenCoords:point];
                        if (i==0) {
                            p1 = point;
                            CGPathMoveToPoint(pathRef, nil, 0, 0);
                        } else {
                            point.x -=p1.x;
                            point.y -=p1.y;
                            CGPathAddLineToPoint(pathRef, nil, point.x, point.y);
                        }
                    }
                } else {
                    for (int i=0; i < self.points.count; i++) {
                        NSValue *value = self.points[i];
                        CGPoint point = SKTM_NSValueToCGPoint(value);
                        if (i==0) {
                            CGPathMoveToPoint(pathRef, nil, point.x, point.y);
                        } else {
                            CGPathAddLineToPoint(pathRef, nil, point.x, -point.y);
                        }
                    }
                }
                CGPathCloseSubpath(pathRef);
//                resultPath = CGPathCreateCopyByTransformingPath(pathRef, NULL);
                resultPath = CGPathCreateCopy(pathRef);
                CGPathRelease(pathRef);
            }
            break;
            
        } case ObjectGroupType_Polyline: {
            if (self.points.count>0) {
                CGMutablePathRef pathRef = CGPathCreateMutable();
                if (renderer && style==OrientationStyle_Isometric) {
                    CGPoint p1;
                    for (int i=0; i < self.points.count; i++) {
                        NSValue *value = self.points[i];
                        CGPoint point = SKTM_NSValueToCGPoint(value);
                        point = [renderer pixelToScreenCoords:point];
                        if (i==0) {
                            p1 = point;
                            CGPathMoveToPoint(pathRef, nil, 0, 0);
                        } else {
                            point.x -=p1.x;
                            point.y -=p1.y;
                            CGPathAddLineToPoint(pathRef, nil, point.x, point.y);
                        }
                    }
                    
                    
                } else {
                    for (int i=0; i < self.points.count; i++) {
                        NSValue *value = self.points[i];
                        CGPoint point = SKTM_NSValueToCGPoint(value);
                        if (i==0) {
                            CGPathMoveToPoint(pathRef, nil, point.x, point.y);
                        } else {
                            CGPathAddLineToPoint(pathRef, nil, point.x, -point.y);
                        }
                    }
                }
//                CGPathCloseSubpath(pathRef);
//                resultPath = CGPathCreateCopyByTransformingPath(pathRef, NULL);
                resultPath = CGPathCreateCopy(pathRef);
                CGPathRelease(pathRef);
            }
            break;
            
        } case ObjectGroupType_Tile: {
            break;
            
        } default:
            break;
    }
    return (__bridge_transfer id)resultPath;
}



#pragma mark - customize
- (BOOL)isShowShape {
    if ([self.objectGroup isShowShape]) {
        return YES;
    }
    return [[self propertyForName:@"showShape"] intValue] == 1;
}





#pragma mark - Parse XML
- (BOOL)parseSelfElement:(ONOXMLElement *)element {
    NSAssert([@"object" isEqualToString:element.tag], @"ERROR: Not A object Element");
    
    self.objectId = [element[@"id"] intValue];
    self.position = CGPointMake([element[@"x"] floatValue], [element[@"y"] floatValue]);
    self.name = element[@"name"];
    self.typeStr = element[@"type"];
    self.size = CGSizeMake([element[@"width"] floatValue], [element[@"height"] floatValue]);
    id v = element[@"visible"];
    self.visible = v==nil || [v intValue]==1;
    self.rotation = [element[@"rotation"] floatValue];
    
    ONOXMLElement *properties = [element firstChildWithTag:@"properties"];
    if (properties) {
        [self readProperties:properties];
    }
    
    id gid = element[@"gid"];
    if (gid) {
        self.objGroupType = ObjectGroupType_Tile;
        uint32_t v_gid;
        sscanf([gid UTF8String], "%u", &v_gid);
        BOOL flipX = (v_gid & kTileHorizontalFlag) != 0;
        BOOL flipY = (v_gid & kTileVerticalFlag) != 0;
        BOOL flipDiag = (v_gid & kTileDiagonalFlag) != 0;
        // clear all flag
        v_gid = v_gid & kFlippedMask;
        self.tile = [self.objectGroup.map tileAtGid:v_gid];
        self.tile.flippedHorizontally = flipX;
        self.tile.flippedVertically = flipY;
        self.tile.flippedAntiDiagonally = flipDiag;
        
    } else {
        [self.points removeAllObjects];
        // ellipse check
        ONOXMLElement *subele = [element firstChildWithTag:@"ellipse"];
        if (subele) {
            self.objGroupType = ObjectGroupType_Ellipse;
        }
        
        // polygon check
        if (!subele) {
            subele = [element firstChildWithTag:@"polygon"];
            self.objGroupType = ObjectGroupType_Polygon;
            NSString *pStr = subele[@"points"];
            [self createPointsFromString:pStr];
        }
        
        // polyline check
        if (!subele) {
            subele = [element firstChildWithTag:@"polyline"];
            self.objGroupType = ObjectGroupType_Polyline;
            NSString *pStr = subele[@"points"];
            [self createPointsFromString:pStr];
        }
        
        // final check
        if (!subele) {
            self.objGroupType = ObjectGroupType_Rectangle;
        }
    }
    return YES;
}


#pragma mark - 
- (NSComparisonResult)compareObjectGroupNode:(TMXObjectGroupNode *)aNode {
    if (self.position.y < aNode.position.y) {
        return NSOrderedAscending;;
    } else if (self.position.y > aNode.position.y) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}




@end
