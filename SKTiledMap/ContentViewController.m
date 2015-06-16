//
//  ContentViewController.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/6/15.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "ContentViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "ZoomTestScene.h"
#import "ZPositionTestScene.h"

#import "WBGamePad.h"

@interface ContentViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet SKView *gameView;
@property (nonatomic, strong)WBGamePad *gamePad;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
    self.gameView.showsDrawCount = YES;
    self.gameView.ignoresSiblingOrder = YES;
//    self.gameView.showsPhysics = YES;

    // game pad
    int tmp = self.view.bounds.size.height;
    CGSize dSize = CGSizeMake(150, 150);
    self.gamePad = [[WBGamePad alloc] initWithFrame:CGRectMake(0, tmp-20-dSize.width, 20+dSize.width, 20+dSize.height)
                                       withDPadSize:dSize
                                     withButtonSize:CGSizeMake(50, 50)];
    self.gamePad.buttonAView.hidden = YES;
    self.gamePad.hidden = YES;
    [self.view addSubview:self.gamePad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 添加侧滑手势
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.slidingViewController.panGesture.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除侧滑手势 (slidingViewController.panGesture只用在一个VC中)
    [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
    self.slidingViewController.panGesture.delegate = nil;
}




- (BOOL)loadTestEntity:(TestEntity *)entity {
    if ([entity isKindOfClass:[TestCaseEntity class]]) {
        TestCaseEntity *caseEntity = (TestCaseEntity*)entity;
        
        CGSize viewSize = self.view.bounds.size;
//        viewSize.width *= 2;
//        viewSize.height *= 2;
        
        SKScene *gameScene = nil;
        if ([caseEntity.classEntity.testClassName isEqualToString:@"ZoomTestScene"]) {
            gameScene = [[ZoomTestScene alloc] initWithSize:viewSize mapFile:caseEntity.tmxFile];
            
        } else if ([caseEntity.classEntity.testClassName isEqualToString:@"ZPositionTestScene"]) {
            gameScene = [[ZPositionTestScene alloc] initWithSize:viewSize mapFile:caseEntity.tmxFile];
            
        }
        
        if (!gameScene) {
            return NO;
        }
        
        gameScene.scaleMode = SKSceneScaleModeFill;
        NSArray *gestArr = self.gameView.gestureRecognizers;
        for (UIGestureRecognizer *gest in gestArr) {
            [self.gameView removeGestureRecognizer:gest];
        }
//        [self.gameView presentScene:gameScene];
        [self.gameView presentScene:gameScene transition:[SKTransition flipHorizontalWithDuration:1]];
        
        if ([gameScene respondsToSelector:@selector(setGamePad:)]) {
            self.gamePad.hidden = NO;
            [gameScene performSelectorOnMainThread:@selector(setGamePad:) withObject:self.gamePad waitUntilDone:YES];
        } else {
            self.gamePad.hidden = YES;
        }
        
        return YES;
        
    } else {
        return NO;
    }
}





#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer locationInView:gestureRecognizer.view].x <= 50.0) {
        return YES;
    }
    return NO;
}


@end
