//
//  SKNode+WBUtils.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/6.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKNode+WBUtils.h"

@implementation SKNode (WBUtils)


- (CGFloat)globalZPosition {
    CGFloat zPos = self.zPosition;
    SKNode *parent = self.parent;
    while (parent) {
        zPos += parent.zPosition;
        parent = parent.parent;
    }
    return zPos;
}

- (void)setupGlobalZPosition:(CGFloat)gZPos {
    CGFloat parentZPos = [self.parent globalZPosition];
    self.zPosition = gZPos - parentZPos;
}



@end
