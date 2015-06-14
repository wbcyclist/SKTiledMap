//
//  AppDelegate.m
//  SKTiledMap-Mac
//
//  Created by JasioWoo on 15/4/10.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "AppDelegate.h"
#import "TestEntity.h"
#import "GameScene.h"
#import "ZoomTestScene.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.skView.ignoresSiblingOrder = YES;
    self.skView.showsDrawCount = YES;
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
//    self.skView.showsPhysics = YES;
    
    
    //    CGSize size = self.skView.bounds.size;
    //    size.width = size.width*2;
    //    size.height = size.height*2;
//    CGSize size = CGSizeMake(1500, 900);
    
//    GameScene *scene = [[GameScene alloc] initWithSize:size];
//    ZoomTestScene *scene = [[ZoomTestScene alloc] initWithSize:size mapFile:@"TiledMap/Orthogonal/02.tmx"];
//    ZoomTestScene *scene = [[ZoomTestScene alloc] initWithSize:size mapFile:@"TiledMap/Isometric/03.tmx"];
//    ZoomTestScene *scene = [[ZoomTestScene alloc] initWithSize:size mapFile:@"TiledMap/Staggered/05.tmx"];
//    ZoomTestScene *scene = [[ZoomTestScene alloc] initWithSize:size mapFile:@"TiledMap/Hexagonal/01.tmx"];
    
//    scene.scaleMode = SKSceneScaleModeAspectFit;
//    [self.skView presentScene:scene];
    
    
    // load data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ExampleData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *pfDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *testDatas = [NSMutableArray array];
    for (NSDictionary *data in pfDic) {
        TestClassEntity *classEntity = [TestClassEntity new];
        classEntity.tile = data[@"Tile"];
        classEntity.testClassName = data[@"TestClass"];
        [testDatas addObject:classEntity];
        
        for (NSDictionary *caseData in data[@"Cases"]) {
            TestCaseEntity *caseEntity = [TestCaseEntity new];
            caseEntity.tile = caseData[@"Name"];
            caseEntity.tmxFile = caseData[@"TMXFile"];
            NSString *imgFile = [[NSBundle mainBundle] pathForResource:caseData[@"Thumbnail"] ofType:nil];
            caseEntity.thumbnailImage = [[NSImage alloc] initWithContentsOfFile:imgFile];
            [testDatas addObject:caseEntity];
        }
    }
    self.window.testDatas = testDatas;
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
