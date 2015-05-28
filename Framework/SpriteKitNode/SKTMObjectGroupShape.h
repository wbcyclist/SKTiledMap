//
//  SKTMObjectGroupShape.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/29.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMNode.h"

@interface SKTMObjectGroupShape : SKTMNode

@property (nonatomic, strong) TMXObjectGroupNode *model;

@property (nonatomic, strong) SKShapeNode *shape;

@end
