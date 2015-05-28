//
//  SKTMNode.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/27.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TMXBase.h"


@interface SKTMNode : SKNode 

@property (nonatomic, assign) int minZPosition;
@property (nonatomic, assign) int maxZPosition;
@property (nonatomic, assign) int zPositionIncrease;


+ (instancetype)nodeWithModel:(TMXObject *)model;
- (instancetype)initWithModel:(TMXObject *)model;

- (ObjectType)nodeType;

- (void)setupModel;




@end
