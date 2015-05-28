//
//  TMXImageLayer.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/25.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXImageLayer.h"
#import "TMXMap.h"
#import "SKColor+TMXColorWithHex.h"
#import "WBImage+Utils.h"


@implementation TMXImageLayer

- (void)initDefaultValue {
    [super initDefaultValue];
    self.objType = ObjectType_ImageLayer;
}

-(void)dealloc {
    
}

- (SKTexture *)texture {
    if (!_texture) {
        if (self.imageSource) {
            // get image texture
            NSString *imgFilePath = [self.map.filePath stringByAppendingPathComponent:self.imageSource];
            if (self.transparentColor) {
                WBImage *texImage = [[WBImage alloc] initWithContentsOfFile:imgFilePath];
                if (texImage) {
                    texImage = [texImage replacingOccurrencesOfPixel:self.transparentColor withColor:[SKColor colorWithRed:.0 green:.0 blue:.0 alpha:.0]];
                }
                _texture = [SKTexture textureWithImage:texImage];
                
            } else {
                _texture = [SKTexture textureWithImageNamed:imgFilePath];
            }
            
            if (!_texture) {
                SKTMLog(@"Image Not Found: %@", self.imageSource);
            }
            _texture.filteringMode = SKTextureFilteringNearest;
        }
    }
    return _texture;
}


#pragma mark - Parse XML
- (BOOL)parseSelfElement:(ONOXMLElement *)element {
    NSAssert([@"imagelayer" isEqualToString:element.tag], @"ERROR: Not A imagelayer Element");
    
    self.name = element[@"name"];
    
    id o = element[@"opacity"];
    self.opacity = o==nil ? 1.0 : [o floatValue];
    
    id v = element[@"visible"];
    self.visible = v==nil || [v intValue]==1;
    
    self.position = CGPointMake([element[@"x"] floatValue], [element[@"y"] floatValue]);
    
    self.imageSource = nil;
    _texture = nil;
    
    ONOXMLElement *imageEle = [element firstChildWithTag:@"image"];
    if (imageEle) {
        self.imageSource = imageEle[@"source"];
        self.transparentColor = [SKColor tmxColorWithHex:imageEle[@"trans"]];
    }
    
    ONOXMLElement *properties = [element firstChildWithTag:@"properties"];
    if (properties) {
        [self readProperties:properties];
    }
    
    return YES;
}





@end
