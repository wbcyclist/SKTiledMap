//
//  TestEntity.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/15.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "TestEntity.h"

@implementation TestEntity

- (id)copyWithZone:(NSZone *)zone {
    TestEntity *entity = [[self class] new];
    entity.tile = self.tile;
    return entity;
}
@end


@implementation TestClassEntity

- (id)copyWithZone:(NSZone *)zone {
    TestClassEntity *entity = [super copyWithZone:zone];
    entity.testClassName = self.testClassName;
    return entity;
}

@end

@implementation TestCaseEntity


@end