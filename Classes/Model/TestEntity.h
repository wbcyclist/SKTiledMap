//
//  TestEntity.h
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/15.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define WBImage UIImage
#else
    #import <AppKit/AppKit.h>
    #define WBImage NSImage
#endif


@interface TestEntity : NSObject

@property (nonatomic, copy)NSString *tile;

@end

@interface TestClassEntity : TestEntity

@property (nonatomic, copy)NSString *testClassName;

@end

@interface TestCaseEntity : TestEntity

@property (nonatomic, copy)NSString *tmxFile;
@property (nonatomic, strong)WBImage *thumbnailImage;


@end