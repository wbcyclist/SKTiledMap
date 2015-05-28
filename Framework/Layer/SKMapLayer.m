//
//  SKMapLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKMapLayer.h"

#import "SKMapRenderer.h"
#import "OrthogonalRenderer.h"

#import "SKTileLayer.h"
#import "SKObjectGroupLayer.h"
#import "SKImageLayer.h"




@interface SKMapLayer ()
@property (nonatomic, assign) int minZPosition;
@property (nonatomic, assign) int maxZPosition;

@property (nonatomic, strong) SKMapRenderer *mapRenderer;

@end

@implementation SKMapLayer

+ (instancetype)tilemapWithContentsOfFile:(NSString*)tmxFile {
    return [[self alloc] initWithContentsOfFile:tmxFile];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initDefaultValue];
    }
    return self;
}

- (instancetype)initWithContentsOfFile:(NSString*)tmxFile {
    self = [self init];
    if (self) {
        self.name = tmxFile;
        self.map = [[TMXMap alloc] initWithContentsOfFile:tmxFile];
        self.mapRenderer = [self createMapRenderer:self.map.orientation];
        [self createMapLayers];
    }
    return self;
}

- (void)initDefaultValue {
    self.zPositionIncrease = 10000;
    self.minZPosition = 0;
    self.maxZPosition = 0;
}

- (SKMapRenderer *)createMapRenderer:(OrientationStyle)ostyle {
    SKMapRenderer *mapRenderer = nil;
    if (ostyle==OrientationStyle_Orthogonal) {
        mapRenderer = [OrthogonalRenderer new];
        
    } else if (ostyle==OrientationStyle_Isometric) {
        
    } else if (ostyle==OrientationStyle_Staggered) {
        
    } else if (ostyle==OrientationStyle_Hexagonal) {
        
    }
    return mapRenderer;
}

- (void)createMapLayers {
    
    for (TMXObject *tmxObj in self.map.layers) {
        if (tmxObj.objType==ObjectType_TileLayer) {
            [self createTileLayer:(TMXTileLayer *)tmxObj];
        }
        self.maxZPosition += self.zPositionIncrease;
    }
}

- (void)createTileLayer:(TMXTileLayer *)layerData {
    SKTileLayer *tileLayer = [self drawTileLayer:layerData];
    if (tileLayer) {
        tileLayer.zPosition = self.maxZPosition;
        self.maxZPosition += self.zPositionIncrease;
        [self addChild:tileLayer];
    }
}

- (void)createObjectGroupLayer:(TMXObjectGroup *)layerData {
    
}

- (void)createImageLayer:(TMXImageLayer *)layerData {
    
}



#define SWAP(x, y) do { typeof(x) SWAP = x; x = y; y = SWAP; } while (0)

- (SKTileLayer *)drawTileLayer:(TMXTileLayer *)layerData {
    SKTileLayer *layer = [SKTileLayer node];
    
    int columnLength = layerData.map.width;
    int rowLenght = layerData.map.height;
    int tileWidth = layerData.map.tileWidth;
    int tileHeight = layerData.map.tileHeight;
    CGSize mapSize = CGSizeMake(columnLength*tileWidth, rowLenght*tileHeight);
    
    
    int startX = 0;
    int startY = 0;
    int endX = columnLength - 1;
    int endY = rowLenght - 1;
    
    int incX = 1, incY = 1;
    RenderOrder renderOrder = layerData.map.renderOrder;
    switch (renderOrder) {
        case RenderOrder_RightUp:
            SWAP(startY, endY);
            incY = -1;
            break;
        case RenderOrder_LeftDown:
            SWAP(startX, endX);
            incX = -1;
            break;
        case RenderOrder_LeftUp:
            SWAP(startX, endX);
            SWAP(startY, endY);
            incX = -1;
            incY = -1;
            break;
        case RenderOrder_RightDown:
        default:
            break;
    }
    endX += incX;
    endY += incY;
    
    int tileZIndex = 0;
    for (int y = startY; y != endY; y += incY) {
        for (int x = startX; x != endX; x += incX) {
            //            NSLog(@"x=%d, y=%d", x, y);
            //            NSLog(@"%@", array[x + y*columnLength]);
            uint32_t gid = layerData.tiles[x + y*columnLength];
            
            BOOL flipX = (gid & kTileHorizontalFlag) != 0;
            BOOL flipY = (gid & kTileVerticalFlag) != 0;
            BOOL flipDiag = (gid & kTileDiagonalFlag) != 0;
            // clear all flag
            gid = gid & kFlippedMask;
            TMXTile *tile = [layerData.map tileAtGid:gid];
            if (!tile) {
                continue;
            }
            tile.flippedHorizontally = flipX;
            tile.flippedVertically = flipY;
            tile.flippedAntiDiagonally = flipDiag;
            
            CGPoint offset = tile.tileset.tileOffset;
            SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithTexture:tile.texture];
            
//            SKNode *tileNode = [SKNode node];
//            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:tile.texture];
//            sprite.position = CGPointMake(sprite.size.width/2.0, sprite.size.height/2.0);
//            [tileNode addChild:sprite];
            
            tile.position = CGPointMake(x*tileWidth + offset.x, (y+1)*tileHeight + offset.y);
            tileNode.position = [self tileToScreenCoords:CGPointMake(tile.position.x, tile.position.y) withMapSize:mapSize];
            tileNode.zPosition = tileZIndex++;
            
            [layer addChild:tileNode];
        }
    }
    
    return layer;
}

- (CGPoint)tileToScreenCoords:(CGPoint)tPoint withMapSize:(CGSize)mapSize{
    return CGPointMake(tPoint.x, mapSize.height - tPoint.y);
}



@end
