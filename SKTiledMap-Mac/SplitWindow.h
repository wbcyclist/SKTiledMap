//
//  SplitWindow.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface SplitWindow : NSWindow <NSSplitViewDelegate>

@property (nonatomic, weak)IBOutlet NSSplitView *splitView;
@property (nonatomic, weak)IBOutlet NSView *leftView;
@property (nonatomic, weak)IBOutlet NSView *rightView;

@property (nonatomic, weak)IBOutlet SKView *gameView;

@property (nonatomic, strong) NSMutableArray *testDatas;




@end
