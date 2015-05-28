//
//  TMXImageLayer.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/25.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"

@class TMXMap;


@interface TMXImageLayer : TMXObject

@property (nonatomic, weak) TMXMap *map;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) float opacity;
@property (nonatomic, assign) BOOL visible;

@property (nonatomic, copy) NSString *imageSource;
@property (nonatomic, strong) SKColor *transparentColor;
@property (nonatomic, retain) SKTexture *texture;



@end
