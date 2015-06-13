//
//  SKView+ScrollTouchForwarding.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/11.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKView+ScrollTouchForwarding.h"

@implementation SKView (ScrollTouchForwarding)

- (void)scrollWheel:(NSEvent *)theEvent {
    [self.scene scrollWheel:theEvent];
}

- (void)magnifyWithEvent:(NSEvent *)event {
    [self.scene magnifyWithEvent:event];
}

- (void)rotateWithEvent:(NSEvent *)event {
    [self.scene rotateWithEvent:event];
}

- (void)swipeWithEvent:(NSEvent *)event {
    [self.scene swipeWithEvent:event];
}

@end
