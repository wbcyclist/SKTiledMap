//
//  TMXTileLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/26.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXTileLayer.h"
#import "TMXMap.h"
#import "SKZipUtils.h"

@implementation TMXTileLayer

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_TileLayer;
}

- (void)dealloc {
    if (_tiles) {
        free(_tiles);
        _tiles = nil;
    }
}

- (void)setTiles:(uint32_t *)tiles {
    if (_tiles && _tiles != tiles) {
        free(_tiles);
        _tiles = nil;
    }
    _tiles = tiles;
}



#pragma mark - Parse XML
- (BOOL)parseSelfElement:(ONOXMLElement *)element {
    NSAssert([@"layer" isEqualToString:element.tag], @"ERROR: Not A layer Element");
    
    self.name = element[@"name"];
    self.width = [element[@"width"] intValue];
    self.height = [element[@"height"] intValue];
    
    id o = element[@"opacity"];
    self.opacity = o==nil ? 1.0 : [o floatValue];
    
    id v = element[@"visible"];
    self.visible = v==nil || [v intValue]==1;
    
    
    for (ONOXMLElement *subElement in element.children) {
        if ([@"properties" isEqualToString:subElement.tag]) {
            [self readProperties:subElement];
            
        } else if ([@"data" isEqualToString:subElement.tag]) {
            [self parseDataElement:subElement];
        }
    }
    
    return YES;
}

- (BOOL)parseDataElement:(ONOXMLElement *)element {
    NSString *encoding = element[@"encoding"];
    NSString *compression = element[@"compression"];
    
    NSString *dataStr = nil;
    if ([@"base64" isEqualToString:encoding]) {
        self.map.layerDataFormat = LayerDataFormat_Base64;
        if([@"gzip" isEqualToString:compression])
            self.map.layerDataFormat |= LayerDataFormat_Base64Gzip;
        else if([@"zlib" isEqualToString:compression])
            self.map.layerDataFormat |= LayerDataFormat_Base64Zlib;
        
        // clean whitespace from string
        dataStr = element.stringValue;
        dataStr = [NSMutableString stringWithString:[dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSData* buffer = [[NSData alloc] initWithBase64EncodedString:dataStr options:0];
        if( self.map.layerDataFormat & (LayerDataFormat_Base64Gzip | LayerDataFormat_Base64Zlib) ) {
            buffer = [SKZipUtils decompress:buffer];
        }
        if (!buffer.length) {
            SKTMLog(@"TiledMap: decode data error");
            return NO;
        }
        char* tileArray = malloc(buffer.length);
        memmove(tileArray, buffer.bytes, buffer.length);
        self.tiles = (uint32_t*) tileArray;
        
    } else if ([@"csv" isEqualToString:encoding]) {
        self.map.layerDataFormat = LayerDataFormat_CSV;
        
        dataStr = element.stringValue;
        dataStr = [NSMutableString stringWithString:[dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSArray *gids = [dataStr componentsSeparatedByString:@","];
        
        NSUInteger gidCount = [gids count];
        unsigned int tileCount = self.width*self.height;
        self.tiles = malloc(tileCount * sizeof(uint32_t));
        NSString *gid;
        for (uint32_t i=0; i<tileCount; i++) {
            if (i < gidCount) {
                gid = gids[i];
            } else {
                gid = @"0";
            }
            uint32_t n;
            sscanf([gid UTF8String], "%u", &n);
            _tiles[i] = n;
        }
        
    } else {
        self.map.layerDataFormat = LayerDataFormat_XML;
        
        NSArray *gids = element.children;
        NSUInteger gidCount = [gids count];
        unsigned int tileCount = self.width*self.height;
        self.tiles = malloc(tileCount * sizeof(uint32_t));
        NSString *gid;
        for (uint32_t i=0; i<tileCount; i++) {
            if (i < gidCount) {
                ONOXMLElement *sub = gids[i];
                gid = sub[@"gid"];
            } else {
                gid = @"0";
            }
            uint32_t n;
            sscanf([gid UTF8String], "%u", &n);
            _tiles[i] = n;
        }
    }
    
    return YES;
}



@end
