//
//  SKTMMapLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMMapLayer.h"

#import "SKTMTileNode.h"
#import "SKTMObjectGroupTile.h"
#import "SKTMObjectGroupShape.h"
#import "SKTMTileLayer.h"
#import "SKTMObjectGroupLayer.h"
#import "SKTMImageLayer.h"




@interface SKTMMapLayer ()

@end

@implementation SKTMMapLayer

+ (instancetype)tilemapWithContentsOfFile:(NSString*)tmxFile {
    return [[self alloc] initWithContentsOfFile:tmxFile];
}

- (instancetype)initWithContentsOfFile:(NSString*)tmxFile {
    self = [self init];
    if (self) {
        self.name = tmxFile;
        self.model = [[TMXMap alloc] initWithContentsOfFile:tmxFile];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initDefaultValue];
    }
    return self;
}

- (void)initDefaultValue {
    self.zPositionIncrease = 10000;
    self.minZPosition = 0;
    self.maxZPosition = 0;
}

- (ObjectType)nodeType {
    static const ObjectType s_nodeType = ObjectType_Map;
    return s_nodeType;
}

- (void)setModel:(TMXMap *)model {
    if (_model != model) {
        _model = model;
        self.tileSize = CGSizeMake(model.tileWidth, model.tileHeight);
        self.mapSize = CGSizeMake(model.width, model.height);
        [self reloadMapModel];
    }
}

- (void)reloadMapModel {
    self.mapRenderer = [self createMapRenderer:self.model.orientation];
    self.mapRenderer.map = self.model;
    [self createMapLayers];
}

- (SKMapRenderer *)createMapRenderer:(OrientationStyle)ostyle {
    SKMapRenderer *mapRenderer = nil;
    if (ostyle==OrientationStyle_Orthogonal) {
        mapRenderer = [OrthogonalRenderer new];
        
    } else if (ostyle==OrientationStyle_Isometric) {
        mapRenderer = [IsometricRenderer new];
        
    } else if (ostyle==OrientationStyle_Staggered) {
        mapRenderer = [StaggeredRenderer new];
        
    } else if (ostyle==OrientationStyle_Hexagonal) {
        mapRenderer = [HexagonalRenderer new];
    }
    return mapRenderer;
}

- (void)clearMapLayers {
    [self removeAllChildren];
    [self initDefaultValue];
}

- (void)createMapLayers {
    [self clearMapLayers];
    
    for (TMXObject *tmxObj in self.model.layers) {
        if (tmxObj.objType==ObjectType_TileLayer) {
            [self createTileLayer:(TMXTileLayer *)tmxObj];
        } else if (tmxObj.objType==ObjectType_ObjectGroup) {
            [self createObjectGroupLayer:(TMXObjectGroup *)tmxObj];
        } else if (tmxObj.objType==ObjectType_ImageLayer) {
            [self createImageLayer:(TMXImageLayer *)tmxObj];
        }
        self.maxZPosition += self.zPositionIncrease;
    }
}

- (void)createTileLayer:(TMXTileLayer *)layerData {
    SKTMTileLayer *tileLayer = [self.mapRenderer drawTileLayer:layerData];
    if (tileLayer) {
        tileLayer.zPosition = self.maxZPosition;
        self.maxZPosition += self.zPositionIncrease;
        [self addChild:tileLayer];
    }
}

- (void)createObjectGroupLayer:(TMXObjectGroup *)layerData {
    SKTMObjectGroupLayer *objGroupLayer = [self.mapRenderer drawObjectGroupLayer:layerData];
    if (objGroupLayer) {
        objGroupLayer.zPosition = self.maxZPosition;
        self.maxZPosition += self.zPositionIncrease;
        [self addChild:objGroupLayer];
    }
}

- (void)createImageLayer:(TMXImageLayer *)layerData {
    SKTMImageLayer *imageLayer = [self.mapRenderer drawImageLayer:layerData];
    if (imageLayer) {
        imageLayer.zPosition = self.maxZPosition;
        self.maxZPosition += self.zPositionIncrease;
        [self addChild:imageLayer];
    }
}



#pragma mark - get sub layers
- (SKTMLayer *)allLayerWithName:(NSString *)name {
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMLayer class]] && [node.name isEqualToString:name]) {
            return (SKTMLayer*)node;
        }
    }
    return nil;
}

- (SKTMLayer *)allLayerAtIndex:(NSUInteger)index {
    int currentIndex = 0;
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMLayer class]]) {
            if (currentIndex == index) {
                return (SKTMLayer *)node;
            }
            currentIndex++;
        }
    }
    return nil;
}

- (SKTMTileLayer *)tileLayerWithName:(NSString *)name {
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMTileLayer class]] && [node.name isEqualToString:name]) {
            return (SKTMTileLayer *)node;
        }
    }
    return nil;
}

- (SKTMTileLayer *)tileLayerAtIndex:(NSUInteger)index {
    int currentIndex = 0;
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMTileLayer class]]) {
            if (currentIndex == index) {
                return (SKTMTileLayer *)node;
            }
            currentIndex++;
        }
    }
    return nil;
}

- (SKTMObjectGroupLayer *)objectLayerWithName:(NSString *)name {
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMObjectGroupLayer class]] && [node.name isEqualToString:name]) {
            return (SKTMObjectGroupLayer *)node;
        }
    }
    return nil;
}

- (SKTMObjectGroupLayer *)objectLayerAtIndex:(NSUInteger)index {
    int currentIndex = 0;
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMObjectGroupLayer class]]) {
            if (currentIndex == index) {
                return (SKTMObjectGroupLayer *)node;
            }
            currentIndex++;
        }
    }
    return nil;
}

- (SKTMImageLayer *)imageLayerWithName:(NSString *)name {
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMImageLayer class]] && [node.name isEqualToString:name]) {
            return (SKTMImageLayer *)node;
        }
    }
    return nil;
}

- (SKTMImageLayer *)imageLayerAtIndex:(NSUInteger)index {
    int currentIndex = 0;
    for (SKNode *node in self.children) {
        if ([node isKindOfClass:[SKTMImageLayer class]]) {
            if (currentIndex == index) {
                return (SKTMImageLayer *)node;
            }
            currentIndex++;
        }
    }
    return nil;
}








@end
