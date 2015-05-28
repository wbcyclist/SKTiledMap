//
//  TMXMap.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"

@class TMXTile;
@class TMXTileset;
@class TMXTileLayer;
@class TMXObjectGroup;
@class TMXImageLayer;

@interface TMXMap : TMXObject

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) OrientationStyle orientation;
@property (nonatomic, assign) RenderOrder renderOrder;
@property (nonatomic, assign) StaggerAxis staggerAxis;
@property (nonatomic, assign) StaggerIndex staggerIndex;
@property (nonatomic, assign) LayerDataFormat layerDataFormat;
@property (nonatomic, assign) uint32_t width;
@property (nonatomic, assign) uint32_t height;
@property (nonatomic, assign) uint32_t tileWidth;
@property (nonatomic, assign) uint32_t tileHeight;
@property (nonatomic, assign) int hexSideLength;
@property (nonatomic, assign) int nextObjectId;
@property (nonatomic, copy) SKColor *backgroundColor;


@property (nonatomic, strong) NSMutableArray *tilesets;
@property (nonatomic, strong) NSMutableArray *layers;   // tileLayer, objectgroupLayer, imageLayer


- (instancetype)initWithContentsOfFile:(NSString*)tmxFile;


- (TMXTile*)tileAtGid:(uint32_t)gID;

- (BOOL)loadTMXFile:(NSString*)tmxFile;






@end
