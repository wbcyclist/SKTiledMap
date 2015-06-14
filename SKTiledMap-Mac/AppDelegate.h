//
//  AppDelegate.h
//  SKTiledMap-Mac
//

//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "SplitWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak) IBOutlet SplitWindow *window;
@property (nonatomic, weak) IBOutlet SKView *skView;

@end
