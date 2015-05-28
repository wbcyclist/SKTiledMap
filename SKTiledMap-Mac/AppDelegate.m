//
//  AppDelegate.m
//  SKTiledMap-Mac
//
//  Created by JasioWoo on 15/4/10.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "AppDelegate.h"
#import "GameScene.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //    CGSize size = self.skView.bounds.size;
    //    size.width = size.width*2;
    //    size.height = size.height*2;
    GameScene *scene = [[GameScene alloc] initWithSize:CGSizeMake(1000, 600)];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    [self.skView presentScene:scene];
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
    self.skView.showsDrawCount = YES;
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
