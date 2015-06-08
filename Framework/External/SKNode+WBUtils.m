//
//  SKNode+WBUtils.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/6.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKNode+WBUtils.h"

@implementation SKNode (WBUtils)


- (CGFloat)getGlobalZPosition {
    CGFloat zPos = self.zPosition;
    SKNode *parent = self.parent;
    while (parent) {
        zPos += parent.zPosition;
        parent = parent.parent;
    }
    return zPos;
}

- (void)setGlobalZPosition:(CGFloat)gZPos {
    CGFloat parentZPos = [self.parent getGlobalZPosition];
    self.zPosition = gZPos - parentZPos;
}



@end
