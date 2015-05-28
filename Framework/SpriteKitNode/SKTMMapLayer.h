//
//  SKTMMapLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/28.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMLayer.h"

@interface SKTMMapLayer : SKTMLayer

@property (nonatomic, strong) TMXMap *model;

+ (instancetype)tilemapWithContentsOfFile:(NSString*)tmxFile;
- (instancetype)initWithContentsOfFile:(NSString*)tmxFile;


@end
