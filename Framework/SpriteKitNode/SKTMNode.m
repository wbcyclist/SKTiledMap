//
//  SKTMNode.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/27.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKTMNode.h"

@interface SKTMNode ()

@end


@implementation SKTMNode

- (instancetype)init {
    return self = [super init];
}

+ (instancetype)nodeWithModel:(TMXObject *)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(TMXObject *)model {
    self = [self init];
    if (self) {
        if (model.objType==[self nodeType] && [self respondsToSelector:@selector(setModel:)]) {
//            [self performSelector:@selector(setModel:) withObject:model];
            [self performSelector:@selector(setModel:) onThread:[NSThread currentThread] withObject:model waitUntilDone:YES];
        }
    }
    return self;
}

- (void)setModel:(TMXObject *)model {
    
}

- (void)setupModel {
    [self removeAllChildren];
}

- (int)zPositionIncrease {
    if (_zPositionIncrease == 0) {
        _zPositionIncrease = 1;
    }
    return _zPositionIncrease;
}

- (ObjectType)nodeType {
    return 0;
}


@end
