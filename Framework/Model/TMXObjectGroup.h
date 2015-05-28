//
//  TMXObjectGroup.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/24.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TMXObject.h"


@class TMXMap;
@class TMXObjectGroupNode;

@interface TMXObjectGroup : TMXObject

@property (nonatomic, weak) TMXMap *map;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) SKColor *color;
@property (nonatomic, assign) DrawOrderType drawOrder;
@property (nonatomic, assign) float opacity;
@property (nonatomic, assign) BOOL visible;

@property (nonatomic, strong) NSMutableArray *objects;



// customize
- (BOOL)isShowShape;


- (NSArray *)sortedObjectsWithDrawOrder:(DrawOrderType)drawOrder;

@end
