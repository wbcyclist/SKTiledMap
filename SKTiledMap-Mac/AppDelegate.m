//
//  AppDelegate.m
//  SKTiledMap-Mac
//
//  Created by JasioWoo on 15/4/10.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "AppDelegate.h"
#import "TestEntity.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // load test data
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
            caseEntity.classEntity = classEntity;
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
