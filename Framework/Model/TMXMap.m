//
//  TMXMap.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXMap.h"
#import "TMXTile.h"
#import "TMXTileset.h"
#import "TMXTileLayer.h"
#import "TMXObjectGroup.h"
#import "TMXImageLayer.h"
#import "SKColor+TMXColorWithHex.h"

@interface TMXMap ()

//@property (nonatomic, strong)

@end


@implementation TMXMap

- (instancetype)initWithContentsOfFile:(NSString *)tmxFile {
    if (self = [self init]) {
        [self loadTMXFile:tmxFile];
    }
    return self;
}

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_Map;
    self.tilesets = [NSMutableArray array];
    self.layers = [NSMutableArray array];
}


#pragma mark -
- (TMXTile *)tileAtGid:(uint32_t)gID {
    TMXTile *tile = nil;
    for (TMXTileset *tileset in self.tilesets) {
        if (gID >= tileset.firstGid && gID < (tileset.firstGid + tileset.tileCount)) {
            tile = [[tileset tileAtIndex:(gID-tileset.firstGid)] copy];
            break;
        }
    }
    return tile;
}


- (void)clearOldData {
    [self.tilesets removeAllObjects];
    [self.layers removeAllObjects];
    
}

- (TMXTileLayer *)tileLayerWithName:(NSString *)name {
    for (TMXObject *tmxObj in self.layers) {
        if (tmxObj.objType==ObjectType_TileLayer && [name isEqualToString:tmxObj.name]) {
            return (TMXTileLayer *)tmxObj;
        }
    }
    return nil;
}
- (TMXObjectGroup *)objectLayerWithName:(NSString *)name {
    for (TMXObject *tmxObj in self.layers) {
        if (tmxObj.objType==ObjectType_ObjectGroup && [name isEqualToString:tmxObj.name]) {
            return (TMXObjectGroup *)tmxObj;
        }
    }
    return nil;
}
- (TMXImageLayer *)imageLayerWithName:(NSString *)name {
    for (TMXObject *tmxObj in self.layers) {
        if (tmxObj.objType==ObjectType_ImageLayer && [name isEqualToString:tmxObj.name]) {
            return (TMXImageLayer *)tmxObj;
        }
    }
    return nil;
}


#pragma mark - Parse XML
- (BOOL)loadTMXFile:(NSString*)tmxFile {
    // get the TMX map filename
    NSString* name = tmxFile;
    NSString* extension = nil;
    // split the extension off if there is one passed
    if ([tmxFile rangeOfString:@"."].location != NSNotFound) {
        name = [tmxFile stringByDeletingPathExtension];
        extension = [tmxFile pathExtension];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmxFile]) {
        // load the TMX map from disk
        tmxFile = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    }
    if (!tmxFile) {
        SKTMLog(@"tmxFile No Found");
        return NO;
    }
    self.fileName = [tmxFile lastPathComponent];
    self.filePath = [tmxFile stringByDeletingLastPathComponent];
    
    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[NSData dataWithContentsOfFile:tmxFile] error:&error];
    if (error) {
        SKTMLog(@"[Error] %@", error);
        return NO;
    }
    
    return [self parseSelfElement:document.rootElement];
}

- (BOOL)parseSelfElement:(ONOXMLElement *)element {
    NSAssert([@"map" isEqualToString:element.tag], @"ERROR: Not A map Element");
    [self clearOldData];
    // base data
    self.tileWidth = [element[@"tilewidth"] intValue];
    self.tileHeight = [element[@"tileheight"] intValue];
    self.width = [element[@"width"] intValue];
    self.height = [element[@"height"] intValue];
    self.hexSideLength = [element[@"hexsidelength"] intValue];
    self.orientation = [self orientationFromString:element[@"orientation"]];
    if (self.orientation==OrientationStyle_Unknown) {
        SKTMLog(@"Unsupported map orientation: %@", element[@"orientation"]);
        return NO;
    }
    self.staggerAxis = [self staggerAxisFromString:element[@"staggeraxis"]];
    self.staggerIndex = [self staggerIndexFromString:element[@"staggerindex"]];
    self.renderOrder = [self renderOrderFromString:element[@"renderorder"]];
    self.nextObjectId = [element[@"nextobjectid"] intValue];    // ?
    
    self.backgroundColor = [SKColor tmxColorWithHex:element[@"backgroundcolor"]];
    
    
    // parse child node
    for (ONOXMLElement *subElement in element.children) {
        if ([@"properties" isEqualToString:subElement.tag]) {
            [self readProperties:subElement];
            
        } else if ([@"tileset" isEqualToString:subElement.tag]) {
            TMXTileset *tileset = [TMXTileset new];
            tileset.map = self;
            [tileset parseSelfElement:subElement];
            [self.tilesets addObject:tileset];
            
        } else if ([@"layer" isEqualToString:subElement.tag]) {
            TMXTileLayer *layer = [TMXTileLayer new];
            layer.map = self;
            [layer parseSelfElement:subElement];
            [self.layers addObject:layer];
            
        } else if ([@"objectgroup" isEqualToString:subElement.tag]) {
            TMXObjectGroup *objGroup = [TMXObjectGroup new];
            objGroup.map = self;
            [objGroup parseSelfElement:subElement];
            [self.layers addObject:objGroup];
            
        } else if ([@"imagelayer" isEqualToString:subElement.tag]) {
            TMXImageLayer *imageLayer = [TMXImageLayer new];
            imageLayer.map = self;
            [imageLayer parseSelfElement:subElement];
            [self.layers addObject:imageLayer];
            
        }
    }
    
    return YES;
}


- (OrientationStyle)orientationFromString:(NSString *)str {
    if ([@"orthogonal" isEqualToString:str]) {
        return OrientationStyle_Orthogonal;
    }
    
    if ([@"isometric" isEqualToString:str]) {
        return OrientationStyle_Isometric;
    }
    
    if ([@"staggered" isEqualToString:str]) {
        return OrientationStyle_Staggered;
    }
    
    if ([@"hexagonal" isEqualToString:str]) {
        return OrientationStyle_Hexagonal;
    }
    
    return OrientationStyle_Unknown;
}

- (StaggerAxis)staggerAxisFromString:(NSString *)str {
    if ([@"x" isEqualToString:str]) {
        return StaggerAxis_StaggerX;
    }
    return StaggerAxis_StaggerY;
}

- (StaggerIndex)staggerIndexFromString:(NSString *)str {
    if ([@"even" isEqualToString:str]) {
        return StaggerIndex_StaggerEven;
    }
    return StaggerIndex_StaggerOdd;
}

- (RenderOrder)renderOrderFromString:(NSString *)str {
    if ([@"right-up" isEqualToString:str]) {
        return RenderOrder_RightUp;
    }
    
    if ([@"left-down" isEqualToString:str]) {
        return RenderOrder_LeftDown;
    }
    
    if ([@"left-up" isEqualToString:str]) {
        return RenderOrder_LeftUp;
    }
    
    return RenderOrder_RightDown;
}


@end
